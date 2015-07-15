function [time_images_data,reduced_force,reduced_stress] = m10_ncorr_dataCombine(filename)

xx = load(filename);

time_data = cell2mat(xx.outData(2:end,1));
force_data = cell2mat(xx.outData(2:end,2));
time_images_data = cell2mat(xx.outData(2:end,4));
stress_data = cell2mat(xx.outData(2:end,5));

index=1;
for(i=2:length(time_images_data))
    if(time_images_data(i)==0&&time_images_data(i-1)==0)
        index = i-1;
        break;
    end
end
time_images_data = time_images_data(1:index-1);


reduced_force = interp1(time_data,force_data,time_images_data);
reduced_stress = interp1(time_data,stress_data,time_images_data);
% 
% reduced_forceWRstrain = reduced_force(1:length(eyy_avg));
% reduced_stressWRstrain = reduced_stress(1:length(eyy_avg));

% figure
% plot(-eyy_avg,-reduced_stress*10^-6,'*');

