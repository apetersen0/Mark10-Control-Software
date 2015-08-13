function [timeDataO,rotDataO,torqueDataO,timeDataO2,varargout] = mark10RotateToValueD2(f_serial,f_rot,f_sFreq1,f_speed,f_units,axes_yy,plot_yyL,plot_yyR,plotR,f_timeData,f_rotData,f_torqueData,f_auto,f_handles,f_hObject,f_dOS,f_dIS,f_timeData2,button_stop,t)
timeDataO=[];
timeDataO2=[];
rotDataO=[];
torqueDataO=[];

%frequency for image sampling
f_sFreq2 = str2double(get(f_handles.edit_imagerate,'String'));

rotData=[];
timeData=[];
torqueData=[];
timeData2=[];

lv=size(f_timeData,1);
lv2=size(f_timeData2,1);

rtplots = get(f_handles.checkbox_rtplot,'Value');
image = get(f_handles.checkbox_image,'Value');

%sets sequence segement speed
if(strcmp(f_units,'b'))
    fprintf(f_serial,['e',num2str(f_speed,'%06.3f')]); 
    disp(['speed set to: ',['e',num2str(f_speed,'%06.3f')]])
elseif(strcmp(f_units,'i'))
    fprintf(f_serial,['e',num2str(f_speed,'%07.2f')]); 
    disp(['speed set to: ',['e',num2str(f_speed,'%07.2f')]])
end
fprintf(f_serial,'o'); % sets speed to programmed speed

% Store initial displacement
rotinit = readRot(f_serial,f_units);
temp_rotdata = rotinit;

% Stores inital force
torqueinit = readTorque(f_serial);
temp_torquedata = torqueinit;


c1=1;
c2=1;

%sets the t=0 values
timeData(c1,1) = toc;
rotData(c1,1) = rotinit;
torqueData(c1,1) = torqueinit;

if(image==1 && t==1)
    timeData2(c2,1) = toc;
    f_dOS.writeBytes('a');
    disp(['image',num2str(c2),' triggered']);
    c2=c2+1;
end 

%Sets movement direction
disp(['rotation amount = ',num2str(f_rot)])
if(f_rot-rotinit<=0)
%     disp('tt');
    fprintf(f_serial,'s');
    fprintf(f_serial,'d');              %move ccw
    
    %%verification of movement direction
    dirCode = 'AA';
    fprintf(f_serial,'p');
    dirCode = fscanf(f_serial);    
    while(1)
%         disp(dirCode)
        if(~strcmp(dirCode,'AA'))
            if(strcmp(dirCode(1:3),' CC'))
                break;
            else
                fprintf(f_serial,'d');
                fprintf(f_serial,'p');
                dirCode = fscanf(f_serial);                
            end
        else
            fprintf(f_serial,'p');
            dirCode = fscanf(f_serial);
        end
    end
elseif(f_rot-rotinit>0)
%     disp('ss')
    fprintf(f_serial,'s');
    fprintf(f_serial,'u');              %move cw
    
    %%verification of movement direction
    dirCode = 'AA';
    fprintf(f_serial,'p');
    dirCode = fscanf(f_serial);
    while(1)
%         disp(dirCode);
        if(~strcmp(dirCode,'AA'))
            disp(dirCode(1:3));
            if(strcmp(dirCode(1:3),' CW'))
                break;
            else
                fprintf(f_serial,'u');
                fprintf(f_serial,'p');
                dirCode = fscanf(f_serial);                
            end
        else
            fprintf(f_serial,'p');
            dirCode = fscanf(f_serial);
        end
    end
else
    fprintf(f_serial,'s');
end
    


% timer loop preperation
ind1=1;
nind1=1;

ind2=1;
nind2=1;

c1=c1+1;

try
    if(f_rot-rotinit<0)
        while (temp_rotdata >= f_rot) 
            while(nind2==ind2)
                nind1 = floor(toc*f_sFreq1)+1;
                nind2 = floor(toc*f_sFreq2)+1;
                temp_rotdata = readRot(f_serial,f_units);
                temp_torquedata = readTorque(f_serial);

                if(temp_rotdata <= f_rot)
                    break
                end
                if(get(button_stop,'UserData')==1)
                    break;
                end

                if(nind1~=ind1)
                    timeData(c1,1) = toc;
                    rotData(c1,1) = temp_rotdata;
                    torqueData(c1,1) = temp_torquedata;
                    ind1=nind1;
                    c1=c1+1;

                    %plots the data
                    if(isempty(f_timeData)==1 && isempty(f_rotData)==1 && isempty(f_torqueData)==1)
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,rotData,torqueData,timeData);
                        end
                    else
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_rotData;rotData],[f_torqueData;torqueData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                        end
                    end                
                    pause(0.00001); %needed for the plots to update, very small number
                end            
            end    
            if(temp_rotdata <= f_rot)
                    break
            end
            if(get(button_stop,'UserData')==1)
                break;
            end
            if(image==1)
                timeData2(c2,1) = toc;
                f_dOS.writeBytes('a');
                disp(['image',num2str(c2),' triggered']);        
                c2=c2+1;
            end 
            ind2=nind2;
        end
    elseif(f_rot-rotinit>0)
        while (temp_rotdata <= f_rot)        
            while(nind2==ind2)
                nind1 = floor(toc*f_sFreq1)+1;
                nind2 = floor(toc*f_sFreq2)+1;
                temp_rotdata = readRot(f_serial,f_units);
                temp_torquedata = readTorque(f_serial);

                if(temp_rotdata >= f_rot)
                    break
                end
                if(get(button_stop,'UserData')==1)
                    break;
                end

                if(nind1~=ind1)
                    timeData(c1,1) = toc;
                    rotData(c1,1) = temp_rotdata;
                    torqueData(c1,1) = temp_torquedata;
                    ind1=nind1;
                    c1=c1+1;

                    %plots the data
                    if(isempty(f_timeData)==1 && isempty(f_rotData)==1 && isempty(f_torqueData)==1)
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,rotData,torqueData,timeData);
                        end
                    else
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_rotData;rotData],[f_torqueData;torqueData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                        end
                    end                
                    pause(0.00001); %needed for the plots to update, very small number
                end            
            end    
            if(temp_rotdata >= f_rot)
                    break
            end
            if(get(button_stop,'UserData')==1)
                    break;
            end 
            if(image==1)
                timeData2(c2,1) = toc;
                f_dOS.writeBytes('a');
                disp(['image',num2str(c2),' triggered']);  
                c2=c2+1;
            end 
            ind2=nind2;
        end
    end
catch
    %end of function data assignment
    if(isempty(f_timeData)==1 && isempty(f_dispData)==1 && isempty(f_forceData)==1)
        rotDataO = rotData;
        timeDataO = timeData;
        torqueDataO = torqueData;
        timeDataO2 = timeData2;
    else
        rotDataO = [f_rotData;rotData];
        timeDataO = [f_timeData;timeData];
        torqueDataO = [f_torqueData;torqueData];
        timeDataO2 = [f_timeData2;timeData2];
    end 
end

%end of function data assignment
if(isempty(f_timeData)==1 && isempty(f_rotData)==1 && isempty(f_torqueData)==1)
    rotDataO = rotData;
    timeDataO = timeData;
    torqueDataO = torqueData;
    timeDataO2 = timeData2;    
else
    rotDataO = [f_rotData;rotData];
    timeDataO = [f_timeData;timeData];
    torqueDataO = [f_torqueData;torqueData];
    timeDataO2 = [f_timeData2;timeData2];    
end  
