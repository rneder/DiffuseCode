MODULE symm_sup_mod
!
CONTAINS
!*****7*****************************************************************
      SUBROUTINE symm_setup 
!-                                                                      
!     Performs the generalized symmetry operation                       
!     See Sands, D.E. Vectors and Tensors in Crystallography Chapt. 4.7 
!+                                                                      
      USE discus_config_mod 
      USE crystal_mod 
      USE metric_mod
      USE symm_mod 
      USE tensors_mod
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      INTEGER i, j, k, l 
      REAL length 
!                                                                       
      REAL uij 
      REAL ctheta, stheta 
      REAL sym_d (3), sym_r (3) 
      REAL usym (4), ures (4) 
      REAL kron (3, 3) 
      REAL a (3, 3) 
      REAL b (3, 3) 
!                                                                       
      REAL cosd, sind 
!     REAL skalpro 
!                                                                       
!                                                                       
      DATA kron / 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 / 
!                                                                       
!     initialize matrix and angle                                       
!                                                                       
      DO i = 1, 4 
      DO j = 1, 4 
      sym_mat (i, j) = 0.0 
      sym_rmat (i, j) = 0.0 
      ENDDO 
      ENDDO 
      sym_mat (4, 4) = 1.0 
      sym_rmat (4, 4) = 0.0 
      IF (sym_power_mult) then 
         ctheta = cosd (sym_angle) 
         stheta = sind (sym_angle) 
      ELSE 
         ctheta = cosd (sym_angle * sym_power) 
         stheta = sind (sym_angle * sym_power) 
      ENDIF 
!                                                                       
!     Create vectors of unit length in direct and reciprocal space      
!                                                                       
      length = sqrt (skalpro (sym_uvw, sym_uvw, cr_gten) ) 
      IF (length.eq.0.0) then 
         ier_num = - 32 
         ier_typ = ER_APPL 
         RETURN 
      ENDIF 
      DO j = 1, 3 
      sym_d (j) = sym_uvw (j) / length 
      ENDDO 
      length = sqrt (skalpro (sym_hkl, sym_hkl, cr_rten) ) 
      IF (length.eq.0.0) then 
         ier_num = - 32 
         ier_typ = ER_APPL 
         RETURN 
      ENDIF 
      DO j = 1, 3 
      sym_r (j) = sym_hkl (j) / length 
      ENDDO 
!     write (output_io,2001) sym_d,sym_r                                
!2001      format('direct axis     :',3(2x,f10.6)/                      
!    &                  'reciprocal axis :',3(2x,f10.6))                
!                                                                       
!     calculate symmetry operation                                      
!                                                                       
      DO i = 1, 3 
      DO j = 1, 3 
      sym_mat (i, j) = 0.0 
      DO k = 1, 3 
      DO l = 1, 3 
      sym_mat (i, j) = sym_mat (i, j) + cr_rten (i, k) * cr_eps (k, l,  &
      j) * sym_d (l)                                                    
      ENDDO 
      ENDDO 
      uij = sym_d (i) * sym_r (j) 
      sym_mat (i, j) = sym_mat (i, j) * stheta + uij + (kron (i, j)     &
      - uij) * ctheta                                                   
      ENDDO 
      IF (sym_power_mult) then 
         sym_mat (i, 4) = sym_trans (i) 
      ELSE 
         sym_mat (i, 4) = sym_trans (i) * sym_power 
      ENDIF 
      ENDDO 
!                                                                       
!     In case of improper rotation, multiply by -1                      
!                                                                       
      IF (.not.sym_type.and. (                                          &
      sym_power_mult.or..not.sym_power_mult.and.mod (sym_power, 2)      &
      .ne.0) ) then                                                     
         DO i = 1, 3 
         DO j = 1, 3 
         sym_mat (i, j) = - sym_mat (i, j) 
         ENDDO 
         ENDDO 
      ENDIF 
!     write (output_io,2000) ((sym_mat(i,j),j=1,3),i=1,3)               
!2000      format(3(3(2x,f10.6)/))                                      
!                                                                       
!                                                                       
!                                                                       
!     Transform symmetry operation into reciprocal space                
!                                                                       
      DO i = 1, 3 
      DO j = 1, 3 
      a (i, j) = sym_mat (i, j) 
      ENDDO 
      ENDDO 
!                                                                       
!     do transformation q = gSg*                                        
!                                                                       
      CALL matmulx (b, a, cr_rten) 
      CALL matmulx (a, cr_gten, b) 
      DO i = 1, 3 
      DO j = 1, 3 
      sym_rmat (i, j) = a (i, j) 
      ENDDO 
      ENDDO 
