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

# Utility rule file for diffevhlp.

# Include the progress variables for this target.
include diffev/prog/CMakeFiles/diffevhlp.dir/progress.make

diffev/prog/CMakeFiles/diffevhlp: diffev/prog/diffev.hlp

diffev/prog/diffev.hlp:
	$(CMAKE_COMMAND) -E cmake_progress_report /home/reinhard/develop/DiffuseCode/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Generating diffev.hlp"
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && cat /home/reinhard/develop/DiffuseCode/diffev/prog/appl_dif.hlp /home/reinhard/develop/DiffuseCode/lib_f90/lib_f90.hlp > /home/reinhard/develop/DiffuseCode/diffev/prog/diffev.hlp

diffevhlp: diffev/prog/CMakeFiles/diffevhlp
diffevhlp: diffev/prog/diffev.hlp
diffevhlp: diffev/prog/CMakeFiles/diffevhlp.dir/build.make
.PHONY : diffevhlp

# Rule to build all files generated by this target.
diffev/prog/CMakeFiles/diffevhlp.dir/build: diffevhlp
.PHONY : diffev/prog/CMakeFiles/diffevhlp.dir/build

diffev/prog/CMakeFiles/diffevhlp.dir/clean:
	cd /home/reinhard/develop/DiffuseCode/diffev/prog && $(CMAKE_COMMAND) -P CMakeFiles/diffevhlp.dir/cmake_clean.cmake
.PHONY : diffev/prog/CMakeFiles/diffevhlp.dir/clean

diffev/prog/CMakeFiles/diffevhlp.dir/depend:
	cd /home/reinhard/develop/DiffuseCode && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/reinhard/develop/DiffuseCode /home/reinhard/develop/DiffuseCode/diffev/prog /home/reinhard/develop/DiffuseCode /home/reinhard/develop/DiffuseCode/diffev/prog /home/reinhard/develop/DiffuseCode/diffev/prog/CMakeFiles/diffevhlp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : diffev/prog/CMakeFiles/diffevhlp.dir/depend

