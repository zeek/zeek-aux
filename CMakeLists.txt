project(BroAux C CXX)

if (NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "Could not find prerequisite C compiler")
endif ()

if (NOT CMAKE_CXX_COMPILER)
    message(FATAL_ERROR "Could not find prerequisite C++ compiler")
endif ()

########################################################################
## CMake Configuration

cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

# Prohibit in-source builds.
if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "In-source builds are not allowed. Please use "
                        "./configure to choose a build directory and "
                        "initialize the build configuration.")
endif ()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if ("${PROJECT_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    # uninstall target
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
                    @ONLY)

    add_custom_target(uninstall COMMAND
        ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif ()

# Keep RPATH upon installing so that user doesn't have to ensure the linker
# can find internal/private libraries or libraries external to the build
# directory that were explicitly linked against
if (NOT BINARY_PACKAGING_MODE)
    SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
endif ()

########################################################################
## Project/Build Configuration

if (ENABLE_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
else ()
    set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif ()

# don't set extra compile flags again if already declared in this scope
# (i.e. this project is included from Bro)
if (NOT EXTRA_COMPILE_FLAGS)
    set(EXTRA_COMPILE_FLAGS "-Wall -Wno-unused")

    if (ENABLE_DEBUG)
        # manual add of -g works around its omission in FreeBSD's CMake port
        set(EXTRA_COMPILE_FLAGS "${EXTRA_COMPILE_FLAGS} -g -DDEBUG")
    endif ()

    # Compiler flags may already exist in CMake cache (e.g. when specifying
    # CFLAGS environment variable before running cmake for the the first time)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EXTRA_COMPILE_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXTRA_COMPILE_FLAGS}")
endif ()

########################################################################
## Dependency Configuration

include(MacDependencyPaths)
include(FindRequiredPackage)

FindRequiredPackage(FLEX)
FindRequiredPackage(PCAP)
FindRequiredPackage(BIND)
FindRequiredPackage(OpenSSL)

if (MISSING_PREREQS)
    foreach (prereq ${MISSING_PREREQ_DESCS})
        message(SEND_ERROR ${prereq})
    endforeach ()
    message(FATAL_ERROR "Configuration aborted due to missing prerequisites")
endif ()

include_directories(BEFORE
                    ${BIND_INCLUDE_DIR}
                    ${PCAP_INCLUDE_DIR}
                    ${OpenSSL_INCLUDE_DIR}
                    )

########################################################################
## System Introspection

include(BroAuxConfigChecks)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(BEFORE ${CMAKE_CURRENT_BINARY_DIR})

########################################################################
## Recurse on sub-directories

# For binary packaging or if this is the main CMake project, go through
# the regular install target, else use a custom target so programs
# have to be explicitly installed by the user via "make install-aux"
macro(AddAuxInstallTarget _target)
    if (BINARY_PACKAGING_MODE OR
        "${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
        install(TARGETS ${_target} DESTINATION bin)
    else ()
        get_property(_target_loc TARGET ${_target} PROPERTY LOCATION)
        add_custom_target(install-${_target}
            COMMAND ${CMAKE_COMMAND} -E make_directory
                    ${CMAKE_INSTALL_PREFIX}/bin
            COMMAND ${CMAKE_COMMAND} -E copy ${_target_loc}
                    ${CMAKE_INSTALL_PREFIX}/bin)
        add_dependencies(install-${_target} ${_target})
        set(AUX_TARGETS install-${_target};${AUX_TARGETS})
        set(AUX_TARGETS ${AUX_TARGETS} PARENT_SCOPE)
    endif ()
endmacro(AddAuxInstallTarget)

add_subdirectory(adtrace)
add_subdirectory(bdcat)
add_subdirectory(nftools)
add_subdirectory(rst)

if (NOT (BINARY_PACKAGING_MODE OR
         "${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}") )
    add_custom_target(install-aux
        COMMENT "Bro auxiliary tools installed to ${CMAKE_INSTALL_PREFIX}/bin")
    add_dependencies(install-aux ${AUX_TARGETS})
endif ()

########################################################################
## Build Summary

if (CMAKE_BUILD_TYPE)
    string(TOUPPER ${CMAKE_BUILD_TYPE} BuildType)
endif ()

message(
    "\n==================|  Bro-Aux Build Summary  |==================="
    "\n"
    "\nInstall prefix:    ${CMAKE_INSTALL_PREFIX}"
    "\nDebug mode:        ${ENABLE_DEBUG}"
    "\n"
    "\nCC:                ${CMAKE_C_COMPILER}"
    "\nCFLAGS:            ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_${BuildType}}"
    "\nCXX:               ${CMAKE_CXX_COMPILER}"
    "\nCXXFLAGS:          ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${BuildType}}"
    "\nCPP:               ${CMAKE_CXX_COMPILER}"
    "\n"
    "\n================================================================\n"
)

########################################################################
## Show warning when installing user is different from the one that configured

install(CODE "
    if (NOT $ENV{USER} STREQUAL \$ENV{USER})
        message(STATUS \"ATTENTION: Install is being performed by user \"
                \"'\$ENV{USER}', but the build directory was configured by \"
                \"user '$ENV{USER}'. This may result in a permissions error \"
                \"when writing the install manifest, but you can ignore it \"
                \"and consider the installation as successful if you don't \"
                \"care about the install manifest.\")
    endif ()
")
