# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from ..io.ansi import Color


# TODO: Having these parameterized on sig might not be the best idea...
#       It seems the best way to get both ctime and rtime performance,
#       would be to pass sig as args and call them at ctime if desired.


# # +----------------------------------------------------------------------------------------------+ #
# # | Expanded Basis
# # +----------------------------------------------------------------------------------------------+ #
# #
# @value
# struct ExpandedBasis[sig: Signature]:

#     # +------< Data >------+ #
#     #
#     var vecs: List[Int]

#     @always_inline
#     fn sort(inout self) -> Int:
#         var sign = 1

#         for i in range(1, len(self)):
#             var j = i
#             while j > 0 and self.vecs[j] < self.vecs[j - 1]:
#                 sign *= -1
#                 swap(self.vecs[j - 1], self.vecs[j])
#                 j -= 1

#         return sign

#     @always_inline
#     fn squash(inout self):
#         var result = List[Int]()

#         var i = 1
#         var j = 0
#         while i < len(self):
#             if self.vecs[i] != self.vecs[i - 1]:
#                 result += self.vecs[i - 1]
#                 i += 1
#                 j += 1
#             else:
#                 i += 2

#         if i == len(self):
#             result += self.vecs[len(self) - 1]

#         self = result^

#     @always_inline
#     fn reduce(owned self) -> SignedBasis[sig]:
#         if len(self) == 0:
#             return SignedBasis[sig](1, 0)
#         elif len(self) == 1:
#             return SignedBasis[sig](1, self.vecs[0])
#         else:
#             var temp = self.sort()
#             self.squash()
#             return SignedBasis[sig](temp, self.order())

#     @always_inline
#     fn order(self) -> Int:
#         # return sig.order_of_expanded(self.vecs)

#         # var combs = sig.combs
#         # for i in range(len(combs)):
#         #     if len(combs[i]) != len(self):
#         #         continue
#         #     var result = i
#         #     for j in range(len(self)):
#         #         if combs[i][j] != self.vecs[j]:
#         #             result = -1
#         #             break
#         #     if result != -1:
#         #         return result
#         # return -1

#         # var grade_dims = sig.grade_dims
#         var result = pascal(sig.vecs, len(self))

#         for i in range(len(self)):
#             result += pascal(sig.vecs, i)
#             var n = sig.vecs - self.vecs[i]
#             var k = len(self) - i
#             if n >= k:
#                 result -= pascal(n, k)

#         return result - 1

#     @always_inline
#     fn __add__(self, other: Self) -> Self:
#         return self.vecs.__add__(other.vecs)

#     @always_inline
#     fn __len__(self) -> Int:
#         return self.vecs.__len__()

#     @no_inline
#     fn __str__(self) -> String:
#         var result: String = "["
#         for idx in range(len(self) - 1):
#             result += str(self.vecs[idx]) + "^"
#         if len(self) > 0:
#             result += str(self.vecs[len(self) - 1])
#         return result + "]"


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

    # @always_inline
    # fn expand(self) -> List[Int]:
    #     var result = List[Int](capacity=sig.grade_of[self.basis])
    #     alias n = sig.vecs
    #     var k = sig.grade_of[self.basis]
    #     var r = sig.index_in_grade[self.basis] + 1
    #     var j = 0

    #     for s in range(1, k + 1):
    #         var cs = j + 1
    #         while r - pascal(sig.vecs - cs, k - s) > 0:
    #             r -= pascal(sig.vecs - cs, k - s)
    #             cs += 1
    #         result += cs
    #         j = cs
    #     return result^

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


# @value
# struct SignedBasis[sig: Signature]:

#     # +------< Data >------+ #
#     #
#     var sign: Int
#     var basis: Int

#     @always_inline
#     fn expand(self) -> ExpandedBasis[sig]:
#         var result = List[Int](capacity=sig.grade_of[self.basis])
#         alias n = sig.vecs
#         var k = sig.grade_of[self.basis]
#         var r = sig.index_in_grade[self.basis] + 1
#         var j = 0

#         for s in range(1, k + 1):
#             var cs = j + 1
#             while r - pascal(sig.vecs - cs, k - s) > 0:
#                 r -= pascal(sig.vecs - cs, k - s)
#                 cs += 1
#             result += cs
#             j = cs
#         return result^

#     @no_inline
#     fn __str__(self) -> String:
#         var align = len(str(sig.dims)) + 1
#         var str_sign: StringLiteral
#         if self.sign < 0:
#             str_sign = "-"
#         elif self.sign > 0:
#             str_sign = "+"
#         else:
#             str_sign = "o"
#         var str_basis = str(self.basis).rjust(align, str_sign)
#         return ansi.Color.colors[sig.grade_of[self.basis] % 8] + str_basis + ansi.Color.clear


fn signed_sort(inout basis: List[Int]) -> Int:
    var count = 0
    for i in range(1, len(basis)):
        var j = i
        while j > 0 and basis[j] < basis[j - 1]:
            count += 1
            var temp = basis[j - 1]
            basis[j - 1] = basis[j]
            basis[j] = temp
            # swap(basis[j - 1], basis[j])
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


# fn count_odd(array: SmallArray[Int]) -> Int:
#     var count = 0
#     var i = 1
#     var m = 0
#     while i < array.size:
#         if array[i - 1] != array[i]:
#             if i % 2 != m:
#                 count += 1
#             m = i % 2
#         i += 1

#     if array.size % 2 != m:
#         count += 1

#     return count
