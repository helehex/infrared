# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


@always_inline
fn generate_basis2entry(mask: List[Bool]) -> List[Int]:
    # TODO: I tried making this return a List[Optional[Bool]],
    #       but something breaks when using it at ctime.
    var result = List[Int](capacity=len(mask))
    var count = 0
    for basis in range(len(mask)):
        if mask[basis]:
            result += count
            count += 1
        else:
            result += -1
    return result^


@always_inline
fn generate_entry2basis(mask: List[Bool]) -> List[Int]:
    var result = List[Int](capacity=count_true(mask))
    for basis in range(len(mask)):
        if mask[basis]:
            result += basis
    return result^


@always_inline
fn count_true(mask: List[Bool]) -> Int:
    var count = 0
    for basis in range(len(mask)):
        count += int(mask[basis])
    return count


@always_inline
fn or_mask(a: List[Bool], b: List[Bool]) -> List[Bool]:
    var result = List[Bool](capacity=len(a))
    for idx in range(len(a)):
        result += a[idx] | b[idx]
    return result^


@always_inline
fn mul_mask(sig: Signature, a: List[Bool], b: List[Bool]) -> List[Bool]:
    # TODO: There's probably a better way todo this
    var result = sig.empty_mask()

    for x in range(sig.dims):
        if a[x]:
            for y in range(sig.dims):
                if b[y]:
                    result[sig.mult[x, y].basis] |= sig.mult[x, y].sign != 0
    return result
