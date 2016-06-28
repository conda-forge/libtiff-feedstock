#!/bin/bash

# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
#
source activate "${CONDA_DEFAULT_ENV}"

if [[ $(uname) == Darwin ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
  export CXX="${CXX} -stdlib=libc++"
elif [[ $(uname) == Linux ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
fi

# Pass explicit paths to the prefix for each dependency.
./configure --prefix="${PREFIX}" \
            --with-zlib-include-dir="${PREFIX}/include" \
            --with-zlib-lib-dir="${PREFIX}/lib" \
            --with-jpeg-include-dir="${PREFIX}/include" \
            --with-jpeg-lib-dir="${PREFIX}/lib" \
            --with-lzma-include-dir="${PREFIX}/include" \
            --with-lzma-lib-dir="${PREFIX}/lib"

make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install

rm -rf "${TIFF_BIN}" "${TIFF_SHARE}" "${TIFF_DOC}"

# For some reason --docdir is not respected above.
rm -rf "${PREFIX}/share"
