import numpy as np
image_name = 'hopper_lzw.tif'

from PIL import Image
im = Image.open(image_name)
PIL_arr = np.asarray(im.load())

import cv2
# opencv uses BGR instead of RGB
arr = cv2.imread(image_name)[..., ::-1]

np.testing.assert_array_equal(arr, PIL_arr)

import tifffile
arr = tifffile.imread(image_name)
np.testing.assert_array_equal(arr, PIL_arr)