!                                                                       
!     ----Calculate translational component due to origin               
!                                                                       
!                                                                       
!     ----Apply rotational part of symmetry operation to -1*origin      
!                                                                       
      DO j = 1, 3 
      usym (j) = - sym_orig (j) 
      ENDDO 
!                                                                       
!-----      ----Apply symmetry operation                                
!                                                                       
      usym (4) = 0.0 
      CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----Add origin to result to obtain total translational part       
!                                                                       
      DO j = 1, 3 
      sym_or_tr (j) = ures (j) + sym_orig (j) 
      ENDDO 
!     write (output_io,2000) ((sym_rmat(i,j),j=1,3),i=1,3)              
!2000      format(3(3(2x,f10.6)/))                                      
!                                                                       
      END SUBROUTINE symm_setup                     
!*****7*****************************************************************
      SUBROUTINE symm_op_mult 
!-                                                                      
!     Performs the actual symmetry operation, multiple copy version     
!+                                                                      
      USE discus_config_mod 
      USE crystal_mod 
      USE atom_env_mod 
      USE modify_mod
      USE symm_mod 
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
!                                                                       
      INTEGER i, j, k, l 
      INTEGER i_start, i_end 
!                                                                       
      REAL usym (4), ures (4) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the atoms      
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_incl.eq.'all ') then 
         i_end = cr_natoms 
      ELSEIF (sym_incl.eq.'env ') then 
         i_end = atom_env (0) 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all atoms within selected range       
!                                                                       
      DO l = i_start, i_end 
      i = l 
      IF (sym_incl.eq.'env ') i = atom_env (l) 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (cr_iscat (i) ) ) then 
!                                                                       
!     ----Subtract origin                                               
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - sym_orig (j) 
         ENDDO 
!                                                                       
!-----      ----Apply symmetry operation                                
!                                                                       
         usym (4) = 1.0 
         DO k = 1, sym_power 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----Add origin                                                    
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + sym_orig (j) 
         ENDDO 
!                                                                       
!     ----Insert copy of atom or replace original atom by its image     
!                                                                       
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
         ENDDO 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_op_mult                   
!*****7*****************************************************************
      SUBROUTINE symm_op_single 
!-                                                                      
!     Performs the actual symmetry operation, single result version     
!+                                                                      
      USE discus_config_mod 
      USE crystal_mod 
      USE atom_env_mod 
      USE modify_mod
      USE symm_mod 
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
      INTEGER i, j, l 
      INTEGER i_start, i_end 
      REAL usym (4), ures (4) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the atoms      
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_incl.eq.'all ') then 
         i_end = cr_natoms 
      ELSEIF (sym_incl.eq.'env ') then 
         i_end = atom_env (0) 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all atoms within selected range       
!                                                                       
      DO l = i_start, i_end 
      i = l 
      IF (sym_incl.eq.'env ') i = atom_env (l) 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (cr_iscat (i) ) ) then 
!                                                                       
!     ----Subtract origin                                               
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - sym_orig (j) 
         ENDDO 
!                                                                       
!-----      ----Apply symmetry operation                                
!                                                                       
         usym (4) = 1.0 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----Add origin                                                    
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + sym_orig (j) 
         ENDDO 
!                                                                       
!     ----Insert copy of atom or replace original atom by its image     
!                                                                       
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_op_single                 
!*****7*****************************************************************
      SUBROUTINE symm_mole_mult 
!-                                                                      
!     Performs the actual symmetry operation, multiple copy version     
!     Operates on molecules                                             
!+                                                                      
      USE discus_allocate_appl_mod
      USE discus_config_mod 
      USE crystal_mod 
      USE modify_mod
      USE molecule_mod 
      USE spcgr_apply, ONLY: mole_insert_current
      USE symm_mod 
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
!                                                                       
      INTEGER i, j, k, l, ii 
      INTEGER i_start, i_end 
      INTEGER :: imole, imole_s, imole_t=1
      INTEGER  :: n_gene   ! Number of molecule generators
      INTEGER  :: n_symm   ! Number of molecule symmetry operators
      INTEGER  :: n_mole   ! Number of molecules
      INTEGER  :: n_type   ! Number of molecule types
      INTEGER  :: n_atom   ! Number of atoms in molecules
!                                                                       
      REAL usym (4), ures (4), use_orig (3) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the atoms      
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_end.eq. - 1) i_end = mole_num_mole 
      imole_s = mole_num_mole 
