add_compile_options(/W4 /EHsc /diagnostics:caret)
add_compile_options(/wd4100) # equiv. to -Wno-unused-parameter
add_compile_options(/wd4250) # xyzProxy inherits RpcProxy::abc via dominance
add_compile_options(/wd4251) # memberOfxyz needs to have dll-interface to be used by clients of class xyz
add_compile_options(/wd4275) # non dll-interface class 'foo' used as base for dll-interface class 'bar'
add_compile_options(/wd4127) # MicrosoftBS-BS :-) (constexpr in conditionals is C++17 and we don't use that yet)

add_definitions("-D_UNICODE" "-DUNICODE" "-DPROJECT_VERSION=\"${CMAKE_PROJECT_VERSION}\"")

# Create RC file
string(REPLACE "." "," PROJECT_VERSION_CS "${CMAKE_PROJECT_VERSION}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/HoboCopy.rc.in" "${CMAKE_CURRENT_BINARY_DIR}/HoboCopy.rc" @ONLY)

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
    "${CMAKE_CURRENT_BINARY_DIR}/HoboCopy.rc"
)

target_link_libraries("${CMAKE_PROJECT_NAME}" vss_uuid.lib vssapi.lib msxml2.lib)
set_property(TARGET "${CMAKE_PROJECT_NAME}" APPEND_STRING PROPERTY LINK_FLAGS
    " /MANIFESTUAC:\"level='requireAdministrator' uiAccess='false'\" /SUBSYSTEM:CONSOLE")
install(TARGETS "${CMAKE_PROJECT_NAME}"
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
    DESTINATION /)
install(FILES $<TARGET_PDB_FILE:${CMAKE_PROJECT_NAME}> OPTIONAL DESTINATION /)
