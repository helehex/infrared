from infrared.hybrid import IntH, FloatH, HSIMD

fn print_(): print()
fn print_(o: Int): print(o)
fn print_(o: FloatLiteral): print(o)
fn print_(o: String): print(o)
fn print_[dt: DType, sw: Int](o: SIMD[dt,sw]): print(o)

fn print_[sq: Int](o: FloatH[sq]): print_(o.__str__())
fn print_[sq: Int](o: FloatH[sq].Scalar): print_(o.__str__())  
fn print_[sq: Int](o: FloatH[sq].Antiscalar): print_(o.__str__())  

fn print_[sq: Int](o: IntH[sq]): print_(o.__str__())
fn print_[sq: Int](o: IntH[sq].Scalar): print_(o.__str__())
fn print_[sq: Int](o: IntH[sq].Antiscalar): print_(o.__str__())

fn print_[sq: Int, dt: DType, sw: Int](o: HSIMD[sq,dt,sw]): print_(o.__str__())
fn print_[sq: Int, dt: DType, sw: Int](o: HSIMD[sq,dt,sw].Scalar): print_(o.__str__())
fn print_[sq: Int, dt: DType, sw: Int](o: HSIMD[sq,dt,sw].Antiscalar): print_(o.__str__())

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