!                                                                       
      IF (sym_new) then 
         n_gene = MAX( 1, MOLE_MAX_GENE)
         n_symm = MAX( 1, MOLE_MAX_SYMM)
         n_mole =         MOLE_MAX_MOLE
         n_type =         MOLE_MAX_TYPE
         n_atom =         MOLE_MAX_ATOM
         IF (mole_num_type+sym_power > MOLE_MAX_TYPE ) THEN
            n_type = MAX(mole_num_type + sym_power+5,MOLE_MAX_TYPE)
            call alloc_molecule(n_gene, n_symm, n_mole, n_type, n_atom)
         ENDIF
         imole_t = mole_num_type 
         IF (mole_num_type.lt.MOLE_MAX_TYPE) then 
            mole_num_type = mole_num_type+sym_power 
         ELSE 
            ier_num = - 66 
            ier_typ = ER_APPL 
            RETURN 
         ENDIF 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all molecules within selected range   
!                                                                       
      DO l = i_start, i_end 
!                                                                       
!------ - Determine origin for symmetry operation                       
!                                                                       
      IF (sym_orig_mol) then 
         DO i = 1, 3 
         ii = mole_cont (mole_off (l) + 1) 
         use_orig (i) = sym_orig (i) + cr_pos (i, ii) 
         ENDDO 
      ELSE 
         DO i = 1, 3 
         use_orig (i) = sym_orig (i) 
         ENDDO 
      ENDIF 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (mole_type (l) ) ) then 
!                                                                       
!     ----Loop over all atoms in the molecule                           
!                                                                       
         DO ii = 1, mole_len (l) 
         i = mole_cont (mole_off (l) + ii) 
!                                                                       
!     ----- Subtract origin                                             
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - use_orig (j) 
         ENDDO 
!                                                                       
!-----      ----- Apply symmetry operation                              
!                                                                       
         usym (4) = 1.0 
         DO k = 1, sym_power 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ------- Add origin                                                
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + use_orig (j) 
         ENDDO 
!                                                                       
!     ------- Insert copy of atom or replace original atom by its image 
!                                                                       
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
!                                                                       
!     --------- Insert atom into proper new molecule                    
!                                                                       
            imole = imole_s + (l - i_start) * sym_power + (k - 1)       &
            + 1                                                         
            CALL mole_insert_current (cr_natoms, imole) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
         ENDDO 
         ENDDO 
!                                                                       
!-----      ----Copy all properties                                     
!                                                                       
         IF (sym_mode) then 
            CALL copy_mole_char (mole_num_mole, l) 
         ENDIF 
!                                                                       
!----- ---- Set new molecule type if requested                          
!                                                                       
         IF (sym_new) then 
            DO k = 1, sym_power 
            IF (sym_mode) then 
               mole_type (mole_num_mole-sym_power + k) = imole_t + k 
            ELSE 
               mole_type (l) = imole_t + 1 
            ENDIF 
            ENDDO 
         ENDIF 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_mole_mult                 
!*****7*****************************************************************
      SUBROUTINE symm_mole_single 
!-                                                                      
!     Performs the actual symmetry operation, single result version     
!     Operates on molecules                                             
!+                                                                      
      USE discus_allocate_appl_mod
      USE discus_config_mod 
      USE crystal_mod 
      USE modify_mod
      USE molecule_mod 
      USE spcgr_apply, ONLY: mole_insert_current
      USE symm_mod 
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
      INTEGER i, j, ii, l 
      INTEGER i_start, i_end 
      INTEGER ::imole, imole_s, imole_t=1
      INTEGER  :: n_gene   ! Number of molecule generators
      INTEGER  :: n_symm   ! Number of molecule symmetry operators
      INTEGER  :: n_mole   ! Number of molecules
      INTEGER  :: n_type   ! Number of molecule types
      INTEGER  :: n_atom   ! Number of atoms in molecules
      REAL usym (4), ures (4) 
      REAL werte (5), use_orig (3) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the molecules  
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_end.eq. - 1) i_end = mole_num_mole 
      imole_s = mole_num_mole 
