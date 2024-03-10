cmake_minimum_required(VERSION 3.2.2)
project(fpga_basics LANGUAGES C CXX ASM)

add_subdirectory(alu_verilate)
add_subdirectory(simple_clock)
add_subdirectory(complex_clock)
add_subdirectory(oled_spi)
add_subdirectory(simple_sram)
