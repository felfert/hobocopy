cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(HoboCopy VERSION "1.0.0.0") 
if (NOT WIN32)
    MESSAGE(FATAL_ERROR "This can be build on Windows only")
endif()

set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${CMAKE_PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}")
#set(CPACK_COMPONENTS_ALL main)
#set(CPACK_COMPONENT_MAIN_GROUP "")
#set(CPACK_COMPONENT_MAIN_HIDDEN True)
#set(CPACK_COMPONENT_MAIN_REQUIRED True)
set(CPACK_GENERATOR "WIX")
set(CPACK_WIX_VERSION 3)
set(CPACK_WIX_UPGRADE_GUID "59e22abc-82b6-48f6-98cf-c021257f3b02")
set(CPACK_WIX_PATCH_FILE "${CMAKE_BINARY_DIR}/msi.xml")
#set(CPACK_WIX_COMPONENT_INSTALL OFF)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/license.txt")

add_compile_options(/W4 /EHsc /diagnostics:caret)
add_compile_options(/wd4100) # equiv. to -Wno-unused-parameter
add_compile_options(/wd4250) # xyzProxy inherits RpcProxy::abc via dominance
add_compile_options(/wd4251) # memberOfxyz needs to have dll-interface to be used by clients of class xyz
add_compile_options(/wd4275) # non dll-interface class 'foo' used as base for dll-interface class 'bar'
add_compile_options(/wd4127) # MicrosoftBS-BS :-) (constexpr in conditionals is C++17 and we don't use that yet)

add_definitions("-D_UNICODE" "-DUNICODE")

add_executable("${CMAKE_PROJECT_NAME}"
    CBackupState.cpp
    CComException.cpp
    CCopyAction.cpp
    CCopyFilter.cpp
    CDeleteAction.cpp
    CDirectoryAction.cpp
    CFilespecCopyFilter.cpp
    CHoboCopyException.cpp
    CIncludeAllCopyFilter.cpp
    CModifiedSinceCopyFilter.cpp
    Console.cpp
    COptions.cpp
    CParseOptionsException.cpp
    CWriterComponent.cpp
    CWriter.cpp
    HoboCopy.cpp
    OutputWriter.cpp
    stdafx.cpp
    Utilities.cpp
)

target_link_libraries("${CMAKE_PROJECT_NAME}" vss_uuid.lib vssapi.lib msxml2.lib)
set_property(TARGET "${CMAKE_PROJECT_NAME}" APPEND_STRING PROPERTY LINK_FLAGS
    " /MANIFESTUAC:\"level='requireAdministrator' uiAccess='false'\"")
install(TARGETS "${CMAKE_PROJECT_NAME}"
                PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                DESTINATION /)

# MSVC redistributables taken from VisualStudio installation
# The variable VCToolsRedistDir is set by vcvars.bat
file(TO_CMAKE_PATH "$ENV{VCToolsRedistDir}" _TMP1)
file(GLOB _TMP2 "${_TMP1}/MergeModules/*_CRT_x64.msm")
file(TO_NATIVE_PATH "${_TMP2}" VCREDIST_MERGEMODULE)
file(GLOB _TMP2 "${_TMP1}/MergeModules/*_DebugCRT_x64.msm")
file(TO_NATIVE_PATH "${_TMP2}" VCREDIST_MERGEMODULE_DEBUG)

configure_file("${CMAKE_SOURCE_DIR}/msi.xml.in"
                   "${CMAKE_BINARY_DIR}/msi.xml" @ONLY)

include(CPack)
