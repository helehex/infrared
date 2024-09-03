# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from ..io.ansi import Color


# +----------------------------------------------------------------------------------------------+ #
# | Signed Basis
# +----------------------------------------------------------------------------------------------+ #
#
@value
@register_passable("trivial")
struct SignedBasis:
    # +------< Data >------+ #
    #
    var sign: Int
    var basis: Int

    @always_inline
    fn __init__(inout self):
        self.sign = 0
        self.basis = 0

    @always_inline
    fn expand(self, sig: Signature) -> List[Int]:
        var result = List[Int](capacity=sig.grade_of[self.basis])
        var k = sig.grade_of[self.basis]
        var r = sig.index_in_grade[self.basis] + 1
        var j = 0

        for s in range(1, k + 1):
            var cs = j + 1
            while r - pascal(sig.vecs - cs, k - s) > 0:
                r -= pascal(sig.vecs - cs, k - s)
                cs += 1
            result += cs
            j = cs
        return result^

    @no_inline
    fn __str__(self) -> String:
        var str_sign: StringLiteral
        if self.sign < 0:
            str_sign = "-"
        elif self.sign > 0:
            str_sign = "+"
        else:
            str_sign = " "
        return str_sign + str(self.basis)

    @no_inline
    fn __str__(self, sig: Signature) -> String:
        var result = String()
        var writer = Formatter(result)
        self.format_to(writer, sig)
        return result

    @no_inline
    fn format_to(self, inout writer: Formatter, sig: Signature):
        var align = len(str(sig.dims)) + 1
        var str_sign: StringLiteral
        if self.sign < 0:
            str_sign = "-"
        elif self.sign > 0:
            str_sign = "+"
        else:
            str_sign = " "
        writer.write(Color.colors[sig.grade_of[self.basis] % 8] if self.sign else Color.grey)
        writer.write((str(self.basis) if self.sign != 0 else "").rjust(align, str_sign))
        writer.write(Color.clear)

    fn __eq__(lhs, rhs: Self) -> Bool:
        return lhs.sign == rhs.sign and lhs.basis == rhs.basis

    fn __ne__(lhs, rhs: Self) -> Bool:
        return lhs.sign != rhs.sign or lhs.basis != rhs.basis


fn signed_sort(inout basis: List[Int]) -> Int:
    var count = 0
    for i in range(1, len(basis)):
        var j = i
        while j > 0 and basis[j] < basis[j - 1]:
            count += 1
            var temp = basis[j - 1]
            basis[j - 1] = basis[j]
            basis[j] = temp
            j -= 1
    return count


fn count_odd(array: List[Int]) -> Int:
    var count = 0
    var i = 1
    var m = 0
    while i < array.size:
        if array[i - 1] != array[i]:
            if i % 2 != m:
                count += 1
            m = i % 2
        i += 1

    if array.size % 2 != m:
        count += 1

    return count
