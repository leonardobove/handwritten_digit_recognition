function labels = loadMNISTlabels(filename)
%loadMNISTlabels returns a 1x[number of MNIST images] matrix containing
%th MNIST target labels.

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2049, ['Bad magic number in ', filename, '']);

numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');
labels = fread(fp, numLabels, 'uint8');

fclose(fp);
end