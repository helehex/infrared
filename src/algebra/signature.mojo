# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


# +----------------------------------------------------------------------------------------------+ #
# | Signature
# +----------------------------------------------------------------------------------------------+ #
#
struct Signature:
    """Signature."""

    # +------< Data >------+ #
    #
    var po: Int
    var ne: Int
    var ze: Int

    # +------< Cache >------+ #
    #
    var vecs: Int
    var dims: Int
    var grds: Int
    var vec_sqrs: List[Int]
    var grade_dims: List[Int]
    var grade_of: List[Int]
    var index_in_grade: List[Int]
    var combs: List[List[Int]]
    var mult: List[List[SignedBasis]]

    fn __init__(inout self, po: Int, ne: Int = 0, ze: Int = 0, *, flip_ze: Bool = True):
        self.po = po
        self.ne = ne
        self.ze = ze

        self.vecs = self.po + self.ne + self.ze
        self.dims = 2 ** (self.vecs)
        self.grds = self.vecs + 1

        self.vec_sqrs = List[Int](capacity=self.vecs)
        self.grade_dims = List[Int](capacity=self.grds)
        self.grade_of = List[Int](capacity=self.dims)
        self.index_in_grade = List[Int](capacity=self.dims)
        self.combs = powerset_ord(self.vecs)
        self.mult = List[List[SignedBasis]](capacity=self.dims)

        if flip_ze:
            for _ in range(ze):
                self.vec_sqrs += 0

        for _ in range(po):
            self.vec_sqrs += 1

        for _ in range(ne):
            self.vec_sqrs += -1

        if not flip_ze:
            for _ in range(ze):
                self.vec_sqrs += 0

        for grade in range(self.grds):
            self.grade_dims += pascal(self.vecs, grade)

        for grade in range(self.grds):
            for basis in range(self.grade_dims[grade]):
                self.grade_of += grade
                self.index_in_grade += basis

        self.generate_product_table()

    fn empty_mask(self) -> List[Bool]:
        var result = List[Bool](capacity=self.dims)
        for _ in range(self.dims):
            result += False
        return result

    fn full_mask(self) -> List[Bool]:
        var result = List[Bool](capacity=self.dims)
        for _ in range(self.dims):
            result += True
        return result

    fn grade_mask(self, grade: Int) -> List[Bool]:
        var result = List[Bool](capacity=self.dims)
        for basis in range(self.dims):
            result += self.grade_of[basis] == grade
        return result

    fn scalar_mask(self) -> List[Bool]:
        return self.grade_mask(0)

    fn vector_mask(self) -> List[Bool]:
        return self.grade_mask(1)

    fn bivector_mask(self) -> List[Bool]:
        return self.grade_mask(2)

    fn trivector_mask(self) -> List[Bool]:
        return self.grade_mask(3)

    fn quadvector_mask(self) -> List[Bool]:
        return self.grade_mask(4)

    fn antiscalar_mask(self) -> List[Bool]:
        return self.grade_mask(self.grds - 1)

    fn squash_basis(self, inout basis: List[Int], inout sign: Int):
        var result = List[Int](capacity=len(basis))
        var i = 1
        var j = 0
        while i < len(basis):
            if basis[i] != basis[i - 1]:
                result += basis[i - 1]
                i += 1
                j += 1
            else:
                sign *= self.vec_sqrs[basis[i] - 1]
                i += 2

        if i == len(basis):
            result += basis[len(basis) - 1]

        basis = result^

    fn reduce_basis(self, owned basis: List[Int]) -> SignedBasis:
        if len(basis) == 0:
            return SignedBasis(1, 0)
        elif len(basis) == 1:
            return SignedBasis(1, basis[0])
        else:
            var sign: Int = 1 - ((signed_sort(basis) % 2) * 2)
            self.squash_basis(basis, sign)
            return SignedBasis(sign, self.order_basis(basis))

    fn squash_vec(self, inout basis: List[Int], vec: Int, inout sign: Int):
        for idx in reversed(range(len(basis))):
            if basis[idx] == vec:
                sign *= self.vec_sqrs[vec - 1]
                _ = basis.pop(idx)
                return
            elif basis[idx] < vec:
                basis.insert(idx + 1, vec)
                return
            else:
                sign = -sign
        basis.insert(0, vec)

    fn reduce_basis(self, owned basis1: List[Int], basis2: List[Int]) -> SignedBasis:
        var sign: Int = 1
        for vec in basis2:
            self.squash_vec(basis1, vec[], sign)
        return SignedBasis(sign, self.order_basis(basis1))

    fn order_basis(self, basis: List[Int]) -> Int:
        var result = self.grade_dims[len(basis)]

        for i in range(len(basis)):
            result += self.grade_dims[i]
            var n = self.vecs - basis[i]
            var k = len(basis) - i
            if n >= k:
                result -= pascal(n, k)

        return result - 1

    # # old way: append basis, sort, squash, order
    # fn generate_product_table(inout self):
    #     for x in range(self.dims):
    #         var result_x = List[SignedBasis](capacity=self.dims)
    #         for y in range(self.dims):
    #             result_x += self.reduce_basis(self.combs[x] + self.combs[y])
    #         self.mult += result_x^

    # new way: append vec, squash, order, repeat
    fn generate_product_table(inout self):
        for x in range(self.dims):
            var result_x = List[SignedBasis](capacity=self.dims)
            for y in range(self.dims):
                result_x += self.reduce_basis(self.combs[x], self.combs[y])
            self.mult += result_x^

    @no_inline
    fn __str__(self) -> String:
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        for x in range(len(self.mult)):
            for y in range(len(self.mult[x])):
                writer.write(self.mult[x][y].__str__(self) + " ")
            writer.write("\n")


# fn generate_product_table[sig: Signature]() -> List[List[SignedBasis[sig]]]:
#     alias dims = sig.dims
#     var combs = sig.combs
#     var result = List[List[SignedBasis[sig]]](capacity=dims)

#     for x in range(dims):
#         var result_x = List[SignedBasis[sig]](capacity=dims)
#         for y in range(dims):
#             result_x += ExpandedBasis[sig](combs[x] + combs[y]).reduce()
#         result += result_x^

#     return result^
