%% read path
home_P = 'H:\work\Xianyu\Õı”¿ºŒ\data\pretiff';
home_PET = 'H:\work\Xianyu\Õı”¿ºŒ\data\pettiff';
home_Out = 'H:\work\Xianyu\Õı”¿ºŒ\RESULT';
P_paths_struct = dir([home_P, '\*.tif']);
PET_paths_struct = dir([home_PET, '\*.tif']);

%% read tiff
P_PET_concat = [];
s = ['all tiff: ', num2str(length(P_paths_struct))]
for i=1:length(P_paths_struct)
    P_path = strcat(home_P,'\', P_paths_struct(i).name);
    PET_path = strcat(home_PET,'\', PET_paths_struct(i).name);
    
    % read
    P = imread(P_path);
    P = single(P);
    PET = imread(PET_path);
    P_PET = P - PET;
    
    % cat together: denepend on the shape of img
    P_PET_concat(:, :, i) = P_PET;
    
    s = ['read tiff: ', num2str(i)]
    
end
s = 'read over'
%% cal SPEI
scale = 1;
nseas = 12;
size_ = size(P_PET_concat);
s = ['all grid i: ', num2str(size_(1)), 'j: ', num2str(size_(2))]
SPEI_concat = ones(size_);
for i = 1: size_(1)
    for j = 1: size_(2)
        s = ['calculate SPEI at i: ', num2str(i), 'at j: ', num2str(j)]
        P_PET_vector = P_PET_concat(i, j, :);
        SPEI_concat(i, j, :) = reshape(SPEI_SPI(P_PET_vector, scale, nseas), 1, 1, []);
    end
end
s = 'calculate over'
%% save
for i=1:length(P_paths_struct)
    out_path = strcat(home_Out,'\', 'SPEI_', P_paths_struct(i).name);
    imwrite(SPEI_concat(:, :, i), out_path, 'tif')
end