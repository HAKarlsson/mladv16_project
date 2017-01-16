function image=usps_matrix2image(image_vectors)
  [N,D] = size(image_vectors);
  image_matrix = [];
  for n=1:N
    Im = reshape(image_vectors(n,:), [16,16]);
    image_matrix = [image_matrix; Im];
  end
  image_matrix = image_matrix';
  image = mat2gray(image_matrix, [1, -1]);
