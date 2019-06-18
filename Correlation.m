%% Correlation between images.
% Calculates the correlation between average |gbest| image and |LAI|, |WSO|
% at different times.
% Author: DelickTang @ CUGB.

%% I/O
% % Choose image with correct spatial reference.
% [file, path] = uigetfile({'*.tif'}, 'Choose image with correct CRS.', ...
%     'Multiselect', 'off', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/2009-2016年原始影像/2009/CRS.tif');
% [~,R] = geotiffread(fullfile(path,file));
% 
% crsInfo = geotiffinfo(fullfile(path,file));

% Choose mask file.
[maskFile, maskPath] = uigetfile({'*.tif'}, 'Choose mask image.', ...
    'Multiselect', 'off', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/同化结果/CRS.tif');
mask = imread(fullfile(maskPath,maskFile));
mask(:,1567) = 0;
mask2vec = mask(:);
mask2vec = mask2vec(mask2vec ~= 0);
[x,~] = size(mask2vec);

% clear mask2vec;

% Choose LAI / WSO images.
[files, path2] = uigetfile({'*.tif'}, 'Choose LAI / WSO images.', ...
    'Multiselect', 'on', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/图/TIFF/*gbest*.tif');
[~, fileLength] = size(files);
info = imfinfo(strcat(path2,char(files(1))));

% Choose gbestMean images.
[filesMean, pathMean] = uigetfile({'*.tif'}, 'Choose LAI / WSO images.', ...
    'Multiselect', 'on', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/图/Mean&CI/gbestMean.tif');
[~, fileLengthMean] = size(filesMean);
avgSeries = zeros(x,fileLengthMean);
avgIM = nan(1566,1567);
for i = 1:fileLengthMean
    avgTemp = imread(strcat(pathMean,char(filesMean(i))));
    avgIM(:,:,i) = avgTemp;
    avgTemp(mask == 0) = nan;
    
    tempSeries = squeeze(avgTemp(:));
    avgSeries(:,i) = tempSeries(~isnan(tempSeries));
end
% clear avgTemp tempSeries;

% Choose output directory.
selected_dir = uigetdir('/home/dk/文档/Tutor/localSTMoran/(第二次挑选）衡阳盆地Landsat一致性数据生成结果/image/distStart/','Disturbance time output');


FN_LAI_Series = zeros(x,1);
corrMat = nan(fileLength,fileLengthMean);
corr2Mat = nan(fileLength,fileLengthMean);
%%
tic
for i = 1:fileLength
    temp1 = nan(size(mask));
    test = imread(strcat(path2,char(files(i))));
    temp1(1:info.Height, 1:info.Width) = test;
    temp1(mask==0) = nan;
    FN_LAI_Series = squeeze(temp1(:));
    FN_LAI_Series = FN_LAI_Series(~isnan(FN_LAI_Series));

    
    % Dealing with filenames (suffix part)
    name2 = char(files(i));
    name2 = name2(5:end-4);
    for j = 1:fileLengthMean
        % Dealing with filenames (prefix part)
        name1 = char(filesMean(j));
        name1 = name1(6:end-4);
        fullname = strcat(selected_dir,'Corr_',name1,name2);
        newAvgSeries = squeeze(avgSeries(:,j));
        corrMat(i,j) = corr2(FN_LAI_Series, newAvgSeries);
%         corr2Mat = normxcorr2(test,squeeze(avgIM(:,:,j)));
%         figure()
%         scatter(FN_LAI_Series, newAvgSeries)
    end
end

toc