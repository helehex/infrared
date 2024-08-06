# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


# +----------------------------------------------------------------------------------------------+ #
# | Signature
# +----------------------------------------------------------------------------------------------+ #
#
struct Signature[po: Int, ne: Int = 0, ze: Int = 0]:

    @staticmethod
    fn constrained():
        constrained[po >= 0]()
        constrained[ne >= 0]()
        constrained[ze >= 0]()

    @staticmethod
    fn dims() -> Int:
        Self.constrained()
        return 2**(po + ne + ze)

    @staticmethod
    fn grades() -> Int:
        Self.constrained()
        return po + ne + ze + 1

    @staticmethod
    fn dims(grade: Int) -> Int:
        Self.constrained()
        return pascal(po + ne + ze, grade)