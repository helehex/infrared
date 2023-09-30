from infrared.hybrid import HSIMD

# maybe move to a utils file, or static method on HSIMd for now
fn select[sq: Int, dt: DType, sw: Int](test: SIMD[DType.bool,sw], false_case: HSIMD[sq,dt,sw], true_case: HSIMD[sq,dt,sw]) -> HSIMD[sq,dt,sw]:
    return HSIMD[sq,dt,sw](test.select(false_case.s, true_case.s), test.select(false_case.i.s, true_case.i.s))