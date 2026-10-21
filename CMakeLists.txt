cmake_minimum_required(VERSION 3.16)

project(DeviceVirtualUI VERSION 5.0 LANGUAGES CXX)

set(PROJECT_VERSION 5)
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 0)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_SHARED_LIBRARY_SUFFIX "")
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Detect UNIX-like systems
if(UNIX AND NOT APPLE)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Android")
        message("*** Android is not supported ...")
        set(ANDROID_LINUX TRUE)
    elseif(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
        message("-- Configuring for FreeBSD ...")
        set(FREEBSD TRUE)
    else()
        message("-- Configuring for GNU/Linux ...")
        set(GNU_LINUX TRUE)
    endif()
endif()

# Detect Apple platforms (macOS and iOS)
if(UNIX AND APPLE)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        # Darwin covers both macOS and iOS
        if(IOS)
            message("*** iOS is not supported ...")
            set(IOS TRUE)
        else()
            message("-- Configuring for macOS ...")
            set(MACOS TRUE)
        endif()
    endif()
endif()

# Detect Windows
if(WIN32)
    message("-- Configuring for Windows ...")
    set(WINDOWS TRUE)
endif()

if(DARWIN)
find_package(Qt6 6.10 REQUIRED COMPONENTS Quick Core Sql Qml Network)
qt_standard_project_setup(REQUIRES 6.10)
endif(DARWIN)

if(GNU_LINUX)
find_package(Qt6 6.10 REQUIRED COMPONENTS Quick Core Sql Qml Network)
qt_standard_project_setup(REQUIRES 6.10)
endif(GNU_LINUX)

if(WIN32)
find_package(Qt6 6.10 REQUIRED COMPONENTS Quick Core Sql Qml Network)
qt_standard_project_setup(REQUIRES 6.10)
endif(WIN32)

set(SOURCE_DIR ./src)
set(HEADER_DIR ./include)

include_directories(${PROJECT_HEADER_DIR} ./include)

set(SOURCES
${SOURCES}
${SOURCE_DIR}/main.cpp
${SOURCE_DIR}/Logger.cpp
${SOURCE_DIR}/DeviceVirtualApp.cpp
${SOURCE_DIR}/Help.cpp
${SOURCE_DIR}/Mqtt.cpp
${SOURCE_DIR}/Controller.cpp
${SOURCE_DIR}/UserInfo.cpp
)

set(HEADERS
${HEADERS}
${HEADER_DIR}/Logger.hpp
${HEADER_DIR}/DeviceVirtualApp.hpp
${HEADER_DIR}/Help.hpp
${HEADER_DIR}/GraphData.hpp
${HEADER_DIR}/ApplicationTheme.hpp
${HEADER_DIR}/Mqtt.hpp
${HEADER_DIR}/Controller.hpp
${HEADER_DIR}/Version.hpp
${HEADER_DIR}/UserInfo.hpp
)

set(RESOURCE_FILE ./resources/DeviceVirtualUI.qrc)

qt_add_executable(DeviceVirtualUI ${SOURCES} ${HEADERS} ${RESOURCE_FILE})

set_target_properties(DeviceVirtualUI PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER DeviceVirtualUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/darwin/Info.plist
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/darwin/Info.plist
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(DeviceVirtualUI
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Sql
    PRIVATE Qt6::Qml
    PRIVATE Qt6::Network
)

install(TARGETS DeviceVirtualUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
