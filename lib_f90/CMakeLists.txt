# Create the lib_90 library for the command language

set (FSOURCES allocate_generic.f90 lib_f90_alloc.f90 lib_f90_default.f90
              appl_unix.f90 blockdat.f90 dkdo.f90 
              errlist.f90 help.f90 jsu_readline.f90 learn.f90 macro.f90 
              random.f90 sup.f90 set_sub_generic_mod.f90 variable_test.f90 
              charact_mod.f90 debug_mod.f90 doact_mod.f90 doexec_mod.f90 
              doloop_mod.f90 envir_mod.f90 errlist_mod.f90 learn_mod.f90
              class_macro.f90 macro_internal.f90 macro_mod.f90 
              param_mod.f90 prompt_mod.f90 random_mod.f90 sorting.f90 
              times_mod.f90 variable_mod.f90 wink_mod.f90)

set (CSOURCES FCreadline.c csocket.c csup.c)

# Will change the sys_*.f90 file depending on which
# compiler is used. Default to gfortran.
if (PGF)
  set( FSOURCES ${FSOURCES} sys_pgi.f90 )
elseif (IFORT)
  set( FSOURCES ${FSOURCES} sys_intel.f90 )
else (PGF)
  set( FSOURCES ${FSOURCES} sys_gfortran.f90 )
endif (PGF)

# This macro modified from http://www.cmake.org/pipermail/cmake/2010-November/041034.html
# The date is returned in ISO8601 format
MACRO (TODAY RESULT)
    IF(UNIX OR CYGWIN OR LINUX)
        EXECUTE_PROCESS(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/(....).*" "\\3-\\2-\\1" ${RESULT} ${${RESULT}})
    ELSEIF (WIN32)
        EXECUTE_PROCESS(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/(....).*" "\\3-\\2-\\1" ${RESULT} ${${RESULT}})
    ELSE (UNIX OR CYGWIN OR LINUX)
        MESSAGE(SEND_ERROR "date not implemented")
        SET(${RESULT} "0000-00-00")
    ENDIF (UNIX OR CYGWIN OR LINUX)
ENDMACRO (TODAY)

TODAY(BUILD_DATE)
message (status " BUILD_DATE=${BUILD_DATE}")
configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/date.inc.template
                 ${CMAKE_CURRENT_BINARY_DIR}/date.inc )

IF (WIN32 OR CYGWIN )
  set (CSOURCES ${CSOURCES} win32-glob.c)
ENDIF (WIN32 OR CYGWIN)

add_library (lib_f90  ${FSOURCES})
add_library (lib_f90c ${CSOURCES})
