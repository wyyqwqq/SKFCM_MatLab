clc;
clear;
close all;

topDirPath = './files';
dirLst = dir(topDirPath);
for j=1:length(dirLst)
    if(j > 2)
        direct = dirLst(j).name;
        if direct(1)=='.'
            continue
        end
        topDir = strcat(topDirPath,'/');
        final_path = strcat(topDir,direct);
        fileLst = dir(final_path);
    
        for i=1:length(fileLst)
            s1 = strcat(final_path,'/');
            s2 = fileLst(i).name;
            s2 = lower(s2);
            if(length(s2) > 4)
                f = strcat(s1,s2);
                disp(f);
                try
                    input = imread(f);
                    [origin_row, origin_col, origin_z] = size(input);

                    input_img = rgb2gray(input); %input is grayscale image
                    input_img = imresize(input_img, [100, 100]);
                    input_img = double(input_img);
                    %add padding
                    padding_input_img = padarray(input_img,[1 1], input(1,1),'both');
                    cluster_num = 3;
                    mask_img = skfcm(input_img, cluster_num, s2);
                    final_mask = imresize(mask_img, [origin_row, origin_col]);
                    figure
                    title('final mask')
                    imshow(final_mask)

                catch
                end
            end
        end
    end
end

