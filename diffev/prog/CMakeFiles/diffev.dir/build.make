# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/reinhard/develop/DiffuseCode

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/reinhard/develop/DiffuseCode

# Include any dependencies generated for this target.
include diffev/prog/CMakeFiles/diffev.dir/depend.make

# Include the progress variables for this target.
include diffev/prog/CMakeFiles/diffev.dir/progress.make

# Include the compile flags for this target's objects.
include diffev/prog/CMakeFiles/diffev.dir/flags.make

diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o: diffev/prog/CMakeFiles/diffev.dir/flags.make
diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o: diffev/prog/diffev.f90
	$(CMAKE_COMMAND) -E cmake_progress_report /home/reinhard/develop/DiffuseCode/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o"
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/reinhard/develop/DiffuseCode/diffev/prog/diffev.f90 -o CMakeFiles/diffev.dir/diffev.f90.o

diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.requires:
.PHONY : diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.requires

diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.provides: diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.requires
	$(MAKE) -f diffev/prog/CMakeFiles/diffev.dir/build.make diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.provides.build
.PHONY : diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.provides

diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.provides.build: diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o

# Object files for target diffev
diffev_OBJECTS = \
"CMakeFiles/diffev.dir/diffev.f90.o"

# External object files for target diffev
diffev_EXTERNAL_OBJECTS =

diffev/prog/diffev: diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o
diffev/prog/diffev: diffev/prog/CMakeFiles/diffev.dir/build.make
diffev/prog/diffev: diffev/prog/libdiffev_all.a
diffev/prog/diffev: lib_f90/liblib_f90.a
diffev/prog/diffev: lib_f90/liblib_f90c.a
diffev/prog/diffev: /usr/lib64/libreadline.so
diffev/prog/diffev: diffev/prog/libdiffev_all.a
diffev/prog/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi_f90.so
diffev/prog/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi_f77.so
diffev/prog/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi.so
diffev/prog/diffev: /usr/lib64/librt.so
diffev/prog/diffev: /usr/lib64/libnsl.so
diffev/prog/diffev: /usr/lib64/libutil.so
diffev/prog/diffev: /usr/lib64/libm.so
diffev/prog/diffev: /usr/lib64/libdl.so
diffev/prog/diffev: /usr/lib64/libm.so
diffev/prog/diffev: /usr/lib64/librt.so
diffev/prog/diffev: /usr/lib64/libnsl.so
diffev/prog/diffev: /usr/lib64/libutil.so
diffev/prog/diffev: /usr/lib64/libm.so
diffev/prog/diffev: /usr/lib64/libdl.so
diffev/prog/diffev: diffev/prog/CMakeFiles/diffev.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable diffev"
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/diffev.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
diffev/prog/CMakeFiles/diffev.dir/build: diffev/prog/diffev
.PHONY : diffev/prog/CMakeFiles/diffev.dir/build

# Object files for target diffev
diffev_OBJECTS = \
"CMakeFiles/diffev.dir/diffev.f90.o"

# External object files for target diffev
diffev_EXTERNAL_OBJECTS =

diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: diffev/prog/CMakeFiles/diffev.dir/build.make
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: diffev/prog/libdiffev_all.a
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: lib_f90/liblib_f90.a
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: lib_f90/liblib_f90c.a
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libreadline.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: diffev/prog/libdiffev_all.a
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi_f90.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi_f77.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/mpi/gcc/openmpi/lib64/libmpi.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/librt.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libnsl.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libutil.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libm.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libdl.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libm.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/librt.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libnsl.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libutil.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libm.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: /usr/lib64/libdl.so
diffev/prog/CMakeFiles/CMakeRelink.dir/diffev: diffev/prog/CMakeFiles/diffev.dir/relink.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable CMakeFiles/CMakeRelink.dir/diffev"
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/diffev.dir/relink.txt --verbose=$(VERBOSE)

# Rule to relink during preinstall.
diffev/prog/CMakeFiles/diffev.dir/preinstall: diffev/prog/CMakeFiles/CMakeRelink.dir/diffev
.PHONY : diffev/prog/CMakeFiles/diffev.dir/preinstall

diffev/prog/CMakeFiles/diffev.dir/requires: diffev/prog/CMakeFiles/diffev.dir/diffev.f90.o.requires
.PHONY : diffev/prog/CMakeFiles/diffev.dir/requires

diffev/prog/CMakeFiles/diffev.dir/clean:
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && $(CMAKE_COMMAND) -P CMakeFiles/diffev.dir/cmake_clean.cmake
.PHONY : diffev/prog/CMakeFiles/diffev.dir/clean

diffev/prog/CMakeFiles/diffev.dir/depend:
	cd /home/reinhard/develop/DiffuseCode && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/reinhard/develop/DiffuseCode /home/reinhard/develop/DiffuseCode/diffev/prog /home/reinhard/develop/DiffuseCode /home/reinhard/develop/DiffuseCode/diffev/prog /home/reinhard/develop/DiffuseCode/diffev/prog/CMakeFiles/diffev.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : diffev/prog/CMakeFiles/diffev.dir/depend

