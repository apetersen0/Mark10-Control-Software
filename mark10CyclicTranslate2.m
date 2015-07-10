function [timeDataO,dispDataO,forceDataO,timeDataO2] = mark10CyclicTranslate2(f_serial,f_llimit,f_ulimit,f_cycles,f_sFreq1,f_speed,f_handles,f_hObject,f_dOS,f_dIS)

timeDataO=[];
dispDataO=[];
forceDataO=[];
% disp('AAAAA')
sPeriod = 1/f_sFreq1;
f_sFreq2 = str2double(get(f_handles.edit_imagerate,'String'));
dispData=[];
timeData=[];
forceData=[];
rtplots = get(f_handles.checkbox_rtplot,'Value');
image = get(f_handles.checkbox_image,'Value');

f_units = 'i';

%sets sequence segement speed
if(strcmp(f_units,'b'))
    fprintf(f_serial,['e',num2str(f_speed,'%06.3f')]); 
    disp(['speed set to: ',['e',num2str(f_speed,'%06.3f')]])
elseif(strcmp(f_units,'i'))
    fprintf(f_serial,['e',num2str(f_speed,'%07.2f')]); 
    disp(['speed set to: ',['e',num2str(f_speed,'%07.2f')]])
end
fprintf(f_serial,'o'); % sets speed to programmed speed

%sets number of cycles
fprintf(f_serial,['f',num2str(f_cycles,'%04.00f')]);
fprintf(f_serial,'r');
numCycles = fscanf(f_serial);
disp(['Set # of cycles is: ',numCycles]);

%sets upper and lower limits
if(f_llimit<0)
    fprintf(f_serial,['g',num2str(f_llimit,'%07.2f')]);
else
    fprintf(f_serial,['g',num2str(f_llimit,'%06.2f')]);
end

if(f_ulimit<0)
    fprintf(f_serial,['h',num2str(f_ulimit,'%07.2f')]);
else
    fprintf(f_serial,['h',num2str(f_ulimit,'%06.2f')]);
end

% Store initial displacement
dispinit = readDisp(f_serial,f_units);

% Stores inital force
forceinit = readForce(f_serial);


c1=1;
c2=1;

%sets the t=0 values
timeData(c1,1) = 0;
timeData2(c2,1) = 0;
dispData(c1,1) = dispinit;
forceData(c1,1) = forceinit;

fprintf(f_serial,'c'); % sets to cycle mode
cyc = 0;

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

fprintf(f_serial,'d');
fprintf(f_serial,'c'); % sets to cycle mode

cyc = 0;

fprintf(f_serial,'p')
xx=fscanf(f_serial);
disp(xx);


tic;
l=1;
while(cyc <= f_cycles)
    while(nind2==ind2)
        nind1 = floor(toc*f_sFreq1)+1;
        nind2 = floor(toc*f_sFreq2)+1;
        temp_dispdata = readDisp(f_serial,f_units);
        temp_forcedata = readForce(f_serial);
               
        %if moving down
%         if(~isempty(dispData)&&(temp_dispdata > dispData(c1-20,1)) && (dispData(c1-10,1)<dispData(c1-20,1)) && c1>20)
%             cyc=cyc+1;
%             disp('cycled');
%         end
        
        fprintf(f_serial,'p');
        xx=fscanf(f_serial);
        if(xx(1)=='U' && l==1)
            cyc=cyc+1;
            disp('cyc');
            l=0;
        elseif(xx(1)=='D' && l==0)
            l=1;
        end

        if(cyc >= f_cycles)
            break
        end

        if(nind1~=ind1)
            timeData(c1,1) = toc;
            dispData(c1,1) = temp_dispdata;
            forceData(c1,1) = temp_forcedata;
            ind1=nind1;
            c1=c1+1; 

            dispDataO = dispData;
            timeDataO = timeData;
            forceDataO = forceData;
            timeDataO2 = timeData2;
        end            
    end    
    if(cyc >= f_cycles)
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
%     cyc = readCycles(f_serial); 
%     disp(cyc);
    ind2=nind2;    
end
fprintf(f_serial,'s');
