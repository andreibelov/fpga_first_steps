set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-narrowing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-narrowing")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 11)

project("noop_spi")

include_directories(/usr/share/verilator/include)

set(DUT2_HEADERS "")
set(DUT2_SOURCES "")

file(GLOB DUT2_HEADERS "obj_dir/*.h")
file(GLOB DUT2_SOURCES "obj_dir/*.cpp")

set(DUT2_CXX_FLAGS -c -w -MMD -fcf-protection=none -mmanual-endbr -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -O3)
set(DUT2_LINK_FLAGS "")

#Generate the shared library from the sources
add_library(dut2 STATIC ${DUT2_SOURCES} ${DUT2_HEADERS})
target_include_directories(dut2 PRIVATE obj_dir)
target_compile_options(dut2 PRIVATE ${DUT2_CXX_FLAGS})
target_link_options(dut2 PRIVATE ${DUT2_LINK_FLAGS})

set(TARGET_NAME noop_spi_test)
set(TB_CFLAGS -c -w -fcf-protection=none -mmanual-endbr -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -O1)
set(TB_LINK_FLAGS -w -Wl,--gc-sections -O3)
add_executable(${TARGET_NAME} tb_oled_spi.cpp)
target_include_directories(${TARGET_NAME} PRIVATE include obj_dir)
target_compile_options(${TARGET_NAME} PRIVATE ${TB_CFLAGS})
target_link_options(${TARGET_NAME} PRIVATE ${TB_LINK_FLAGS})