!                                                                       
      IF (sym_new) then 
         n_gene = MAX( 1, MOLE_MAX_GENE)
         n_symm = MAX( 1, MOLE_MAX_SYMM)
         n_mole =         MOLE_MAX_MOLE
         n_type =         MOLE_MAX_TYPE
         n_atom =         MOLE_MAX_ATOM
         IF (mole_num_type+sym_power > MOLE_MAX_TYPE ) THEN
            n_type = MAX(mole_num_type + sym_power+5,MOLE_MAX_TYPE)
            call alloc_molecule(n_gene, n_symm, n_mole, n_type, n_atom)
         ENDIF
         IF (mole_num_type.lt.MOLE_MAX_TYPE) then 
            mole_num_type = mole_num_type+1 
         ELSE 
            ier_num = - 66 
            ier_typ = ER_APPL 
            RETURN 
         ENDIF 
         imole_t = mole_num_type 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all molecules within selected range   
!                                                                       
      DO l = i_start, i_end 
!                                                                       
!------ - Determine origin for symmetry operation                       
!                                                                       
      IF (sym_orig_mol) then 
         DO i = 1, 3 
         ii = mole_cont (mole_off (l) + 1) 
         use_orig (i) = sym_orig (i) + cr_pos (i, ii) 
         ENDDO 
      ELSE 
         DO i = 1, 3 
         use_orig (i) = sym_orig (i) 
         ENDDO 
      ENDIF 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (mole_type (l) ) ) then 
!                                                                       
!     ----Loop over all atoms in the molecule                           
!                                                                       
         DO ii = 1, mole_len (l) 
         i = mole_cont (mole_off (l) + ii) 
!                                                                       
!     ----- Subtract origin                                             
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - use_orig (j) 
         ENDDO 
!                                                                       
!-----      ----- Apply symmetry operation                              
!                                                                       
         usym (4) = 1.0 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----- Add origin                                                  
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + use_orig (j) 
         ENDDO 
!                                                                       
!     ----- Insert copy of atom or replace original atom by its image   
!                                                                       
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
!                                                                       
!     ------- Insert atom into proper new molecule                      
!                                                                       
            imole = imole_s + l - i_start + 1 
            CALL mole_insert_current (cr_natoms, imole) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
         ENDDO 
!                                                                       
!-----      ----Copy all properties                                     
!                                                                       
         IF (sym_mode) then 
            CALL copy_mole_char (mole_num_mole, l) 
         ENDIF 
!                                                                       
!----- ---- Set new molecule type if requested                          
!                                                                       
         IF (sym_new) then 
            IF (sym_mode) then 
               mole_type (mole_num_mole) = imole_t 
            ELSE 
               mole_type (l) = imole_t 
            ENDIF 
         ENDIF 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_mole_single               
!*****7*****************************************************************
      SUBROUTINE symm_domain_mult 
!-                                                                      
!     Performs the actual symmetry operation, multiple copy version     
!     Operates on molecules                                             
!+                                                                      
      USE discus_allocate_appl_mod
      USE discus_config_mod 
      USE crystal_mod 
      USE modify_mod
      USE molecule_mod 
      USE spcgr_apply, ONLY: mole_insert_current
      USE symm_mod 
      USE tensors_mod
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
!                                                                       
      INTEGER i, j, k, l, ii 
      INTEGER i_start, i_end 
      INTEGER :: imole, imole_s, imole_t=1
      INTEGER  :: n_gene   ! Number of molecule generators
      INTEGER  :: n_symm   ! Number of molecule symmetry operators
      INTEGER  :: n_mole   ! Number of molecules
      INTEGER  :: n_type   ! Number of molecule types
      INTEGER  :: n_atom   ! Number of atoms in molecules
!                                                                       
      REAL mat_atom (4, 4) 
      REAL mat_dime (4, 4) 
      REAL new_atom (4, 4) 
      REAL new_dime (4, 4) 
      REAL elements (3, 8) 
      REAL usym (4), ures (4), use_orig (3) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the atoms      
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_end.eq. - 1) i_end = mole_num_mole 
      imole_s = mole_num_mole 
!                                                                       
      IF (sym_new) then 
         n_gene = MAX( 1, MOLE_MAX_GENE)
         n_symm = MAX( 1, MOLE_MAX_SYMM)
         n_mole =         MOLE_MAX_MOLE
         n_type =         MOLE_MAX_TYPE
         n_atom =         MOLE_MAX_ATOM
         IF (mole_num_type+sym_power > MOLE_MAX_TYPE ) THEN
            n_type = MAX(mole_num_type + sym_power+5,MOLE_MAX_TYPE)
            call alloc_molecule(n_gene, n_symm, n_mole, n_type, n_atom)
         ENDIF
         imole_t = mole_num_type 
         IF (mole_num_type.lt.MOLE_MAX_TYPE) then 
            mole_num_type = mole_num_type+sym_power 
         ELSE 
            ier_num = - 66 
            ier_typ = ER_APPL 
            RETURN 
         ENDIF 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all molecules within selected range   
