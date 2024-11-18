# vim:set sw=4 ts=4 et ai:
#
# This function generates a string for identifying the build in the form:
#
# <build-hostname>:<git-branchname>:<git-commithash>:<dirty|clean>
#
# Syntax:
#
# generate_buildtag(VARNAME)
#
# VARNAME is the name of the variable to be set
#
function(generate_buildtag VARNAME)
    execute_process(COMMAND git rev-parse HEAD WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        OUTPUT_VARIABLE _bt_id OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND git name-rev --name-only HEAD WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        OUTPUT_VARIABLE _bt_branch OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND git diff --quiet WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        RESULT_VARIABLE _diffres)
    if(_diffres EQUAL "0")
        set(_bt_state "clean")
    else()
        set(_bt_state "dirty")
    endif()
    if(WIN32)
        set(_bt_host "$ENV{COMPUTERNAME}")
    else()
        execute_process(COMMAND hostname OUTPUT_VARIABLE _bt_host OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()
    set(${VARNAME} "${_bt_host}:${_bt_branch}:${_bt_id}:${_bt_state}" PARENT_SCOPE)
endfunction()

# This function fetches the latest git tag that matches a 4-tuple version
#
# Syntax:
#
# get_GitVersionTag(VARNAME)
#
# VARNAME is the name of the variable to be set
#
function(get_GitVersionTag VARNAME)
    execute_process(COMMAND git describe --abbrev=0 --tags --match "[0-9]*.[0-9]*.[0-9]*.[0-9]*"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}" OUTPUT_VARIABLE _tmp ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    if("${_tmp}" MATCHES "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$")
        set(${VARNAME} "${_tmp}" PARENT_SCOPE)
    else()
        set(${VARNAME} "0.0.0.0" PARENT_SCOPE)
    endif()
endfunction()
