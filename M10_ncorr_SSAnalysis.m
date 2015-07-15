function M10_ncorr_SSAnalysis()

[t1,t2] = uigetfile('*.mat','Select ncorr Data Files','MultiSelect','On');
numFiles1 = length(t1);

[s1,s2] = uigetfile('*.mat','Select M10 Output Data File','MultiSelect','On');
numFiles2 = length(s1);

if(iscell(t1) && iscell(s1))
    if(numFiles1 ~= numFiles2)
        disp('File # mismatch');
        return;
    end

    outputData = cell(1,numFiles1);

    if(ischar(t1{1,1}) && ischar(s1{1,1}))
        for(i=1:numFiles1)
            disp(['Processing Data Set #',num2str(i)]);
            [timeData,forceData,stressData,strainData,strainStdData] = DIC_2d_strain_visualization_m10Intregrated([t2,t1{i}],[s2,s1{i}]);
            outputData(i) = {[{'Time','Force','Stress','Strain','Strain Std. Dev.'};num2cell([timeData,forceData,stressData,strainData,strainStdData])]};
        end
    else
        return
    end    
else
    numFiles1=1;
    outputData = cell(1,1);
    disp('Processing Data Set');
    [timeData,forceData,stressData,strainData,strainStdData] = DIC_2d_strain_visualization_m10Intregrated([t2,t1],[s2,s1]);
    outputData(1,1) = {[{'Time','Force','Stress','Strain','Strain Std. Dev.'};num2cell([timeData,forceData,stressData,strainData,strainStdData])]};
end
assignin('base','CombinedData',outputData);
disp('Data Set(s) Processed');

%%Plots strain (in+%)

for(i=1:numFiles1)
    figure;
    plot(1:size(outputData{1,i},1)-1,cell2mat(outputData{1,i}(2:end,4)));
    errorbar(cell2mat(outputData{1,i}(2:end,4)),cell2mat(outputData{1,i}(2:end,5)))
    xlabel('DIC frame')
    ylabel('Strain (yy)')
    title(['Stress vs. Strain for Data Set#',num2str(i)]);
end

if(numFiles1>1)
    figure
    hold on
    for(i=1:numFiles1)
        plot(cell2mat(outputData{1,i}(2:end,4)),-cell2mat(outputData{1,i}(2:end,3)).*10^-6,'-')
    end
    title('Stress vs. Strain')
    xlabel('Strain')
    ylabel('Stress (MPa)')
    hold off
end

t = cell(1,numFiles1);
for(i=1:numFiles1)
    t{i} = table(cell2mat(outputData{1,1}(2:end,1)),...
        cell2mat(outputData{1,1}(2:end,2)),...
        cell2mat(outputData{1,1}(2:end,3)),...
        cell2mat(outputData{1,1}(2:end,4)),...
        cell2mat(outputData{1,1}(2:end,5)),...
        'VariableNames',{'Time','Force','Stress','Strain','Strain_Std_Dev'});
end
filename = 'temp.xlsx';
writetable(t{1},filename,'Sheet',2,'WriteVariableNames',true)