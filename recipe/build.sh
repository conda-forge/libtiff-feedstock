#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./config

# Pass explicit paths to the prefix for each dependency.
./configure --prefix="${PREFIX}" \
            --disable-static \
            --host=$HOST \
            --build=$BUILD \
            --with-zlib-include-dir="${PREFIX}/include" \
            --with-zlib-lib-dir="${PREFIX}/lib" \
            --with-jpeg-include-dir="${PREFIX}/include" \
            --with-jpeg-lib-dir="${PREFIX}/lib" \
            --with-lzma-include-dir="${PREFIX}/include" \
            --with-lzma-lib-dir="${PREFIX}/lib" \
            --with-zstd-include-dir="${PREFIX}/include" \
            --with-zstd-lib-dir="${PREFIX}/lib"

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check || (cat test/test-suite.log && exit 1)
fi
make install

rm -rf "${TIFF_BIN}" "${TIFF_SHARE}" "${TIFF_DOC}"

# For some reason --docdir is not respected above.
rm -rf "${PREFIX}/share"

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete

# hattne + hmaarrfk --- Aug 11, 2025
# https://github.com/conda-forge/libtiff-feedstock/issues/113
# We choose to remove the private libraries from the pkg-config file
# so that downstream packages can more freely depend on libtiff without
# also depending on its downstream dependencies
# We manually inspected the headers to determine that the headers of the dependencies are
# not exposed in the public headers of libtiff
grep -v "^[^\.]*\.private:" "${PREFIX}/lib/pkgconfig/libtiff-4.pc" > libtiff-4.pc.new
mv libtiff-4.pc.new "${PREFIX}/lib/pkgconfig/libtiff-4.pc"