!                                                                       
      DO l = i_start, i_end 
!                                                                       
!------ - Determine origin for symmetry operation                       
!                                                                       
      IF (sym_orig_mol) then 
         DO i = 1, 3 
         ii = mole_cont (mole_off (l) + 1) 
         use_orig (i) = sym_orig (i) + cr_pos (i, ii) 
         ENDDO 
      ELSE 
         DO i = 1, 3 
         use_orig (i) = sym_orig (i) 
         ENDDO 
      ENDIF 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (mole_type (l) ) ) then 
!                                                                       
!     ----Create the matrices from the psueodoatom positions            
!                                                                       
         DO i = 1, 8 
         DO j = 1, 3 
         elements (j, i) = cr_pos (j, mole_cont (mole_off (l) + i) ) 
         ENDDO 
         ENDDO 
         DO i = 1, 3 
         DO j = 1, 3 
         mat_atom (i, j) = cr_pos (j, mole_cont (mole_off (l) + i + 1) )&
         - cr_pos (j, mole_cont (mole_off (l) + 1) )                    
         mat_dime (i, j) = cr_pos (j, mole_cont (mole_off (l) + i + 5) )&
         - cr_pos (j, mole_cont (mole_off (l) + 5) )                    
         ENDDO 
         mat_atom (4, i) = 0.0 
         mat_dime (4, i) = 0.0 
         mat_atom (i, 4) = cr_pos (i, mole_cont (mole_off (l) + 1) ) 
         mat_dime (i, 4) = cr_pos (i, mole_cont (mole_off (l) + 5) ) 
         ENDDO 
         mat_atom (4, 4) = 1.0 
         mat_dime (4, 4) = 1.0 
!                                                                       
!     ----Loop over Power of Operation                                  
!                                                                       
         DO k = 1, sym_power 
         CALL matmul4 (new_atom, sym_mat, mat_atom) 
         CALL matmul4 (new_dime, sym_mat, mat_dime) 
         DO i = 1, 3 
         DO j = 1, 3 
         mat_atom (i, j) = new_atom (i, j) 
         mat_dime (i, j) = new_dime (i, j) 
         ENDDO 
         ENDDO 
!                                                                       
!     ----Loop over all atoms in the molecule                           
!                                                                       
         DO ii = 1, 5, 4 
         i = mole_cont (mole_off (l) + ii) 
!                                                                       
!     ----- Subtract origin                                             
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - use_orig (j) 
         usym (j) = elements (j, ii) - use_orig (j) 
         ENDDO 
!                                                                       
!-----      ----- Apply symmetry operation                              
!                                                                       
         usym (4) = 1.0 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ------- Add origin                                                
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + use_orig (j) 
         elements (j, ii) = ures (j) + use_orig (j) 
         ENDDO 
         ENDDO 
         IF (sym_dom_mode_atom) then 
            DO i = 1, 3 
            DO j = 1, 3 
            elements (j, 1 + i) = new_atom (i, j) + elements (j, 1) 
            ENDDO 
            ENDDO 
         ELSE 
            DO j = 1, 3 
            elements (j, 1) = cr_pos (j, mole_cont (mole_off (l)        &
            + 1) )                                                      
            ENDDO 
         ENDIF 
         IF (sym_dom_mode_shape) then 
            DO i = 1, 3 
            DO j = 1, 3 
            elements (j, 5 + i) = new_dime (i, j) + elements (j, 5) 
            ENDDO 
            ENDDO 
         ELSE 
            DO j = 1, 3 
            elements (j, 5) = cr_pos (j, mole_cont (mole_off (l)        &
            + 5) )                                                      
            ENDDO 
         ENDIF 
         DO ii = 1, 8 
         i = mole_cont (mole_off (l) + ii) 
         DO j = 1, 3 
         werte (j + 1) = elements (j, ii) 
         ENDDO 
!                                                                       
!     ------- Insert copy of atom or replace original atom by its image 
!                                                                       
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
!                                                                       
!     --------- Insert atom into proper new molecule                    
!                                                                       
            imole = imole_s + (l - i_start) * sym_power + (k - 1)       &
            + 1                                                         
            CALL mole_insert_current (cr_natoms, imole) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
         ENDDO 
         ENDDO 
