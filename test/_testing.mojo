from collections import Optional
from testing.testing import (
    Testable,
    isclose,
    _SourceLocation,
    _assert_error,
    __call_location,
    _assert_cmp_error,
)


@always_inline
fn str_(l: List[List[Int]]) -> String:
    var result: String = "["
    for idx in range(len(l) - 1):
        result += l[idx].__str__() + ", "
    if len(l) > 0:
        result += l[len(l) - 1].__str__()
    return result + "]"


@always_inline
fn assert_equal_(
    lhs: List[List[Int]],
    rhs: __type_of(lhs),
    msg: String = "",
    *,
    location: Optional[_SourceLocation] = None,
) raises:
    var eq = len(lhs) == len(rhs)

    if eq:
        for idx in range(len(lhs)):
            if lhs[idx] != rhs[idx]:
                eq = False
                break
    
    if not eq:
        raise _assert_cmp_error["`left == right` comparison"](
            str_(lhs), str_(rhs), msg=msg, loc=location.or_else(__call_location())
        )


@always_inline
fn assert_not_equal_(
    lhs: List[List[Int]],
    rhs: __type_of(lhs),
    msg: String = "",
    *,
    location: Optional[_SourceLocation] = None,
) raises:
    var ne = len(lhs) != len(rhs)

    if not ne:
        for idx in range(len(lhs)):
            if lhs[idx] != rhs[idx]:
                ne = True
                break

    if not ne:
        raise _assert_cmp_error["`left != right` comparison"](
            str_(lhs), str_(rhs), msg=msg, loc=location.or_else(__call_location())
        )