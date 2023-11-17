from infrared import symbol

def main():
    from infrared.hybrid.ca import static_test_ca
    from infrared.hybrid.cc import static_test_cc
    static_test_cc()
    static_test_ca()