!                                                                       
!-----      ----Copy all properties                                     
!                                                                       
         IF (sym_mode) then 
            CALL copy_mole_char (mole_num_mole, l) 
         ENDIF 
!                                                                       
!----- ---- Set new molecule type if requested                          
!                                                                       
         IF (sym_new) then 
            DO k = 1, sym_power 
            IF (sym_mode) then 
               mole_type (mole_num_mole-sym_power + k) = imole_t + k 
            ELSE 
               mole_type (l) = imole_t + 1 
            ENDIF 
            ENDDO 
         ENDIF 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_domain_mult               
!*****7*****************************************************************
      SUBROUTINE symm_domain_single 
!-                                                                      
!     Performs the actual symmetry operation, single result version     
!     Operates on microdomain represenatation                           
!+                                                                      
      USE discus_allocate_appl_mod
      USE discus_config_mod 
      USE crystal_mod 
      USE modify_mod
      USE molecule_mod 
      USE spcgr_apply, ONLY: mole_insert_current
      USE symm_mod 
      USE tensors_mod
      USE trafo_mod
      USE errlist_mod 
      IMPLICIT none 
!                                                                       
       
!                                                                       
      CHARACTER(4) name 
      INTEGER i, j, ii, l 
      INTEGER i_start, i_end 
      INTEGER :: imole, imole_s, imole_t=1
      INTEGER  :: n_gene   ! Number of molecule generators
      INTEGER  :: n_symm   ! Number of molecule symmetry operators
      INTEGER  :: n_mole   ! Number of molecules
      INTEGER  :: n_type   ! Number of molecule types
      INTEGER  :: n_atom   ! Number of atoms in molecules
      REAL mat_atom (4, 4) 
      REAL mat_dime (4, 4) 
      REAL new_atom (4, 4) 
      REAL new_dime (4, 4) 
      REAL elements (3, 8) 
      REAL usym (4), ures (4) 
      REAL werte (5), use_orig (3) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     Set the appropriate starting end ending number for the molecules  
!                                                                       
      i_start = sym_start 
      i_end = sym_end 
      IF (sym_end.eq. - 1) i_end = mole_num_mole 
      imole_s = mole_num_mole 
!                                                                       
      IF (sym_new) then 
         n_gene = MAX( 1, MOLE_MAX_GENE)
         n_symm = MAX( 1, MOLE_MAX_SYMM)
         n_mole =         MOLE_MAX_MOLE
         n_type =         MOLE_MAX_TYPE
         n_atom =         MOLE_MAX_ATOM
         IF (mole_num_type+sym_power > MOLE_MAX_TYPE ) THEN
            n_type = MAX(mole_num_type + sym_power+5,MOLE_MAX_TYPE)
            call alloc_molecule(n_gene, n_symm, n_mole, n_type, n_atom)
         ENDIF
         IF (mole_num_type.lt.MOLE_MAX_TYPE) then 
            mole_num_type = mole_num_type+1 
         ELSE 
            ier_num = - 66 
            ier_typ = ER_APPL 
            RETURN 
         ENDIF 
         imole_t = mole_num_type 
      ENDIF 
!                                                                       
!     Apply symmetry operation to all molecules within selected range   
!                                                                       
      DO l = i_start, i_end 
!                                                                       
!------ - Determine origin for symmetry operation                       
!                                                                       
      IF (sym_orig_mol) then 
         DO i = 1, 3 
         ii = mole_cont (mole_off (l) + 1) 
         use_orig (i) = sym_orig (i) + cr_pos (i, ii) 
         ENDDO 
      ELSE 
         DO i = 1, 3 
         use_orig (i) = sym_orig (i) 
         ENDDO 
      ENDIF 
!                                                                       
!     --Select atom if:                                                 
!       type has been selected                                          
!                                                                       
      IF (sym_latom (mole_type (l) ) ) then 
!                                                                       
!     ----Create the matrices from the psueodoatom positions            
!                                                                       
         DO i = 1, 8 
         DO j = 1, 3 
         elements (j, i) = cr_pos (j, mole_cont (mole_off (l) + i) ) 
         ENDDO 
         ENDDO 
         DO i = 1, 3 
         DO j = 1, 3 
         mat_atom (i, j) = cr_pos (j, mole_cont (mole_off (l) + i + 1) )&
         - cr_pos (j, mole_cont (mole_off (l) + 1) )                    
         mat_dime (i, j) = cr_pos (j, mole_cont (mole_off (l) + i + 5) )&
         - cr_pos (j, mole_cont (mole_off (l) + 5) )                    
         ENDDO 
         mat_atom (4, i) = 0.0 
         mat_dime (4, i) = 0.0 
         mat_atom (i, 4) = cr_pos (i, mole_cont (mole_off (l) + 1) ) 
         mat_dime (i, 4) = cr_pos (i, mole_cont (mole_off (l) + 5) ) 
         ENDDO 
         mat_atom (4, 4) = 1.0 
         mat_dime (4, 4) = 1.0 
         CALL matmul4 (new_atom, sym_mat, mat_atom) 
         CALL matmul4 (new_dime, sym_mat, mat_dime) 
