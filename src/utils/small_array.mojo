from sys.intrinsics import _type_is_eq
from collections._index_normalization import normalize_index


# +----------------------------------------------------------------------------------------------+ #
# | Helper
# +----------------------------------------------------------------------------------------------+ #
#
trait DefaultableCollectionElement(Defaultable, CollectionElement):
    pass


fn _small_array_construction_checks[size: Int]():
    constrained[size >= 0, "number of elements in `SmallArray` must be >= 0"]()


# +----------------------------------------------------------------------------------------------+ #
# | Small Array
# +----------------------------------------------------------------------------------------------+ #
#
@value
struct SmallArray[T: CollectionElement, size: Int](Sized, CollectionElement):
    """SmallArray."""

    # +------< Data >------+ #
    #
    alias type = __mlir_type[`!pop.array<`, size.value, `, `, T, `>`]
    var _data: Self.type

    # +------( Lifecycle )------+ #
    #
    @always_inline
    fn __init__[init_data: Bool = True](inout self):
        _small_array_construction_checks[size]()
        self._data = __mlir_op.`kgen.undef`[_type = Self.type]()

        @parameter
        if init_data:
            constrained[
                False, "Initialize by explicitly setting the parameter `init_data` to `False`."
            ]()

    @always_inline
    fn __init__[_T: DefaultableCollectionElement](inout self: SmallArray[_T, size]):
        self.__init__(_T())

    @always_inline
    fn __init__(inout self, fill: T):
        self.__init__[False]()

        @parameter
        for i in range(size):
            var ptr = UnsafePointer.address_of(self.unsafe_get(i))
            ptr.init_pointee_copy(fill)

    @always_inline
    fn __init__(inout self, owned *elems: T):
        self = Self(storage=elems^)

    @always_inline
    fn __init__(
        inout self,
        *,
        owned storage: VariadicListMem[T, _],
    ):
        debug_assert(len(storage) == size, "Elements must be of length size")
        self.__init__[False]()

        @parameter
        for i in range(size):
            var eltref: Reference[T, __lifetime_of(self)] = self.unsafe_get(i)
            UnsafePointer.address_of(storage[i]).move_pointee_into(
                UnsafePointer[T].address_of(eltref[])
            )
        storage._is_owned = False

    # @deprecated("could cause large overhead")
    # fn __copyinit__(inout self, other: Self):
    #     self.__init__[False]()

    #     for idx in range(size):
    #         var ptr = self.unsafe_ptr() + idx
    #         ptr.init_pointee_copy(other[idx])

    fn __del__(owned self):
        @parameter
        for idx in range(size):
            var ptr = self.unsafe_ptr() + idx
            ptr.destroy_pointee()

    # +------( Subscript )------+ #
    #
    @always_inline
    fn __getitem__(ref [_]self, idx: Int) -> ref [__lifetime_of(self)] T:
        var normalized_index = normalize_index["SmallArray"](idx, self)
        return self.unsafe_get(normalized_index)

    @always_inline
    fn __getitem__[idx: Int](ref [_]self) -> ref [__lifetime_of(self)] T:
        constrained[-size <= idx < size, "Index out of bounds."]()
        var normalized_idx = idx

        @parameter
        if idx < 0:
            normalized_idx += size
        return self.unsafe_get(normalized_idx)

    @always_inline
    fn unsafe_get(ref [_]self, idx: Int) -> ref [__lifetime_of(self)] T:
        var idx_as_int = index(idx)
        debug_assert(
            0 <= idx_as_int < size,
            "Index out of bounds.",
        )
        var ptr = __mlir_op.`pop.array.gep`(
            UnsafePointer.address_of(self._data).address,
            idx_as_int.value,
        )
        return UnsafePointer(ptr)[]

    # +------( Unary )------+ #
    #
    @always_inline
    fn __len__(self) -> Int:
        return size

    # +------( Operations )------+ #
    #
    @always_inline
    fn unsafe_ptr(self) -> UnsafePointer[T]:
        return UnsafePointer.address_of(self._data).bitcast[T]()

    @always_inline
    fn __contains__[_T: EqualityComparableCollectionElement, //](self, value: _T) -> Bool:
        constrained[_type_is_eq[_T, T](), "T must be equal to Self.ElementType"]()

        @parameter
        for i in range(size):
            if rebind[Reference[_T, __lifetime_of(self)]](Reference(self[i]))[] == value:
                return True
        return False
