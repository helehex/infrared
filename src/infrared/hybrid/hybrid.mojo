from infrared.hybrid import IntH, FloatH, HSIMD

#------------ Hyplex Numbers ------------#
#---
#------ basis: [s, x]
#------ s is a real number
#------ x*x = 1
#------ (currently an alias of FloatH[1]; x = a, a*a=1)
#---
alias x = IntH[1].Antiscalar()
alias G1      = FloatH[1]
alias FloatG1 = FloatH[1]
alias IntG1     = IntH[1]
alias Float32G1 = HSIMD[1,DType.float32,1]
alias Float64G1 = HSIMD[1,DType.float64,1]
alias Int32G1   = HSIMD[1,DType.int32,1]
alias Int64G1   = HSIMD[1,DType.int64,1]


#------------ Complex Numbers ------------#
#---
#------ basis: [s, i]
#------ s is a real number
#------ i*i = -1
#------ (currently an alias of FloatH[-1]; i = a, a*a=-1)
#---
alias i = IntH[-1].Antiscalar()
alias G01      = FloatH[-1]
alias FloatG01 = FloatH[-1]
alias IntG01     = IntH[-1]
alias Float32G01 = HSIMD[-1,DType.float32,1]
alias Float64G01 = HSIMD[-1,DType.float64,1]
alias Int32G01   = HSIMD[-1,DType.int32,1]
alias Int64G01   = HSIMD[-1,DType.int64,1]


#------------ Paraplex Numbers ------------#
#---
#------ basis: [s, o]
#------ s is a real number
#------ o*o = 0
#------ (currently an alias of FloatH[0]; o = a, a*a=0)
#---
alias o = IntH[0].Antiscalar()
alias G001      = FloatH[0]
alias FloatG001 = FloatH[0]
alias IntG001     = IntH[0]
alias Float32G001 = HSIMD[0,DType.float32,1]
alias Float64G001 = HSIMD[0,DType.float64,1]
alias Int32G001   = HSIMD[0,DType.int32,1]
alias Int64G001   = HSIMD[0,DType.int64,1]