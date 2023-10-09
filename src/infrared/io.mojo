from infrared.hybrid import IntH, FloatH, HSIMD

fn print_(): print()
fn print_(a: Int): print(a)
fn print_(a: FloatLiteral): print(a)
fn print_(a: String): print(a)
fn print_[dt: DType, sw: Int](a: SIMD[dt,sw]): print(a)

fn print_[sq: Int](a: FloatH[sq]): print(a.__str__())
fn print_[sq: Int](a: FloatH[sq].Antiscalar): print(a.__str__())  

fn print_[sq: Int](a: IntH[sq]): print(a.__str__())
fn print_[sq: Int](a: IntH[sq].Antiscalar): print(a.__str__())

fn print_[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw]): print(a.__str__())
fn print_[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw].Antiscalar): print(a.__str__())

# get the symbol for formatting
fn symbol[sq: Int]() -> String:
    @parameter
    if sq == 1:
        return "x"
    elif sq == -1:
        return "i"
    elif sq == 0:
        return "o"
    else:
        return "[" + String(sq) + "]"