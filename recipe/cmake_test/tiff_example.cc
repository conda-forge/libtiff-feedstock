// see https://gitlab.com/libtiff/libtiff/-/blob/master/build/test_cmake/test.c

#include "tiffio.h"

int main()
{
    TIFFGetVersion();
    return 0;
}