!                                                                       
!     ----Loop over the two origins of the microdomain                  
!                                                                       
         DO ii = 1, 5, 4 
         i = mole_cont (mole_off (l) + ii) 
!                                                                       
!     ----- Subtract origin                                             
!                                                                       
         DO j = 1, 3 
         usym (j) = cr_pos (j, i) - use_orig (j) 
         ENDDO 
!                                                                       
!-----      ----- Apply symmetry operation                              
!                                                                       
         usym (4) = 1.0 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----- Add origin                                                  
!                                                                       
         DO j = 1, 3 
         werte (j + 1) = ures (j) + use_orig (j) 
         elements (j, ii) = ures (j) + use_orig (j) 
         ENDDO 
         ENDDO 
                                                                        
         IF (sym_dom_mode_atom) then 
            DO i = 1, 3 
            DO j = 1, 3 
            elements (j, 1 + i) = new_atom (i, j) + elements (j, 1) 
            ENDDO 
            ENDDO 
         ELSE 
            DO j = 1, 3 
            elements (j, 1) = cr_pos (j, mole_cont (mole_off (l)        &
            + 1) )                                                      
            ENDDO 
         ENDIF 
         IF (sym_dom_mode_shape) then 
            DO i = 1, 3 
            DO j = 1, 3 
            elements (j, 5 + i) = new_dime (i, j) + elements (j, 5) 
            ENDDO 
            ENDDO 
         ELSE 
            DO j = 1, 3 
            elements (j, 5) = cr_pos (j, mole_cont (mole_off (l)        &
            + 5) )                                                      
            ENDDO 
         ENDIF 
!                                                                       
!     ----- Insert copy of atom or replace original atom by its image   
!                                                                       
         DO ii = 1, 8 
         i = mole_cont (mole_off (l) + ii) 
         DO j = 1, 3 
         werte (j + 1) = elements (j, ii) 
         ENDDO 
         IF (sym_mode) then 
            name = cr_at_lis (cr_iscat (i) ) 
            werte (5) = cr_dw (cr_iscat (i) ) 
            CALL do_ins_atom (name, werte) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
!                                                                       
!     ------- Insert atom into proper new molecule                      
!                                                                       
            imole = imole_s + l - i_start + 1 
            CALL mole_insert_current (cr_natoms, imole) 
            IF (ier_num.ne.0) then 
               RETURN 
            ENDIF 
         ELSE 
            DO j = 1, 3 
            cr_pos (j, i) = werte (j + 1) 
            ENDDO 
         ENDIF 
         ENDDO 
!                                                                       
!-----      ----Copy all properties                                     
!                                                                       
         IF (sym_mode) then 
            CALL copy_mole_char (mole_num_mole, l) 
         ENDIF 
!                                                                       
!----- ---- Set new molecule type if requested                          
!                                                                       
         IF (sym_new) then 
            IF (sym_mode) then 
               mole_type (mole_num_mole) = imole_t 
            ELSE 
               mole_type (l) = imole_t 
            ENDIF 
         ENDIF 
      ENDIF 
      ENDDO 
!                                                                       
      END SUBROUTINE symm_domain_single             
!*****7*****************************************************************
      SUBROUTINE symm_ca_mult (uvw, lspace) 
!-                                                                      
!     Performs the actual symmetry operation, multiple copy version     
!     Only the input vector uvw is used in direct or reciprocal space   
!+                                                                      
      USE discus_config_mod 
      USE symm_mod 
      USE trafo_mod
!                                                                       
      USE errlist_mod 
      USE param_mod 
      USE prompt_mod 
!
      IMPLICIT none 
!                                                                       
      INTEGER j, k 
      LOGICAL lspace 
!                                                                       
      REAL uvw (3) 
      REAL usym (4), ures (4) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     real space part                                                   
!                                                                       
      IF (lspace) then 
