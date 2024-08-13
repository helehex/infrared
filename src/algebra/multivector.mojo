# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from collections import Optional
from ..utils import SmallArray


# +----------------------------------------------------------------------------------------------+ #
# | Helper Functions
# +----------------------------------------------------------------------------------------------+ #
#
fn generate_basis2entry(mask: List[Bool]) -> List[Int]:
    # TODO: I tried making this return a List[Optional[Bool]],
    #       but something breaks when using it at ctime.
    var result = List[Int](capacity=len(mask))
    var count = 0
    for basis in range(len(mask)):
        if mask[basis]:
            result += count
            count += 1
        else:
            result += -1
    return result^


fn count_true(mask: List[Bool]) -> Int:
    var count = 0
    for basis in range(len(mask)):
        count += int(mask[basis])
    return count


fn generate_entry2basis(mask: List[Bool]) -> List[Int]:
    var result = List[Int](capacity=count_true(mask))
    for basis in range(len(mask)):
        if mask[basis]:
            result += basis
    return result^


fn or_mask(a: List[Bool], b: List[Bool]) -> List[Bool]:
    var result = List[Bool](capacity=len(a))
    for idx in range(len(a)):
        result += a[idx] | b[idx]
    return result^


fn mul_mask[sig: Signature](a: List[Bool], b: List[Bool]) -> List[Bool]:
    # TODO: There's probably a better way todo this
    var result = sig.empty_mask()

    @parameter
    for x in range(sig.dims):
        if a[x]:

            @parameter
            for y in range(sig.dims):
                if b[y]:
                    result[sig.mult[x][y].basis] |= sig.mult[x][y].sign != 0
    return result


