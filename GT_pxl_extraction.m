% Identification of pixels from a Raster Image corresponding to different polygon (shapefiles) areas
% This Polygon areas can be from collection of Ground-truth Points
% This example is identifying polygons with a specific crop-type (i.e. Soybean) or land cover type
% The raster image should be georegistered and in .tif format
% This excercise can be extended to identify multiple crops or land cover types

VH = imread('D:\SAR_VH\latur_vh.tif'); % reading single/multi-band raster image
VH = double(VH);
info = geotiffinfo('D:\SAR_VH\latur_vh.tif'); % reading georeference info of the raster image
height = info.Height;
width = info.Width;
[rows,cols] = meshgrid(1:width,1:height);
[x,y] = pix2map(info.RefMatrix, cols, rows); % x: longitude matrix, y: latitude matrix

soy = zeros(size(x,1),size(x,2)); % creating an empty matrix to store the locatio of soybean pixels
roi = shaperead('D:\field\fasal.shp'); % reading polygon shapefiles (i.e. Ground-truth)
x_roi = cell(size(roi,1),1); % empty cell to store longitude boundaries of polygons
y_roi = cell(size(roi,1),1); % empty cell to store latitude boundaries of polygons
for i=1:size(roi)
    roi_i = roi(i);
    % Identification of the polygons having 'Soy' (i.e. Soybean) as ground-truth
    if strcmp(roi_i.CROPS, 'Soy')
        x_roi{i} = roi_i.X;
        y_roi{i} = roi_i.Y;
        [in] = inpolygon(x,y,x_roi{i},y_roi{i});
        f2 = find(in==1);
        soy(f2) = 1; % pixels with soybean are assigned with value 1
    else
        x_roi{i} = [];
        y_roi{i} = [];
    end
end
[a, b] = find(soy == 1);
vh_soy = zeros(size(a,1),size(VH,3)); % empty matrix to store only soybean pixels
for j=1:size(a,1)
    vh_soy(j,:) = VH(a(j), b(j), :);
end
