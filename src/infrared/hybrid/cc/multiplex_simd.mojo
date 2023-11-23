"""
The greater algebra containing Hyplex, Complex, and Paraplex numbers.

This is also called the hybrid algebra, and still not really geometric algebra.
"""

# maybe replace with on site else constrain
fn constrain_square[type: DType, square: SIMD[type,1]]():
    constrained[square == 1 or square == -1 or square == 0, "this hybrid is not a subalgebra of multiplex"]()

@register_passable("trivial")
struct MultiplexSIMD[type: DType, size: Int = 1]:

    #------[ Alias ]------#
    #
    alias Coef = SIMD[type,size]


    #------< Data >------#
    #
    var s: Self.Coef
    var x: Self.Coef
    var i: Self.Coef
    var o: Self.Coef


    #------( Initialize )------#
    #
    @always_inline # Zero
    fn __init__() -> Self:
        return Self{s:0, x:0, i:0, o:0}

    @always_inline # Hybrid
    fn __init__[square: SIMD[type,1]](h: HybridSIMD[type,size,square]) -> Self:
        constrain_square[h.type, h.square]()
        @parameter
        if h.square == 1: return Self{s:h.s, x:h.a, i:0, o:0}
        elif h.square == -1: return Self{s:h.s, x:0, i:h.a, o:0}
        elif h.square == 0: return Self{s:h.s, x:0, i:0, o:h.a}
        else: return Self()

    @always_inline # Scalar + x + i + o
    fn __init__(s: Self.Coef, x: Self.Coef, i: Self.Coef, o: Self.Coef) -> Self:
        return Self{s:s, x:x, i:i, o:o}


    #------( Formatting )------#
    #
    fn __str__(self) -> String:
        @parameter
        if size == 1:
            return String(self.s[0]) + " + " + String(self.x[0])+"x" + " + " + String(self.i[0])+"i" + " + " + String(self.o[0])+"o"
        else:
            var result: String = ""
            @unroll
            for index in range(size): result += self[index].__str__() + "\n"
            return result


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, index: Int) -> MultiplexSIMD[type,1]:
        return MultiplexSIMD[type,1](self.s[index], self.x[index], self.i[index], self.o[index])
    
    @always_inline
    fn __setitem__(inout self, index: Int, item: MultiplexSIMD[type,1]):
        self.s[index] = item.s
        self.x[index] = item.x
        self.i[index] = item.i
        self.o[index] = item.o


    #------( Arithmetic )------#
    #
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.x, self.i, self.o)

    fn __add__(self, other: HybridSIMD[type,size,1]) -> Self:
        return Self(self.s + other.s, self.x + other.a, self.i, self.o)

    fn __add__(self, other: HybridSIMD[type,size,-1]) -> Self:
        return Self(self.s + other.s, self.x, self.i + other.a, self.o)

    fn __add__(self, other: HybridSIMD[type,size,0]) -> Self:
        return Self(self.s + other.s, self.x, self.i, self.o + other.a)