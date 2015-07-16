function [timeData,forceData,stressData,strainData,strainStdData] = DIC_2d_strain_visualization_m10Intregrated(filename1,filename2)
% 2D DIC strain analysis
%
% 1. Run handles_ncorr = ncorr
% 2. Save the data and load the MAT file
% 3. Run this
%

%%%Modified for fileopening and exporting of strain values

load(filename1);

num_of_dic_images = numel(current_save);
num_of_dic_structs = numel(data_dic_save);
num_of_dic_images_in_structs = zeros(num_of_dic_structs, 1);
for i = 1:num_of_dic_structs
    num_of_dic_images_in_structs(i) = numel(data_dic_save(i).strains);
end
%
% eyy = 2D distribution of xx strain component in the ROI
eyy = cell(num_of_dic_images,1);
% Save strain from each DIC result
dic_image_counter = 1;
for i = 1:num_of_dic_structs
    for j = 1:num_of_dic_images_in_structs(i)
        eyy{dic_image_counter} = data_dic_save(i).strains(j).plot_eyy_cur_formatted;
        dic_image_counter = dic_image_counter + 1;
    end
end
% Calculate mean and std deviation for each frame
% Calculate for eyy now
eyy_avg = zeros(num_of_dic_images,1);
eyy_std = zeros(num_of_dic_images,1);
for i = 1:num_of_dic_images
    eyy_temp = eyy{i};
    eyy_avg(i) = mean(eyy_temp(eyy_temp ~= 0));
    eyy_std(i) = std(eyy_temp(eyy_temp ~= 0));
end
% Plot avg strain and errorbars
% % h0 = figure;
% % plot(eyy_avg)
% % errorbar(eyy_avg, eyy_std)
% % xlabel('DIC frame')
% % ylabel('Strain (yy)')
%ylim([0 3e-3])
%
% Save an image sequence from 2d strain plots
make_image_sequence = 0;
strain_limits = [-0.05 0.05];
% plot_save_dir = 'C:/Users/Andy Petersen/My Documents/';
padding = 0.2; % Padding around the plot. 0 < padding < 0.2

if(make_image_sequence)
    close all;
    for i = 1:num_of_dic_images
        % Get bounding box for the first frame. We will crop all the images
        % to that bbox
        if(i == 1)
            eyy_temp = eyy{i};
            eyy_temp = abs(floor(eyy_temp/max(abs(eyy_temp(:)))*256));
            eyy_temp = uint8(eyy_temp);
            % Get bounding box
            eyy_bbox = regionprops(eyy_temp ~= 0, 'BoundingBox');
            eyy_bbox = eyy_bbox.BoundingBox;
            % We dilate the bbox by 20% so that the deformed configuration
            % fits in it as well.
            eyy_bbox(1) = floor(eyy_bbox(1) - padding*eyy_bbox(3));
            eyy_bbox(2) = floor(eyy_bbox(2) - padding*eyy_bbox(4));
            eyy_bbox(3) = floor(eyy_bbox(3) + 2.0*padding*eyy_bbox(3));
            eyy_bbox(4) = floor(eyy_bbox(4) + 2.0*padding*eyy_bbox(4));
        end
        % Plotting
        eyy_temp = eyy{i};
        h = figure;
        pcolor(eyy_temp(eyy_bbox(2):(eyy_bbox(2) + eyy_bbox(4)), ...
                        eyy_bbox(1):(eyy_bbox(1) + eyy_bbox(3))));
        shading flat;
        axis off;
        colorbar;
        set(gca, 'FontSize', 16)
        caxis([strain_limits(1) strain_limits(2)]);
        title(['Strain, average = ' num2str(eyy_avg(i)) ', stdev = ' num2str(eyy_std(i))]);
        print(h, '-dpng', fullfile(plot_save_dir, ['strain_2d_' sprintf('%04d', i)]));
        close(h);
    end
end

[timeData,forceData,stressData] = m10_ncorr_dataCombine(filename2);
strainData = eyy_avg;
strainStdData = eyy_std;