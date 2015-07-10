function [timeDataO,dispDataO,forceDataO,timeDataO2] = mark10TranslateToValueF2(f_serial,f_force,f_sFreq1,f_speed,f_units,axes_yy,plot_yyL,plot_yyR,plotR,f_timeData,f_dispData,f_forceData,f_auto,f_handles,f_hObject,f_dOS,f_dIS,f_timeData2)
timeDataO=[];
timeDataO2=[];
dispDataO=[];
forceDataO=[];

sPeriod = 1/f_sFreq1;
f_sFreq2 = str2double(get(f_handles.edit_imagerate,'String'));

dispData=[];
timeData=[];
forceData=[];
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
dispinit = readDisp(f_serial,f_units);
temp_dispdata = dispinit;

% Stores inital force
forceinit = readForce(f_serial);
temp_forcedata = forceinit;


disp(['displacement amount = ',num2str(f_force)])
if(f_force-forceinit<0)
    disp('tt');
    fprintf(f_serial,'s');
    fprintf(f_serial,'d');              %move down
    
    %%verification of movement direction
    dirCode = 'AA';
    fprintf(f_serial,'p');
    dirCode = fscanf(f_serial);    
    while(1)
        if(~strcmp(dirCode,'AA'))
            if(strcmp(dirCode(1),'D'))
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
elseif(f_force-forceinit>0)
    disp('ss')
    fprintf(f_serial,'s');
    fprintf(f_serial,'u');              %move up
    
    %%verification of movement direction
    dirCode = 'AA';
    fprintf(f_serial,'p');
    dirCode = fscanf(f_serial);
    while(1)
        if(~strcmp(dirCode,'AA'))
            if(strcmp(dirCode(1),'U'))
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
dispData(c1,1) = dispinit;
forceData(c1,1) = forceinit;

% timer loop preperation
ind1=1;
nind1=1;

ind2=1;
nind2=1;

c1=c1+1;
c2=c2+1;

tic;
if(f_force-forceinit<0)
    while (temp_forcedata >= f_force)        
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_dispdata = readDisp(f_serial,f_units);
            temp_forcedata = readForce(f_serial);
            
            if(temp_forcedata <= f_force)
                break
            end
                
            if(nind1~=ind1)
                timeData(c1,1) = toc;
                dispData(c1,1) = temp_dispdata;
                forceData(c1,1) = temp_forcedata;
                ind1=nind1;
                c1=c1+1;
                
                %plots the data
                if(isempty(f_timeData)==1 && isempty(f_dispData)==1 && isempty(f_forceData)==1)
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,dispData,forceData,timeData);
                    end

                    dispDataO = dispData;
                    timeDataO = timeData;
                    forceDataO = forceData;
                    timeDataO2 = timeData2;
                else
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_dispData;dispData],[f_forceData;forceData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                    end

                    dispDataO = [f_dispData;dispData];
                    timeDataO = [f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1];
                    forceDataO = [f_forceData;forceData];
                    timeDataO2 = [f_timeData2;f_timeData2(lv2,1)+timeData2+1/f_sFreq1];
                end                
                pause(0.00001); %needed for the plots to update, very small number
            end            
        end    
        if(temp_forcedata <= f_force)
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
elseif(f_force-forceinit>0)
    while (temp_forcedata <= f_force)        
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_dispdata = readDisp(f_serial,f_units);
            temp_forcedata = readForce(f_serial);
            
            if(temp_forcedata >= f_force)
                break
            end
                
            if(nind1~=ind1)
                timeData(c1,1) = toc;
                dispData(c1,1) = temp_dispdata;
                forceData(c1,1) = temp_forcedata;
                ind1=nind1;
                c1=c1+1;
                
                %plots the data
                if(isempty(f_timeData)==1 && isempty(f_dispData)==1 && isempty(f_forceData)==1)
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,dispData,forceData,timeData);
                    end

                    dispDataO = dispData;
                    timeDataO = timeData;
                    forceDataO = forceData;
                    timeDataO2 = timeData2;
                else
                    if(rtplots==1)
                        rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_dispData;dispData],[f_forceData;forceData],[f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1]);
                    end

                    dispDataO = [f_dispData;dispData];
                    timeDataO = [f_timeData;f_timeData(lv,1)+timeData+1/f_sFreq1];
                    forceDataO = [f_forceData;forceData];
                    timeDataO2 = [f_timeData2;f_timeData2(lv2,1)+timeData2+1/f_sFreq1];
                end                
                pause(0.00001); %needed for the plots to update, very small number
            end            
        end    
        if(temp_forcedata >= f_force)
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

