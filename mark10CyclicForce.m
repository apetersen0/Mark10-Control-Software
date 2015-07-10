function [timeDataO,dispDataO,forceDataO,timeDataO2] = mark10CyclicForce(f_serial,f_llimit,f_ulimit,f_cycles,f_sFreq1,f_speed,f_isr,f_handles,f_hObject,f_dOS,f_dIS)

timeDataO=[];
dispDataO=[];
forceDataO=[];
% disp('AAAAA')
% sPeriod = 1/f_sFreq1;
f_sFreq2 = f_isr;
dispData=[];
timeData=[];
forceData=[];
temp_forcedata = 0;
% rtplots = get(f_handles.checkbox_rtplot,'Value');
image = get(f_handles.checkbox_image,'Value');

%defaulting to mm/degrees
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

% %sets number of cycles
% fprintf(f_serial,['f',num2str(f_cycles,'%04.00f')]);
% fprintf(f_serial,'r');
% numCycles = fscanf(f_serial);

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

% timer loop preperation
ind1=1;
nind1=1;

ind2=1;
nind2=1;

c1=c1+1;
c2=c2+1;


% fprintf(f_serial,'c'); % sets to cycle mode

fprintf(f_serial,'p')
xx=fscanf(f_serial);
disp(xx);
            
tic;
for i=1:f_cycles
    disp(['Cycle #',num2str(i)]);
    fprintf(f_serial,'d');
    fprintf(f_serial,'d');
    temp_forcedata = readForce(f_serial);
    
    while(temp_forcedata >= f_llimit)
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_dispdata = readDisp(f_serial,f_units);
            temp_forcedata = readForce(f_serial);

            if(temp_forcedata <= f_llimit)
                break;
            end

            if(nind1~=ind1)
                % CODE THAT GETS TRIGGERED EVERY 1st SAMPLE RATE
                timeData(c1,1) = toc;
                dispData(c1,1) = temp_dispdata;
                forceData(c1,1) = temp_forcedata;
                ind1=nind1;
                c1=c1+1; 

                dispDataO = dispData;
                timeDataO = timeData;
                forceDataO = forceData;
                timeDataO2 = timeData2;
                %------------------------------------------------
            end            
        end
        if(temp_forcedata <= f_llimit)
            break;
        end 
        % CODE THAT GETS TRIGGERED EVERY 2nd SAMPLE RATE
        if(f_isr~=0)
            timeData2(c2,1) = toc;
            f_dOS.writeBytes('a');
            disp('image triggered');            
            c2=c2+1;
        end       
        ind2=nind2;
        %------------------------------------------------
    end
    
    fprintf(f_serial,'u');
    fprintf(f_serial,'u');
    temp_forcedata = readForce(f_serial);
            
    while(temp_forcedata <= f_ulimit)
        while(nind2==ind2)
            nind1 = floor(toc*f_sFreq1)+1;
            nind2 = floor(toc*f_sFreq2)+1;
            temp_dispdata = readDisp(f_serial,f_units);
            temp_forcedata = readForce(f_serial);

            if(temp_forcedata >= f_ulimit)
                break;
            end

            if(nind1~=ind1)
                % CODE THAT GETS TRIGGERED EVERY 1st SAMPLE RATE
                timeData(c1,1) = toc;
                dispData(c1,1) = temp_dispdata;
                forceData(c1,1) = temp_forcedata;
                ind1=nind1;
                c1=c1+1; 

                dispDataO = dispData;
                timeDataO = timeData;
                forceDataO = forceData;
                timeDataO2 = timeData2;
                %------------------------------------------------
            end            
        end    
        
        if(temp_forcedata >= f_ulimit)
            break;
        end  
        % CODE THAT GETS TRIGGERED EVERY 2nd SAMPLE RATE
        if(f_isr~=0)
            timeData2(c2,1) = toc;
            f_dOS.writeBytes('a');
            disp('image triggered');            
            c2=c2+1;
        end
        ind2=nind2;  
        %------------------------------------------------
    end
end
fprintf(f_serial,'s');
% if(f_isr~=0)
%         f_dOS.writeBytes('Q');
% end
