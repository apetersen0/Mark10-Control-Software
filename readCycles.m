function [output] = readCycles(ff_serial)

fprintf(ff_serial,'q');          % '?' sends currently displayed reading from mark10   
cycles = fscanf(ff_serial);

cycles(cycles=='C')='';
cycles(cycles=='y')='';
cycles(cycles=='c')='';
cycles(cycles=='l')='';
cycles(cycles=='e')='';
cycles(cycles=='s')='';

output = str2double(cycles);