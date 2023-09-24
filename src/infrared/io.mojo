from infrared.hybrid import IntH, FloatH, HSIMD

fn _print(): print()
fn _print(a: Int): print(a)
fn _print(a: FloatLiteral): print(a)
fn _print[sq: Int](a: FloatH[sq]): print(a.__str__())
fn _print[sq: Int](a: FloatH[sq].I): print(a.__str__())  
fn _print[sq: Int](a: IntH[sq]): print(a.__str__())
fn _print[sq: Int](a: IntH[sq].I): print(a.__str__())
fn _print[dt: DType, sw: Int](a: SIMD[dt,sw]): print(a)
fn _print[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw]): print(a.__str__())
fn _print[sq: Int, dt: DType, sw: Int](a: HSIMD[sq,dt,sw].I): print(a.__str__())