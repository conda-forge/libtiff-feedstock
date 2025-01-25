# see https://gitlab.com/libtiff/libtiff/-/blob/master/build/test_cmake/CMakeLists.txt
project(cf_dummy LANGUAGES C CXX)
cmake_minimum_required(VERSION 3.12)
find_package(TIFF REQUIRED)

add_executable(tiff_example ${CMAKE_CURRENT_BINARY_DIR}/tiff_example.cc)
target_link_libraries(tiff_example PRIVATE TIFF::tiff)
