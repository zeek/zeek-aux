cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(ZeekAux C CXX)
include(cmake/CommonCMakeConfig.cmake)

# ##############################################################################
# Dependency Configuration

find_package(PCAP REQUIRED)

include_directories(BEFORE ${PCAP_INCLUDE_DIR})

# ##############################################################################
# System Introspection

include(CheckHeaders)
include(CheckFunctions)
include(CheckNameserCompat)
include(MiscTests)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(BEFORE ${CMAKE_CURRENT_BINARY_DIR})

# ##############################################################################
# Recurse on sub-directories

# For binary packaging or if this is the main CMake project, go through the
# regular install target, else use a custom target so programs have to be
# explicitly installed by the user via "make install-aux"
macro (AddAuxInstallTarget _target)
    if (BINARY_PACKAGING_MODE OR "${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
        install(TARGETS ${_target} DESTINATION bin)
    else ()
        add_custom_target(
            install-${_target} COMMAND ${CMAKE_COMMAND} -E make_directory
                                       ${CMAKE_INSTALL_PREFIX}/bin
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${_target}> ${CMAKE_INSTALL_PREFIX}/bin)
        add_dependencies(install-${_target} ${_target})
        set(AUX_TARGETS install-${_target};${AUX_TARGETS})
        set(AUX_TARGETS ${AUX_TARGETS} PARENT_SCOPE)
    endif ()
endmacro (AddAuxInstallTarget)

if (NOT ZEEK_MAN_INSTALL_PATH)
    set(ZEEK_MAN_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/share/man)
endif ()

add_subdirectory(adtrace)
add_subdirectory(zeek-archiver)
add_subdirectory(zeek-cut)
add_subdirectory(rst)

if (NOT (BINARY_PACKAGING_MODE OR "${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}"))
    add_custom_target(install-aux
                      COMMENT "Zeek auxiliary tools installed to ${CMAKE_INSTALL_PREFIX}/bin")
    add_dependencies(install-aux ${AUX_TARGETS})
endif ()

# ##############################################################################
# Build Summary

if (CMAKE_BUILD_TYPE)
    string(TOUPPER ${CMAKE_BUILD_TYPE} BuildType)
endif ()

message(
    "\n==================|  Zeek-Aux Build Summary  |=================="
    "\n"
    "\nBuild type:        ${CMAKE_BUILD_TYPE}"
    "\nBuild dir:         ${CMAKE_BINARY_DIR}"
    "\nInstall prefix:    ${CMAKE_INSTALL_PREFIX}"
    "\nDebug mode:        ${ENABLE_DEBUG}"
    "\n"
    "\nCC:                ${CMAKE_C_COMPILER}"
    "\nCFLAGS:            ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_${BuildType}}"
    "\nCXX:               ${CMAKE_CXX_COMPILER}"
    "\nCXXFLAGS:          ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${BuildType}}"
    "\n"
    "\n================================================================\n")

include(UserChangedWarning)
