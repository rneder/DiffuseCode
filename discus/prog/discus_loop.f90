MODULE discus_loop_mod
!
CONTAINS
!
SUBROUTINE discus_loop
!                                                                       
   USE discus_exit_mod
   USE doact_mod 
   USE errlist_mod 
   USE learn_mod 
   USE class_macro_internal 
   USE prompt_mod 

   IMPLICIT none 
!
!*****7*****************************************************************
!                                                                       
!     Main program for DISCUS                                           
!                                                                       
!     This is the main program for DISCUS. It sets up most              
!     variables and calls the loop interpreting the commands.           
!                                                                       
!     Authors : R.B. Neder  (reinhard.neder@fau.de)      
!               Th. Proffen (tproffen@ornl.gov)                         
!                                                                       
!*****7*****************************************************************
!                                                                       
CHARACTER (LEN=1024) :: line   = ' '
CHARACTER (LEN=1024) :: zeile  = ' '
CHARACTER (LEN=4)    :: befehl = ' '
LOGICAL              :: lend 
INTEGER              :: laenge = 1
INTEGER              :: lp     = 1
INTEGER              :: lbef   = 1
!                                                                       
EXTERNAL             :: discus_mache_kdo    ! Declare DISCUS copy of mache_kdo
!                                                                       
lend    = .false. 
!                                                                       
!------ This is the main loop: reading commands ..                      
!                                                                       
main: DO while (.not.lend) 
   CALL get_cmd (line, laenge, befehl, lbef, zeile, lp, prompt)
ok: IF (ier_num.eq.0.and.laenge.gt.0) then 
!                                                                       
!     - If not a comment continue                                       
!                                                                       
      IF (.not. (line (1:1) .eq.'#'.or.line (1:1) .eq.'!') ) then 
!                                                                       
!     - execute command                                                 
!                                                                       
         IF (line (1:3) .eq.'do '.OR.line (1:2) .eq.'if') then 
            CALL do_loop (line, lend, laenge, discus_mache_kdo) 
         ELSE 
            CALL discus_mache_kdo (line, lend, laenge) 
         ENDIF 
      ENDIF 
   ENDIF ok
!                                                                       
!     - Handle error message                                            
!                                                                       
fehler: IF (ier_num.ne.0) then 
      IF( ier_num ==-9.and. ier_typ==ER_IO) THEN  
         WRITE(output_io, 8000)
         WRITE(output_io, 9000)
         stop
      ENDIF
      CALL errlist 
      IF (ier_sta.ne.ER_S_LIVE) then 
         IF (lmakro) then 
            CALL macro_close 
            prompt_status = PROMPT_ON 
         ENDIF 
         lblock = .false. 
         CALL no_error 
      ENDIF 
   ENDIF fehler
ENDDO main
!                                                                       
IF ( lstandalone ) THEN
   CALL discus_do_exit 
ENDIF
!
8000 format(' ****EXIT**** Input error on normal read        ',        &
     &       '        ****',a1/)
9000 format(' ****EXIT**** Program terminated by error status',        &
     &       '        ****',a1/)
!                                                                       
END SUBROUTINE discus_loop
!
END MODULE discus_loop_mod
