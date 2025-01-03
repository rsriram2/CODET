%CAMs - COVID
mainFolder2= fullfile('Image Classification 2');
secondaryFolder2 = fullfile(mainFolder2, 'Dataset 3');
thirdFolder2 = fullfile(secondaryFolder2, 'archive');
fourthFolder2 = fullfile(thirdFolder2, 'Covid');
fifthFolder2 = fullfile(fourthFolder2, '2020.01.24.919183-p27-132.png');
im = imread(fifthFolder2);
sizeImage2 = net.Layers(1).InputSize;
aIm = augmentedImageDatastore(sizeImage2, im);

act1 = activations(net,aIm,'conv1');
sz = size(act1);
act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
I = imtile(mat2gray(act1),'GridSize',[8 8]);
imagesc(I)

act1chMax = act1(:,:,:,8);
act1chMax = mat2gray(act1chMax);
RGB = imresize(act1chMax,[551 725]);
% I = imtile({im,RGB})
% imagesc(I)
RGB2 = imgaussfilt(RGB, 1);
RGB_bin = RGB2 >= 50; 

CC = bwconncomp(RGB_bin);
numPixels = cellfun(@numel,CC.PixelIdxList);
%[biggest,idx] = max(numPixels);
RGB_bin(CC.PixelIdxList{idx}) = 0;

RGB_new = imclose(RGB_bin,strel('disk', 15));
imshow(imfuse(RGB_new, im,'ColorChannels',[1 2 0]))



% Max value
[maxValue,maxValueIndex] = max(max(max(act1)));
act1chMax = act1(:,:,:,maxValueIndex);
act1chMax = mat2gray(act1chMax);
I = imtile({im,act1chMax});
imagesc(act1chMax)
B = imgaussfilt(act1chMax, 1);
imagesc(B)
B_bin = B >= 0.5; 
B_new = imclose(B_bin,strel('disk', 1));
imagesc(B_new)
RGB2 = imresize(B_new,[551 725]);
imshow(imfuse(im, RGB2))

%CAMs - Pneumonia
mainFolder2= fullfile('Image Classification 2');
secondaryFolder2 = fullfile(mainFolder2, 'Pneumonia');
thirdFolder2 = fullfile(secondaryFolder2, '5 (4).jpg');
fourthFolder2 = fullfile(thirdFolder2, 'Covid (30).png');
im = imread(thirdFolder2);
sizeImage2 = net.Layers(1).InputSize;
aIm = augmentedImageDatastore(sizeImage2, im);


 %Channels 
act1 = activations(net,aIm,'conv1');
sz = size(act1);
act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
I = imtile(mat2gray(act1),'GridSize',[8 8]);
%imagesc(I)
act1chMax = act1(:,:,:,2);
act1chMax = mat2gray(act1chMax);
RGB = imresize(act1chMax,[279 354]);
imagesc(act1chMax)

 %Gauss   
RGB2 = imgaussfilt(RGB, 5);

 %Threshold
RGB_bin = RGB2 >= 0.5 & RGB2 <= 0.8; 
 
 %Close 
RGB_new = imclose(RGB_bin,strel('disk', 1));
final = imfuse(RGB_new, imresize(im, [279 354], 'ColorChannels',[2 2 1]));

imagesc(imresize(im, [279 354]))
imagesc(RGB_new);
imagesc(final)


% bwconncomp 
CC = bwconncomp(RGB_bin);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
RGB_bin(CC.PixelIdxList{idx}) = 0;