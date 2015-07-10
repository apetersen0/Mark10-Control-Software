function [timeDataO,rotDataO,torqueDataO] = mark10PauseTorque2(f_serial,f_sFreq,f_duration,f_units,axes_yy,plot_yyL,plot_yyR,plotR,f_timeData,f_rotData,f_torqueData,f_auto)

sPeriod = 1/f_sFreq;
rotData=[];
timeData=[];
torqueData=[];
lv=size(f_timeData,1);


% Store initial torque
fprintf(f_serial,'?'); %requests travel value
torqueinit = fscanf(f_serial);
disp(['read travel value= ',torqueinit]);
zz = 0;
disp(['sequence unit code = ',f_units,', or mm'])

torqueinit(torqueinit=='N')=' ';
torqueinit(torqueinit=='m')=' ';
torqueinit(torqueinit=='k')=' ';
torqueinit(torqueinit=='g')=' ';
torqueinit(torqueinit=='F')=' ';
torqueinit(torqueinit=='o')=' ';
torqueinit(torqueinit=='z')=' ';
torqueinit(torqueinit=='i')=' ';
torqueinit(torqueinit=='n')=' ';
torqueinit(torqueinit=='c')=' ';

torqueinit = str2double(torqueinit);
%fprintf(f_serial,'z'); %dont need to reset to 0


qq = 1;

% Read Torque
fprintf(f_serial,'?');            % '?' sends current force value 
torqueread = fscanf(f_serial);
disp(['torqueread initial = ',torqueread])
zz = 0;

torqueread(torqueread=='N')=' ';
torqueread(torqueread=='m')=' ';
torqueread(torqueread=='k')=' ';
torqueread(torqueread=='g')=' ';
torqueread(torqueread=='F')=' ';
torqueread(torqueread=='o')=' ';
torqueread(torqueread=='z')=' ';
torqueread(torqueread=='i')=' ';
torqueread(torqueread=='n')=' ';
torqueread(torqueread=='c')=' ';
        
torqueData(qq,1) = str2double(torqueread);

% Read and store rotation
fprintf(f_serial,'x');                  % 'x' request travel value
rotread = fscanf(f_serial);
disp(['dispread initial = ',rotread])

zz = 0;
if(strcmp(f_units,'i')) 
    for jj = 1:length(rotread)
        if strcmp(rotread(jj),'D') == 0
            zz = zz + 1;
        else
            break
        end
    end
elseif(strcmp(f_units,'b')) 
    for jj = 1:length(rotread)
        if strcmp(rotread(jj),'R') == 0
            zz = zz + 1;
        else
            break
        end
    end
end
rotData(qq,1) = str2double(rotread(1:zz));

%time
tic;
timeData(qq,1)=toc;

qq = qq + 1; %Above is @ the t=0 mark

fprintf(f_serial,'s');


%below is for t>0


while (toc <= f_duration)
    pause(sPeriod) 

    %force data
    fprintf(f_serial,'?');          % '?' sends currently displayed reading from mark10   
    torqueread = fscanf(f_serial);
    zz = 0;
    torqueread(torqueread=='N')=' ';
    torqueread(torqueread=='m')=' ';
    torqueread(torqueread=='k')=' ';
    torqueread(torqueread=='g')=' ';
    torqueread(torqueread=='F')=' ';
    torqueread(torqueread=='o')=' ';
    torqueread(torqueread=='z')=' ';
    torqueread(torqueread=='i')=' ';
    torqueread(torqueread=='n')=' ';
    torqueread(torqueread=='c')=' ';
    torqueData(qq,1) = str2double(torqueread);

    %rotation data
    fprintf(f_serial,'x'); %request travel value
    rotread = fscanf(f_serial);
    zz = 0;
    if(strcmp(f_units,'i')) 
        for jj = 1:length(rotread)
            if strcmp(rotread(jj),'D') == 0
                zz = zz + 1;
            else
                break
            end
        end
    elseif(strcmp(f_units,'b')) 
        for jj = 1:length(rotread)
            if strcmp(rotread(jj),'R') == 0
                zz = zz + 1;
            else
                break
            end
        end
    end
    rotData(qq,1) = str2double(rotread(1:zz));

    %time data
    timeData(qq,1) = toc;

    qq = qq + 1;

    %plots the data
    if(isempty(f_timeData)==1 && isempty(f_rotData)==1 && isempty(f_torqueData)==1)
        set(plot_yyL,'Ydata',rotData');
        set(plot_yyL,'Xdata',timeData');


        set(plot_yyR,'Ydata',torqueData');
        set(plot_yyR,'Xdata',timeData');

        set(axes_yy,'XLimMode','auto');
        set(axes_yy,'YLimMode','auto');
        set(axes_yy,'YTickMode','auto')


        set(plotR,'Ydata',torqueData');
        set(plotR,'Xdata',rotData');

        rotDataO = rotData;
        timeDataO = timeData;
        torqueDataO = torqueData;
    else
        set(plot_yyL,'Ydata',[f_rotData',rotData']);
        set(plot_yyL,'Xdata',[f_timeData',f_timeData(lv,1)+timeData']);


        set(plot_yyR,'Ydata',[f_torqueData',torqueData']);
        set(plot_yyR,'Xdata',[f_timeData',f_timeData(lv,1)+timeData']);

        set(axes_yy,'XLimMode','auto');
        set(axes_yy,'YLimMode','auto');
        set(axes_yy,'YTickMode','auto')


        set(plotR,'Ydata',[f_torqueData',torqueData']);
        set(plotR,'Xdata',[f_rotData',rotData']);

        rotDataO = [f_rotData;rotData];
        timeDataO = [f_timeData;f_timeData(lv,1)+timeData];
        torqueDataO = [f_torqueData;torqueData];
    end    
end

