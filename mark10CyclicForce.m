function [timeDataO,dispDataO,forceDataO,timeDataO2] = mark10CyclicForce(f_serial,f_llimit,f_ulimit,f_cycles,f_sFreq1,f_speed,f_isr,f_handles,f_hObject,f_dOS,f_dIS)

timeDataO=[];
dispDataO=[];
forceDataO=[];

%stores the array of lower limit values
fLLimits = f_llimit;

%image sample frequency
f_sFreq2 = f_isr;

dispData=[];
timeData=[];
forceData=[];
temp_forcedata = 0;

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

% Store initial displacement
dispinit = readDisp(f_serial,f_units);

% Stores inital force
forceinit = readForce(f_serial);

%counter variables for array indices
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

%increments the counter variables for, as t>0 measurements have been taken
c1=c1+1;
c2=c2+1;



%requests stand status (direction, mode etc.), only used for imformational
%purposes
fprintf(f_serial,'p');
xx=fscanf(f_serial);
disp(xx);

%starts the timer for time measurements
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
            disp(['image',num2str(c2),' triggered']);               
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
            disp(['image',num2str(c2),' triggered']);           
            c2=c2+1;
        end
        ind2=nind2;  
        %------------------------------------------------
    end
end
fprintf(f_serial,'s');