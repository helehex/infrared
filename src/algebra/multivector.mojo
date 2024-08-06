# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


alias Mask = InlineArray[Bool, _]


# +----------------------------------------------------------------------------------------------+ #
# | Helper Functions
# +----------------------------------------------------------------------------------------------+ #
#
fn _generate_basis2entry[size: Int, //, mask: Mask[size]]() -> InlineArray[Optional[Int], size]:
    var result = InlineArray[Optional[Int], size](unsafe_uninitialized=True)
    var count = 0
    @parameter
    for basis in range(size):
        if mask[basis]:
            result[basis] = count
            count += 1
        else:
            result[basis] = None
    return result


fn _count_true(mask: Mask[_]) -> Int:
    var count = 0
    @parameter
    for basis in range(mask.size):
        count += int(mask[basis])
    return count


fn _generate_entry2basis[size: Int, //, mask: Mask[size]]() -> InlineArray[Int, _count_true(mask)]:
    var result = InlineArray[Int, _count_true(mask)](unsafe_uninitialized=True)
    var count = 0
    @parameter
    for basis in range(size):
        if mask[basis]:
            result[count] = basis
            count += 1
    return result


fn _or_mask[size: Int](a: Mask[size], b: Mask[size]) -> Mask[size]:
    var result = Mask[size](unsafe_uninitialized=True)
    @parameter
    for idx in range(size):
        result[idx] = a[idx] | b[idx]
    return result


# from bit import bit_ceil


# +----------------------------------------------------------------------------------------------+ #
# | Multivector
# +----------------------------------------------------------------------------------------------+ #
#
@value
struct Multivector[type: DType, po: Int, ne: Int, ze: Int, mask: Mask[Signature[po, ne, ze].dims()]]:
    """Multivector."""

    # +------[ Alias ]------+ #
    #
    alias signature = Signature[po, ne, ze]
    alias basis2entry = _generate_basis2entry[mask]()
    alias entry2basis = _generate_entry2basis[mask]()
    alias entry_count = _count_true(mask)
    alias DataType = InlineArray[Scalar[type], Self.entry_count]

    # +------< Data >------+ #
    #
    var _data: Self.DataType

    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__[zero: Bool = True](inout self):
        self._data = Self.DataType(unsafe_uninitialized=True)
        @parameter
        if zero:
            @parameter
            for entry in range(Self.entry_count):
                self._data = 0

    @always_inline("nodebug")
    fn __init__(inout self, s: Scalar[type]):
        constrained[mask[0]]()
        self = Self()
        self._data[0] = s

    @always_inline("nodebug")
    fn __init__(inout self, *, e1: Scalar[type], e2: Scalar[type]):
        constrained[bool(Self.basis2entry[1]) and bool(Self.basis2entry[2])]()
        self = Self()
        self._data[Self.basis2entry[1].value()] = e1
        self._data[Self.basis2entry[2].value()] = e2

    @always_inline("nodebug")
    fn __str__(self) -> String:
        alias len = self.entry_count - 1
        var result: String = ""
        @parameter
        for entry in range(len):
            result += str(abs(self._data[entry])) + " [" + str(self.entry2basis[entry])
            if self._data[entry + 1] < 0:
                result += "] - "
            else:
                result += "] + "
        return result + str(abs(self._data[len])) + " [" + str(self.entry2basis[len]) + "]"


    @always_inline("nodebug")
    fn __add__(self, other: Multivector[type, po, ne, ze, _]) -> Multivector[type, po, ne, ze, _or_mask(mask, other.mask)]:
        var result: Multivector[type, po, ne, ze, _or_mask(mask, other.mask)]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias result_basis = result.entry2basis[entry]
            alias self_entry = self.basis2entry[result_basis]
            alias other_entry = other.basis2entry[result_basis]
            @parameter
            if self_entry and other_entry:
                result._data[entry] = self._data[self_entry.value()] + other._data[other_entry.value()]
            elif self_entry:
                result._data[entry] = self._data[self_entry.value()]
            elif other_entry:
                result._data[entry] = other._data[other_entry.value()]

        return result

    @always_inline("nodebug")
    fn __sub__(self, other: Multivector[type, po, ne, ze, _]) -> Multivector[type, po, ne, ze, _or_mask(mask, other.mask)]:
        var result: Multivector[type, po, ne, ze, _or_mask(mask, other.mask)]
        result.__init__[False]()

        @parameter
        for entry in range(result.entry_count):
            alias result_basis = result.entry2basis[entry]
            alias self_entry = self.basis2entry[result_basis]
            alias other_entry = other.basis2entry[result_basis]
            @parameter
            if self_entry and other_entry:
                result._data[entry] = self._data[self_entry.value()] - other._data[other_entry.value()]
            elif self_entry:
                result._data[entry] = self._data[self_entry.value()]
            elif other_entry:
                result._data[entry] = -other._data[other_entry.value()]

        return result