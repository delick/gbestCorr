%% Series Mean value, CI
% Calculates the mean value of a pixel time series. Due to lack of spatial
% reference, this script also borrows CRS info from raw images.

%% Params
% Inputs:
% * *Time series images* A series of 2D images.
% * *Raw imagery* An image with correct spatial reference to be borrowed.
% Outputs:
% * *Series mean value* An image of the mean values of all time series.
% * *Series CI value* An image of CI values of all time series.

%% Math formula
%
% $$CI = \frac{\sigma}{\overline{x}}$$
%
% where $\sigma$ is the standard deviation of a series, $\overline{x}$ is
% the mean value of the series.

%% I/O

% Choose time series imagery.
[file, path] = uigetfile({'*.tif'}, 'Choose gbest image series.', ...
    'Multiselect', 'on', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/图/TIFF/*gbest*.tif');
[~, fileLength] = size(file);
info = imfinfo(strcat(path,char(file(1))));
IM = zeros(info.Height, info.Width,fileLength);

% Choose image with correct spatial reference.
[file2, path2] = uigetfile({'*.tif'}, 'Choose gbest image series.', ...
    'Multiselect', 'off', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/2009-2016年原始影像/2009/CRS.tif');
[~,R] = geotiffread(fullfile(path2,file2));
crsInfo = geotiffinfo(fullfile(path2,file2));

%%
% Store results
avgIM = zeros(crsInfo.Height, crsInfo.Width);
stdIM = zeros(crsInfo.Height, crsInfo.Width);
avgIM2 = zeros(crsInfo.Height, crsInfo.Width);
stdIM2 = zeros(crsInfo.Height, crsInfo.Width);

% Read images.
for i = 1:fileLength
    IM(:,:,i) = imread(strcat(path,char(file(i))));
end

%% Calculating stats.
% total mean, std and CI value
avgIM(1:info.Height,1:info.Width) = nanmean(IM,3);
stdIM(1:info.Height,1:info.Width) = nanstd(IM,[],3);
ciIM = stdIM ./ avgIM;

% mean, std and CI value ignoring max and min
[maxMat,maxIdx] = max(IM,[],3);
[minMat,minIdx] = min(IM,[],3);
[max_row, max_col, max_page] = ind2sub(size(IM),maxIdx);
[min_row, min_col, min_page] = ind2sub(size(IM),minIdx);

IM(max_row, max_col, max_page) = nan;
IM(min_row, min_col, min_page) = nan;
avgIM2(1:info.Height,1:info.Width) = nanmean(IM,3);
stdIM2(1:info.Height,1:info.Width) = nanstd(IM,[],3);
ciIM2 = stdIM ./ avgIM;

% %% Exporting images
% % Output directory
% selected_dir = uigetdir('/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/图/Mean&CI/','Disturbance time output');
% 
% geotiffwrite(strcat(selected_dir,'/gbestMean'),avgIM,R,'CoordRefSysCode',32649);
% geotiffwrite(strcat(selected_dir,'/gbestMean2'),avgIM2,R,'CoordRefSysCode',32649);
% geotiffwrite(strcat(selected_dir,'/CI'),ciIM,R,'CoordRefSysCode',32649);
% geotiffwrite(strcat(selected_dir,'/CI2'),ciIM2,R,'CoordRefSysCode',32649);