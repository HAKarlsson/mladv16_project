% == Diplay a number from US Postal Service Zip (number) data ==
% Input: ID followed by 256 grey scale colors
% Author: Henrik Karlsson
function usps_display(image_array)
  image_mat = reshape(image_array(2:257), [16,16]);
  I = mat2gray(image_mat', [1, -1]);
  imshow(I);
  