mkdir build_%c_compiler%
cd build_%c_compiler%

cmake %CMAKE_ARGS% -GNinja                       ^
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5         ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"  ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"     ^
      -DCMAKE_BUILD_TYPE=Release                 ^
      -DCMAKE_C_FLAGS="%CFLAGS% -DWIN32"         ^
      -DCMAKE_CXX_FLAGS="%CXXFLAGS% -EHsc"       ^
      -DCMAKE_SHARED_LIBRARY_PREFIX=""           ^
      ..
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1

copy "%LIBRARY_PREFIX%"\bin\tiff.dll "%LIBRARY_PREFIX%"\bin\libtiff.dll
if errorlevel 1 exit /b 1
copy "%LIBRARY_PREFIX%"\lib\tiff.lib "%LIBRARY_PREFIX%"\lib\libtiff.lib
if errorlevel 1 exit /b 1

:REM https://gitlab.com/libtiff/libtiff/-/merge_requests/338
:REM copy "%LIBRARY_PREFIX%"\bin\tiffxx.dll "%LIBRARY_PREFIX%"\bin\libtiffxx.dll
:REM if errorlevel 1 exit /b 1

:REM hattne + hmaarrfk --- Aug 11, 2025
:REM https://github.com/conda-forge/libtiff-feedstock/issues/113
:REM We choose to remove the private libraries from the pkg-config file
:REM so that downstream packages can more freely depend on libtiff without
:REM also depending on its downstream dependencies
:REM We manually inspected the headers to determine that the headers of the dependencies are
:REM not exposed in the public headers of libtiff
findstr /v "^[^.]*.private:" "%LIBRARY_PREFIX%"\lib\pkgconfig\libtiff-4.pc > libtiff-4.pc.new
if errorlevel 1 exit /b 1
move /y libtiff-4.pc.new "%LIBRARY_PREFIX%"\lib\pkgconfig\libtiff-4.pc
if errorlevel 1 exit /b 1
