function [timeDataO,rotDataO,torqueDataO,timeDataO2] = mark10RotateToValueT2(f_serial,f_torque,f_sFreq1,f_speed,f_units,axes_yy,plot_yyL,plot_yyR,plotR,f_timeData,f_rotData,f_torqueData,f_auto,f_handles,f_hObject,f_dOS,f_dIS,f_timeData2)
timeDataO=[];
timeDataO2=[];
rotDataO=[];
torqueDataO=[];
disp('AAAAA')
sPeriod = 1/f_sFreq1;
f_sFreq2 = str2double(get(f_handles.edit_imagerate,'String'));
rotData=[];
timeData=[];
torqueData=[];
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


%Sets movement direction
disp(['torque amount = ',num2str(f_torque)])
if(f_torque-torqueinit<=0)
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
elseif(f_torque-torqueinit>0)
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

c1=1;
c2=1;
    
%sets the t=0 values
timeData(c1,1) = 0;
timeData2(c2,1) = 0;
rotData(c1,1) = readRot(f_serial,f_units);
torqueData(c1,1) = readTorque(f_serial);

% timer loop preperation
ind1=1;
nind1=1;

ind2=1;
nind2=1;

tic;
c1=c1+1;
c2=c2+1;

if(f_torque-torqueinit<0)
    while (temp_torquedata >= f_torque) 
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_rotdata = readRot(f_serial,f_units);
            temp_torquedata = readTorque(f_serial);
            
            if(temp_torquedata <= f_torque)
                break
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

                    rotDataO = rotData;
                    timeDataO = timeData;
                    torqueDataO = torqueData;
                    timeDataO2 = timeData2;
                else
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_rotData;rotData],[f_torqueData;torqueData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                    end

                    rotDataO = [f_rotData;rotData];
                    timeDataO = [f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1];
                    torqueDataO = [f_torqueData;torqueData];
                    timeDataO2 = [f_timeData2;timeData2];
                end                
                pause(0.00001); %needed for the plots to update, very small number
            end            
        end    
        if(temp_torquedata <= f_torque)
                break
        end
        if(image==1)
            timeData2(c2,1) = toc;
            f_dOS.writeBytes('a');
%             xx = f_dIS.readLine();
%             disp(xx);
            disp('image triggered');           
            c2=c2+1;
        end 
        ind2=nind2;
    end
elseif(f_torque-torqueinit>0)
    while (temp_torquedata <= f_torque)        
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_rotdata = readRot(f_serial,f_units);
            temp_torquedata = readTorque(f_serial);
            
            if(temp_torquedata >= f_torque)
                break
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

                    rotDataO = rotData;
                    timeDataO = timeData;
                    torqueDataO = torqueData;
                    timeDataO2 = timeData2;
                else
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_rotData;rotData],[f_torqueData;torqueData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                    end

                    rotDataO = [f_rotData;rotData];
                    timeDataO = [f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1];
                    torqueDataO = [f_torqueData;torqueData];
                    timeDataO2 = [f_timeData2;timeData2];
                end                
                pause(0.00001); %needed for the plots to update, very small number
            end            
        end    
        if(temp_torquedata >= f_torque)
                break
        end
        if(image==1)
            timeData2(c2,1) = toc;
            f_dOS.writeBytes('a');
%             xx = f_dIS.readLine();
%             disp(xx);
            disp('image triggered');           
            c2=c2+1;
        end 
        ind2=nind2;
    end
end
