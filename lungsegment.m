dir_path = 'D:\process_XZ\MLIII_Contrast_reconstructions';
subject_name = 'H-1489_MESAL-8012091_';
suf_40 = 'Mono40.nii';
suf_70 = 'Mono70.nii';
mixed = 'Mixed.nii';
VUNC = 'VUNC.nii';

InputImageE1_path = fullfile(dir_path,strcat( subject_name, VUNC));

%InputImageE13D = niftiread(InputImageE1_path);
%InputImageE23D = niftiread(InputImageE2_path);
InputImageM3D = niftiread(InputImageE1_path);

%[V,estDoS] = imnlmfilt(InputImageE13D);
V = im2single(InputImageM3D);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mask = false(size(V));
% for i =1:size(V,3)
%    XY = V(:,:,i);
% BW = XY > 0.49412;
% BW = imcomplement(BW);
% BW = imclearborder(BW);
% BW = imfill(BW, 'holes');
% radius = 3;
% decomposition = 0;
% se = strel('disk',radius,decomposition);
% BW = imerode(BW, se);
% maskedImageXY = XY;
% maskedImageXY(~BW) = 0;
% mask(:,:,i) = maskedImageXY;
% end
%    se = strel('disk',6,decomposition);
% 
% for i =1:size(V,1)
%    YZ = mask(i,:,:);
%    YZ = imclose(YZ,se);
%       %YZ = imopen(YZ,se);
% YZ = imfill(YZ, 'holes');
% 
% mask(i,:,:) = YZ;
% end
% a = bwconncomp(mask);
% mask_2 = false(size(V));
% [~,I] = sort(cellfun(@length,a.PixelIdxList));
% mask_2(a.PixelIdxList{I(end)})=1;
% mask_2 = imfill(mask_2, 4,'holes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XY = V(:,:,220);
XZ = squeeze(V(220,:,:));
BW = XY > 0.49412;
BW = imcomplement(BW);
BW = imclearborder(BW);
BW = imfill(BW, 'holes');
radius = 3;
decomposition = 0;
se = strel('disk',radius,decomposition);
BW = imerode(BW, se);
maskedImageXY = XY;
maskedImageXY(~BW) = 0;
imagesc(maskedImageXY)

BW = imbinarize(XZ);
BW = imcomplement(BW);
BW = imclearborder(BW);
BW = imfill(BW,'holes');
radius = 3;
decomposition = 0;
se = strel('disk',radius,decomposition);
BW = imerode(BW, se);
maskedImageXZ = XZ;
maskedImageXZ(~BW) = 0;
imshow(maskedImageXZ)

mask = false(size(V));
mask(:,:,220) = maskedImageXY;
mask(220,:,:) = mask(220,:,:)|reshape(maskedImageXZ,[1,512,507]);
V = histeq(V);

BW = activecontour(V,mask,100,'Chan-Vese');
BW = imfill(BW,'holes');

segmentedImage = V.*single(BW);

radius = 7;
se = strel('disk',radius,decomposition);

for i =1:size(V,3)
   YZ = BW(:,:,i);
   YZ = imerode(YZ,se);
      %YZ = imopen(YZ,se);
end
