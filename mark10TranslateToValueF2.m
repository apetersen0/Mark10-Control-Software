function [timeDataO,dispDataO,forceDataO,timeDataO2,varargout] = mark10TranslateToValueF2(f_serial,f_force,f_sFreq1,f_speed,f_units,axes_yy,plot_yyL,plot_yyR,plotR,f_timeData,f_dispData,f_forceData,f_auto,f_handles,f_hObject,imSocket,f_timeData2,button_stop,t)
timeDataO=[];
timeDataO2=[];
dispDataO=[];
forceDataO=[];

%frequency for image sampling
f_sFreq2 = str2double(get(f_handles.edit_imagerate,'String'));

dispData=[];
timeData=[];
forceData=[];
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

disp(['force limit amount = ',num2str(f_force)]);

% Store initial displacement
dispinit = readDisp(f_serial,f_units);
temp_dispdata = dispinit;

% Stores inital force
forceinit = readForce(f_serial);
temp_forcedata = forceinit;

c1=1;
c2=1;

%sets the t=0 values
timeData(c1,1) = toc;
dispData(c1,1) = dispinit;
forceData(c1,1) = forceinit;

if(image==1 && t==1)
    timeData2(c2,1) = toc;
    pnet(imSocket,'write','a');
    disp(['image',num2str(c2),' triggered']);
    c2=c2+1;
end 

%Sets movement direction
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

  


% timer loop preperation
ind1=1;
nind1=1;

ind2=1;
nind2=1;

c1=c1+1;

try
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
                if(get(button_stop,'UserData')==1)
                    break;
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
                    else
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_dispData;dispData],[f_forceData;forceData],[f_timeData;timeData]);
                        end
                    end                
                    pause(0.00001); %needed for the plots to update, very small number
                end            
            end    
            if(temp_forcedata <= f_force)
                break
            end
            if(get(button_stop,'UserData')==1)
                break;
            end
            if(image==1)
                timeData2(c2,1) = toc;
                pnet(imSocket,'write','a');
                disp(['image',num2str(c2),' triggered']);        
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
                if(get(button_stop,'UserData')==1)
                    break;
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
                    else
                        if(rtplots==1)
                            rtPlot(f_hObject,f_handles,axes_yy,plot_yyL,plot_yyR,plotR,[f_dispData;dispData],[f_forceData;forceData],[f_timeData;timeData]);
                        end
                    end                
                    pause(0.00001); %needed for the plots to update, very small number
                end            
            end    
            if(temp_forcedata >= f_force)
                break
            end
            if(get(button_stop,'UserData')==1)
                break;
            end
            if(image==1)
                timeData2(c2,1) = toc;
                pnet(imSocket,'write','a');
                disp(['image',num2str(c2),' triggered']);  
                c2=c2+1;
            end 
            ind2=nind2;
        end
    end
catch err
    %end of function data assignment
    if(isempty(f_timeData)==1 && isempty(f_dispData)==1 && isempty(f_forceData)==1)
        dispDataO = dispData;
        timeDataO = timeData;
        forceDataO = forceData;
        timeDataO2 = timeData2;

    else
        dispDataO = [f_dispData;dispData];
        timeDataO = [f_timeData;timeData];
        forceDataO = [f_forceData;forceData];
        timeDataO2 = [f_timeData2;timeData2];

    end  
end

%end of function data assignment
if(isempty(f_timeData)==1 && isempty(f_dispData)==1 && isempty(f_forceData)==1)
    dispDataO = dispData;
    timeDataO = timeData;
    forceDataO = forceData;
    timeDataO2 = timeData2;
    
else
    dispDataO = [f_dispData;dispData];
    timeDataO = [f_timeData;timeData];
    forceDataO = [f_forceData;forceData];
    timeDataO2 = [f_timeData2;timeData2];
    
end  

