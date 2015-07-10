function [output] = readTorque(ff_serial)

fprintf(ff_serial,'?');            % '?' sends current force value 
torqueread = fscanf(ff_serial);

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

output = str2double(torqueread);