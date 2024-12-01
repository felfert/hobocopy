cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
if (NOT WIN32)
    MESSAGE(FATAL_ERROR "This can be build on Windows only")
endif()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Buildtag)
get_GitVersionTag(GIT_VERSION_TAG)
project(HoboCopy VERSION "${GIT_VERSION_TAG}")
message(STATUS "Version: ${CMAKE_PROJECT_VERSION}")
generate_buildtag(PROJECT_BUILDTAG)
message(STATUS "Buildtag: ${PROJECT_BUILDTAG}")
set(PROJECT_OWNER "hobocopy@fritz-elfert.de")

add_subdirectory(src)

set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${CMAKE_PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/license.txt")
set(CPACK_GENERATOR "WIX")
set(CPACK_WIX_UPGRADE_GUID "59e22abc-82b6-48f6-98cf-c021257f3b02")
set(CPACK_WIX_VERSION 3)
set(CPACK_WIX_PATCH_FILE "${CMAKE_BINARY_DIR}/install/msi.xml")
set(CPACK_WIX_COMPONENT_INSTALL ON)
set(CPACK_COMPONENTS_ALL "app" "pdb")
set(CPACK_COMPONENT_APP_DISPLAY_NAME "Application")
set(CPACK_COMPONENT_APP_REQUIRED ON)
set(CPACK_COMPONENT_PDB_DISPLAY_NAME "Debug database")
set(CPACK_COMPONENT_PDB_DISABLED ON)
add_subdirectory(install)

include(CPack)
