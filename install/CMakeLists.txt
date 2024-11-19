# MSVC redistributables taken from VisualStudio installation
# Since we build an MSI installer, we use the msm instead of
# the actual dlls
set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP ON)
include(InstallRequiredSystemLibraries)
list(POP_FRONT CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS _tmp)
string(REGEX REPLACE "^(.*Redist)/.*$" "\\1" _rdir "${_tmp}")
file(GLOB_RECURSE _msm "${_rdir}/*_CRT_x64.msm")
list(POP_FRONT _msm _tmp)
message(STATUS "MSM used for release: ${_tmp}")
file(TO_NATIVE_PATH "${_tmp}" VCREDIST_MERGEMODULE)
file(GLOB_RECURSE _msm "${_rdir}/*_DebugCRT_x64.msm")
list(POP_FRONT _msm _tmp)
message(STATUS "MSM used for debuging: ${_tmp}")
file(TO_NATIVE_PATH "${_tmp}" VCREDIST_MERGEMODULE_DEBUG)

string(TOLOWER "${CMAKE_PROJECT_NAME}" PROJECT_NAME_LC)
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/msi.xml.in" "${CPACK_WIX_PATCH_FILE}" @ONLY)
# nuspkg for chocolatey
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/${PROJECT_NAME_LC}.nuspec.in"
    "${CMAKE_BINARY_DIR}/install/chocolatey/${PROJECT_NAME_LC}.nuspec" @ONLY)
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/tools"
        DESTINATION "${CMAKE_BINARY_DIR}/install/chocolatey")
