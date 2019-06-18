%% Grading Stats of gbest.
% Calculates the percentage and amount of pixels for each 0.1 gbest
% interval.

%% I/O
% Choose mask file.
[maskFile, maskPath] = uigetfile({'*.tif'}, 'Choose mask image.', ...
    'Multiselect', 'off', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/同化结果/CRS.tif');
mask = imread(fullfile(maskPath,maskFile));

% Choose gbest images.
[files, path] = uigetfile({'*.tif'}, 'Choose LAI / WSO images.', ...
    'Multiselect', 'on', '/home/dk/文档/论文/赵炳宇_毕业设计_数据整理/图/TIFF/*gbest*.tif');
[~, fileLength] = size(files);
info = imfinfo(strcat(path,char(files(1))));
IM = nan(info.Height, info.Width);
counts = zeros(10,fileLength);

%%
for i = 1:fileLength
    [temp,R] = geotiffread(strcat(path,char(files(i))));
    temp(mask == 0) = nan;
    temp = temp(:);
    
    for value = 1:10
        counts(value,i) = sum((temp> (value - 1) / 10) & (temp <= value / 10));
        if value == 1
            counts(value,i) = sum((temp>= (value - 1) / 10) & (temp <= value / 10));
        end
        
    end
    
end
