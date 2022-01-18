%% read path
home_P = '.';
home_PET = '.';
P_paths_struct = dir([home_P, '\*.tif']);
PET_paths_struct = dir([home_PET, '\*.tif']);
P_paths = strings(1, length(P_paths_struct));
PET_paths = strings(1, length(PET_paths_struct));

for i=1:length(P_paths_struct)
    P_paths(i) = strcat(P_paths_struct(i).folder,'\', P_paths_struct(i).name);
    PET_paths(i) = strcat(PET_paths_struct(i).folder,'\', PET_paths_struct(i).name);
end

P_paths = P_paths.sorts();
PET_paths = PET_paths.sorts();

%% read tiff
P_PET_concat = [];
for i=1:length(P_paths)
    P_path = P_paths(i);
    PET_path = PET_paths(i);
    
    % read
    P = imread(P_path);
    P = single(P);
    PET = imread(PET_path);
    P_PET = P - PET;
    
    % cat together: denepend on the shape of img
    P_PET_concat(:, :, i) = P_PET;
end
%% cal SPEI
scale = 1;
nseas = 12;
size_ = size(P_PET_concat);
SPEI_concat = ones(size_);
for i = 1: size_(1)
    for j = 1: size_(2)
        P_PET_vector = P_PET_concat(i, j, :);
        SPEI_concat(i, j, :) = reshape(SPEI_SPI(P_PET_vector, scale, nseas), 1, 1, []);
    end
end
%% save
for i=1:length(P_paths_struct)
    out_path = strcat(P_paths_struct(i).folder,'\', 'SPEI', P_paths_struct(i).name);
    imwrite(SPEI_concat(:, :, i), out_path, 'tif')
end
    
