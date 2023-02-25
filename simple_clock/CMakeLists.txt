set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-narrowing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-narrowing")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 11)

project("simple_clock")

include_directories(/usr/share/verilator/include)

set(DUT_HEADERS "")
set(DUT_SOURCES "")

file(GLOB DUT_HEADERS "obj_dir/*.h")
file(GLOB DUT_SOURCES "obj_dir/*.cpp")

set(DUT_CXX_FLAGS -c -w -MMD -fcf-protection=none -mmanual-endbr -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -O3)
set(DUT_LINK_FLAGS "")

#Generate the shared library from the sources
add_library(dut STATIC ${DUT_SOURCES} ${DUT_HEADERS})
target_include_directories(dut PRIVATE obj_dir)
target_compile_options(dut PRIVATE ${DUT_CXX_FLAGS})
target_link_options(dut PRIVATE ${DUT_LINK_FLAGS})

set(TARGET_NAME simple_clock)
set(TB_CFLAGS -c -w -fcf-protection=none -mmanual-endbr -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -O1)
set(TB_LINK_FLAGS -w -Wl,--gc-sections -O3)
add_executable(${TARGET_NAME} tb_counter_foo.cpp)
target_include_directories(${TARGET_NAME} PRIVATE include obj_dir)
target_compile_options(${TARGET_NAME} PRIVATE ${TB_CFLAGS})
target_link_options(${TARGET_NAME} PRIVATE ${TB_LINK_FLAGS})
