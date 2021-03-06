MODULE lib_f90_default_mod
!
USE lib_f90_allocate_mod
USE param_mod
!
IMPLICIT NONE
!
CONTAINS
!
SUBROUTINE lib_alloc_default
!
INTEGER :: n_res
!
n_res = MAX(MAXPAR_RES, 6000)
CALL alloc_param(n_res)
MAXPAR_RES = n_res
!
END SUBROUTINE lib_alloc_default
!
END MODULE lib_f90_default_mod