# +----------------------------------------------------------------------------------------------+ #
# | Multivector
# +----------------------------------------------------------------------------------------------+ #
#
@value
struct Multivector[sig: Signature, mask: List[Bool], type: DType = DType.float64]:
    """Multivector."""

    # +------[ Alias ]------+ #
    #
    alias basis2entry = generate_basis2entry(mask)
    alias entry2basis = generate_entry2basis(mask)
    alias entry_count = count_true(mask)
    alias DataType = SmallArray[Scalar[type], Self.entry_count]

    # +------< Data >------+ #
    #
    var _data: Self.DataType

    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__[init_data: Bool = True](inout self):
        self._data.__init__[False]()

        @parameter
        if init_data:

            @parameter
            for entry in range(Self.entry_count):
                self._data[entry] = 0

    @always_inline("nodebug")
    fn __init__(inout self: Multivector[sig, sig.scalar_mask(), type], s: Scalar[type]):
        self.__init__[False]()
        self._data[0] = s

        @parameter
        for entry in range(1, Self.entry_count):
            self._data[entry] = 0

    @always_inline("nodebug")
    fn __init__(inout self, owned *coefs: Scalar[type]):
        self.__init__[False]()
        self._data.__init__(storage=coefs^)

    @always_inline("nodebug")
    fn __str__(self) -> String:
        alias len = self.entry_count - 1
        var result: String = "-" if self._data[0] < 0 else "+"

        @parameter
        for entry in range(len):
            result += str(abs(self._data[entry])) + " [" + str(self.entry2basis[entry])
            if self._data[entry + 1] < 0:
                result += "] - "
            else:
                result += "] + "
        return result + str(abs(self._data[len])) + " [" + str(self.entry2basis[len]) + "]"

    # +------( Comparison )------+ #
    #
    fn __eq__(self, other: Multivector[sig, _, type]) -> Bool:

        @parameter
        for basis in range(sig.dims):
            alias self_entry = self.basis2entry[basis]
            alias other_entry = other.basis2entry[basis]

            @parameter
            if (self_entry != -1) and (other_entry != -1):
                if self._data[self_entry] != other._data[other_entry]:
                    return False
            elif (self_entry != -1):
                if self._data[self_entry] != 0:
                    return False
            elif (other_entry != -1):
                if self._data[other_entry] != 0:
                    return False

        return True

    fn __ne__(self, other: Multivector[sig, _, type]) -> Bool:

        @parameter
        for basis in range(sig.dims):
            alias self_entry = self.basis2entry[basis]
            alias other_entry = other.basis2entry[basis]

            @parameter
            if (self_entry != -1) and (other_entry != -1):
                if self._data[self_entry] != other._data[other_entry]:
                    return True
            elif (self_entry != -1):
                if self._data[self_entry] != 0:
                    return True
            elif (other_entry != -1):
                if self._data[other_entry] != 0:
                    return True

        return False

    # +------( Unary )------+ #
    #
    fn __neg__(self) -> Self:
        var result: Multivector[sig, mask, type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            result._data[entry] = -self._data[entry]

        return result

    fn __inverse__(self) -> Self:
        return self.__rev__()

    fn __rev__(self) -> Self:
        """Reversion operator, reverses the subscript of each basis element."""
        var result: Multivector[sig, mask, type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias sign = (1 - (((sig.grade_of[self.entry2basis[entry]] // 2) % 2) * 2))
            result._data[entry] = self._data[entry] * sign

        return result

    fn __invo__(self) -> Self:
        """Involution operator, reverses the subscript of each basis element."""
        var result: Multivector[sig, mask, type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias sign = (((sig.grade_of[self.entry2basis[entry]] % 2) * 2) - 1)
            result._data[entry] = self._data[entry] * sign

        return result

    fn __conj__(self) -> Self:
        """Reversion operator, reverses the subscript of each basis element."""
        var result: Multivector[sig, mask, type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias sign = (((((sig.grade_of[self.entry2basis[entry]] + 3) // 2) % 2) * 2) - 1)
            result._data[entry] = self._data[entry] * sign

        return result

    fn __dual__(self) -> Self:
        """Dualization operator, currently just reverses coefficients."""
        var result: Multivector[sig, mask, type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            result._data[entry] = self._data[(result.entry_count - 1) - entry]

        return result

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(
        self, other: Multivector[sig, _, type]
    ) -> Multivector[sig, or_mask(mask, other.mask), type]:
        var result: Multivector[sig, or_mask(mask, other.mask), type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias result_basis = result.entry2basis[entry]
            alias self_entry = self.basis2entry[result_basis]
            alias other_entry = other.basis2entry[result_basis]

            @parameter
            if (self_entry != -1) and (other_entry != -1):
                result._data[entry] = self._data[self_entry] + other._data[other_entry]
            elif (self_entry != -1):
                result._data[entry] = self._data[self_entry]
            elif (other_entry != -1):
                result._data[entry] = other._data[other_entry]

        return result

    @always_inline("nodebug")
    fn __sub__(
        self, other: Multivector[sig, _, type]
    ) -> Multivector[sig, or_mask(mask, other.mask), type]:
        var result: Multivector[sig, or_mask(mask, other.mask), type]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias result_basis = result.entry2basis[entry]
            alias self_entry = self.basis2entry[result_basis]
            alias other_entry = other.basis2entry[result_basis]

            @parameter
            if (self_entry != -1) and (other_entry != -1):
                result._data[entry] = self._data[self_entry] - other._data[other_entry]
            elif (self_entry != -1):
                result._data[entry] = self._data[self_entry]
            elif (other_entry != -1):
                result._data[entry] = -other._data[other_entry]

        return result

    fn __mul__(
        lhs, rhs: Multivector[sig, _, type]
    ) -> Multivector[sig, mul_mask[sig](mask, rhs.mask), type]:
        var result: Multivector[sig, mul_mask[sig](mask, rhs.mask), type]
        result.__init__[True]()

        @parameter
        for lhs_entry in range(lhs.entry_count):

            @parameter
            for rhs_entry in range(rhs.entry_count):
                alias lhs_basis = lhs.entry2basis[lhs_entry]
                alias rhs_basis = rhs.entry2basis[rhs_entry]
                # These have to be var's, otherwise it crashes
                var signed_basis = sig.mult[lhs_basis][rhs_basis]
                var entry = result.basis2entry[signed_basis.basis]
                var sign = signed_basis.sign
                if sign != 0:
                    result._data[entry] += sign * lhs._data[lhs_entry] * rhs._data[rhs_entry]
        return result
