cmake_minimum_required(VERSION 3.22)

#
# This file is generated only once,
# and is not re-generated if converter is called multiple times.
#
# User is free to modify the file as much as necessary
#

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)


# Define the build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# Set the project name
set(CMAKE_PROJECT_NAME H563ZI)

# Include toolchain file
include("cmake/gcc-arm-none-eabi.cmake")

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Core project settings
project(${CMAKE_PROJECT_NAME})
message("Build type: " ${CMAKE_BUILD_TYPE})

# Enable CMake support for ASM and C languages
enable_language(C ASM)

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add STM32CubeMX generated sources
add_subdirectory(cmake/stm32cubemx)

# TOPPERS/ASP3 の STM32 Cube MX 用のコンパイラ定義をインクルード
include(../asp3/asp3_stm32cubemx.cmake)

# TOPPERS/ASP3 のカーネルオブジェクト定義のcfgファイルを設定
set(ASP3_APP_CFG_FILE ${ASP3_ROOT_DIR}/sample/sample1.cfg)

list(APPEND ASP3_INCLUDE_DIRS
    ${ASP3_ROOT_DIR}/sample
)

# TOPPERS/ASP3 のライブラリを追加
add_subdirectory(${ASP3_ROOT_DIR} asp3)

# TOPPERS/ASP3 付属のソースファイルを追加
include(${ASP3_ROOT_DIR}/library/library.cmake)
include(${ASP3_ROOT_DIR}/syssvc/syssvc.cmake)

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined library search paths
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user sources here
    ${ASP3_ROOT_DIR}/sample/sample1.c
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined include paths
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined symbols
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
    stm32cubemx

    # Add user defined libraries
    asp3
)

# TOPPERS/ASP3 のチェックを行う（シンボルがGCされるとエラーになるので省略）
#asp3_cfg_check(${CMAKE_PROJECT_NAME})
