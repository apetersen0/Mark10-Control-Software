function [output] = readForce(ff_serial)

fprintf(ff_serial,'?');          % '?' sends currently displayed reading from mark10   
forceread = fscanf(ff_serial);

forceread(forceread=='N')=' ';
forceread(forceread=='k')=' ';
forceread(forceread=='l')=' ';
forceread(forceread=='b')=' ';
forceread(forceread=='F')=' ';
forceread(forceread=='o')=' ';
forceread(forceread=='z')=' ';
forceread(forceread=='g')=' ';

output = str2double(forceread);