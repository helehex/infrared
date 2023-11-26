from infrared import symbol

def main():
    #from infrared.hybrid_ca import static_test_ca
    from infrared.hybrid.cc import static_test_cc, math_test_cc
    from infrared import symbol
    static_test_cc()
    math_test_cc()
    #static_test_ca()