!                                                                       
!     ----Subtract origin, if in real space                             
!                                                                       
         DO j = 1, 3 
         usym (j) = uvw (j) - sym_orig (j) 
         ENDDO 
!                                                                       
!-----      --Apply symmetry operation                                  
!                                                                       
         usym (4) = 1.0 
         DO k = 1, sym_power 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----Add origin and store result                                   
!                                                                       
         DO j = 1, 3 
         res_para ( (k - 1) * 3 + j) = ures (j) + sym_orig (j) 
         ENDDO 
         WRITE (output_io, 3000) (res_para ( (k - 1) * 3 + j), j = 1, 3) 
!                                                                       
!     ----Replace current vector by its image                           
!                                                                       
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
         ENDDO 
      ELSE 
!                                                                       
!     ----Reciprocal space part                                         
!                                                                       
         DO j = 1, 3 
         usym (j) = uvw (j) 
         ENDDO 
!                                                                       
!-----      --Apply symmetry operation                                  
!                                                                       
         usym (4) = 0.0 
         DO k = 1, sym_power 
         CALL trans (usym, sym_rmat, ures, 4) 
!                                                                       
!     ----Store result                                                  
!                                                                       
         DO j = 1, 3 
         res_para ( (k - 1) * 3 + j) = ures (j) 
         ENDDO 
         WRITE (output_io, 3000) (res_para ( (k - 1) * 3 + j), j = 1, 3) 
!                                                                       
!     ----Replace current vector by its image                           
!                                                                       
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
         ENDDO 
      ENDIF 
!                                                                       
      res_para (0) = sym_power * 3 
!                                                                       
 3000 FORMAT    (' Result    : ',3(2x,f9.4)) 
      END SUBROUTINE symm_ca_mult                   
!*****7*****************************************************************
      SUBROUTINE symm_ca_single (uvw, lspace, loutput) 
!-                                                                      
!     Performs the actual symmetry operation, multiple copy version     
!     Only the input vector uvw is used in direct or reciprocal space   
!+                                                                      
      USE discus_config_mod 
      USE symm_mod 
      USE trafo_mod
!                                                                       
      USE errlist_mod 
      USE param_mod 
      USE prompt_mod 
!
      IMPLICIT none 
!                                                                       
      REAL   ,DIMENSION(1:3), INTENT(IN) :: uvw
      LOGICAL,                INTENT(IN) :: lspace 
      LOGICAL,                INTENT(IN) :: loutput 
!                                                                       
      INTEGER j 
!
      REAL usym (4), ures (4) 
      REAL werte (5) 
!                                                                       
      DATA usym / 0.0, 0.0, 0.0, 1.0 / 
      DATA werte / 0.0, 0.0, 0.0, 0.0, 0.0 / 
!                                                                       
!     real space part                                                   
!                                                                       
      IF (lspace) then 
!                                                                       
!     ----Subtract origin, if in real space                             
!                                                                       
         DO j = 1, 3 
         usym (j) = uvw (j) - sym_orig (j) 
         ENDDO 
!                                                                       
!-----      --Apply symmetry operation                                  
!                                                                       
         usym (4) = 1.0 
         CALL trans (usym, sym_mat, ures, 4) 
!                                                                       
!     ----Add origin and store result                                   
!                                                                       
         DO j = 1, 3 
         res_para (j) = ures (j) + sym_orig (j) 
         ENDDO 
!                                                                       
!     ----Replace current vector by its image                           
!                                                                       
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
      ELSE 
!                                                                       
!     ----Subtract origin, if in real space                             
!                                                                       
         DO j = 1, 3 
         usym (j) = uvw (j) 
         ENDDO 
!                                                                       
!-----      --Apply symmetry operation                                  
!                                                                       
         usym (4) = 0.0 
         CALL trans (usym, sym_rmat, ures, 4) 
!                                                                       
!     ----Add origin and store result                                   
!                                                                       
         DO j = 1, 3 
         res_para (j) = ures (j) 
         ENDDO 
!                                                                       
!     ----Replace current vector by its image                           
!                                                                       
         DO j = 1, 3 
         usym (j) = ures (j) 
         ENDDO 
      ENDIF 
!                                                                       
      IF( loutput) THEN
         res_para (0) = 3 
         WRITE (output_io, 3000) (res_para (j), j = 1, 3) 
      ENDIF
!                                                                       
 3000 FORMAT    (' Result    : ',3(2x,f9.4)) 
      END SUBROUTINE symm_ca_single                 
END MODULE symm_sup_mod
