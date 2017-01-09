% == Diplay a number from US Postal Service Zip (number) data ==
% Input: 256 grey scale colors
% Author: Henrik
function usps_display(image_array)
  image_mat = reshape(image_array, [16,16]);
  I = mat2gray(image_mat', [1, -1]);
  imshow(I);
