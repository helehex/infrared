# TODO
- Improve performance of algebra generation
    - Append and reduce one vector at a time, instead of all at once
    - Use bit wise operations for basis reduction
- Improve model for multivector subspace initialization
    - Maybe add a SignatureMask struct for helping with masking
- Move types onto using formatter pattern for str