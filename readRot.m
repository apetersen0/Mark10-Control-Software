function [output] = readRot(ff_serial,ff_units)

fprintf(ff_serial,'x');                  % 'x' request travel value
rotread = fscanf(ff_serial);
zz=0;
if(strcmp(ff_units,'i')) 
    for jj = 1:length(rotread)
        if strcmp(rotread(jj),'D') == 0
            zz = zz + 1;
        else
            break;
        end
    end
elseif(strcmp(ff_units,'b')) 
    for jj = 1:length(rotread)
        if strcmp(rotread(jj),'R') == 0
            zz = zz + 1;
        else
            break;
        end
    end
end
output = str2double(rotread(1:zz));
