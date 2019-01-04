mkdir build_%c_compiler%
cd build_%c_compiler%

cmake -G"%CMAKE_GENERATOR%"                      ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"  ^
      -DCMAKE_BUILD_TYPE=Release                 ^
      -DCMAKE_C_FLAGS="%CFLAGS% -DWIN32"         ^
      -DCMAKE_CXX_FLAGS="%CXXFLAGS% -EHsc"       ^
      -DJPEG12_INCLUDE_DIR="%LIBRARY_INC%"       ^
      -DJPEG12_LIBRARY="%LIBRARY_LIB%\libjpeg.lib" ^
      -DCMAKE_SHARED_LIBRARY_PREFIX=""           ^
      ..
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1

copy "%LIBRARY_PREFIX%"\bin\tiff.dll "%LIBRARY_PREFIX%"\bin\libtiff.dll
copy "%LIBRARY_PREFIX%"\bin\tiffxx.dll "%LIBRARY_PREFIX%"\bin\libtiffxx.dll
