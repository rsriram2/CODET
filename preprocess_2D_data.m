% Save as Matfile w/ thresholding
myDir = uigetdir; 
directoryFiles = dir(fullfile(myDir,'*.nii')); 
mainFolder = fullfile('Image Classification 2');
secondaryFolder = fullfile(mainFolder, 'Fourth Iteration');
thirdFolder = fullfile(secondaryFolder, 'Test');
fourthFolder = fullfile(thirdFolder, 'Normal');
for k = 1: length(directoryFiles)
  baseFileName = directoryFiles(k).name;
  fullFileName = fullfile(directoryFiles(k).folder, baseFileName);
  C = niftiread(fullFileName);
  for j = 1: size(C, 3)
   B = C(:,:,j);
   im_new = double(B);
   im_new(B <= -700 | B >= -300) = 0;
   name = strcat(baseFileName(1:11),'_', num2str(j), '.mat');
   fullFileName2 = sprintf(fullfile(fourthFolder, name));
   save(fullFileName2, 'im_new')
  end
end

% Save as Matfile (w/o thresholding)
myDir = uigetdir; 
directoryFiles = dir(fullfile(myDir,'*.nii')); 
mainFolder = fullfile('Image Classification 2');
secondaryFolder = fullfile(mainFolder, 'Test Set 2');
thirdFolder = fullfile(secondaryFolder, 'Covid');
for k = 1: length(directoryFiles)
  baseFileName = directoryFiles(k).name;
  fullFileName = fullfile(directoryFiles(k).folder, baseFileName);
  C = niftiread(fullFileName);
  for j = 24
   im_new = imrotate(im2double(C(:,:,j)), 90);
   %im_new = double(B);
   name = strcat(baseFileName(1:10),'_', num2str(j), '.mat');
   fullFileName2 = sprintf(fullfile(thirdFolder, name));
   save(fullFileName2, 'im_new')
  end
end

%Save as jpg
myDir = uigetdir; 
directoryFiles = dir(fullfile(myDir,'*.nii')); 
mainFolder = fullfile('Image Classification 2');
secondaryFolder = fullfile(mainFolder, 'Train2');
for k = 1: length(directoryFiles)
  baseFileName = directoryFiles(k).name;
  fullFileName = fullfile(directoryFiles(k).folder, baseFileName);
  C = niftiread(fullFileName);
  for j = 1:size(C, 3)
   B = C(:,:,j);
   name = strcat(baseFileName(1:10),'_', num2str(j), '.jpeg');
   fullFileName2 = fullfile(secondaryFolder, name);
   imwrite(im2double(B), fullFileName2);
  end
end

%Convert PNG to Matfile
myDir = uigetdir; 
directoryFiles = dir(fullfile(myDir,'*.png')); 
mainFolder = fullfile('Image Classification 2');
secondaryFolder = fullfile(mainFolder, 'Test Set 3');
thirdFolder = fullfile(secondaryFolder, 'Normal');
for k = 1: length(directoryFiles)
  baseFileName = directoryFiles(k).name;
  fullFileName = fullfile(directoryFiles(k).folder, baseFileName);
   I = imread(fullFileName);
   I2 = im2double(I);
%    I2(I2 <= 0.433 |I2 >= 0.567) = 0;
   name = strcat('normal', num2str(k), '.mat');
   fullFileName2 = sprintf(fullfile(thirdFolder, name));
   save(fullFileName2, 'I2')
end


%Increase Brightness
myDir = uigetdir; 
directoryFiles = dir(fullfile(myDir,'*.jpg')); 
mainFolder = fullfile('Image Classification 2');
secondaryFolder = fullfile(mainFolder, 'First Iteration 2');
thirdFolder = fullfile(secondaryFolder, 'Normal');
for k = 1: length(directoryFiles)
  baseFileName = directoryFiles(k).name;
  fullFileName = fullfile(directoryFiles(k).folder, baseFileName);
   I = imread(fullFileName);
   I2 = imlocalbrighten(I);
   name = strcat('covid', num2str(k), '.mat');
   fullFileName2 = sprintf(fullfile(thirdFolder, name));
   save(fullFileName2, 'I2')
end
