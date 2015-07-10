function [output] = readDisp(ff_serial,ff_units)

fprintf(ff_serial,'x'); %request travel value
dispread = fscanf(ff_serial);
zz = 0;
if(strcmp(ff_units,'i')) 
    for jj = 1:length(dispread)
        if strcmp(dispread(jj),'m') == 0
            zz = zz + 1;
        else
            break
        end
    end
elseif(strcmp(ff_units,'b')) 
    for jj = 1:length(dispread)
        if strcmp(dispread(jj),'i') == 0
            zz = zz + 1;
        else
            break
        end
    end
end
output = str2double(dispread(1:zz));