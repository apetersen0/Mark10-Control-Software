ip = '127.0.0.1';
port2 = '5200';

t_fname = [cd,'\'];
t_fname(t_fname=='\')='/';

system(['M10_Imaging_Controller.exe ',...
    '1',' ',...
    port2,' ',...
    ['"',t_fname,'" '],...
    'BASLER_IM ',...
    '.tiff &']);
disp('*****************************');
disp(['IP',ip,'  PORT=',port2]);

imSocket = pnet('tcpconnect',ip,str2double(port2));
pnet(imSocket,'setreadtimeout',500);

disp('TCP/IP Socket Connection Established');

%         tt = dIS.readLine();
%         disp(tt);
while (true)
    resp = pnet(imSocket,'read',1);
    if(resp == 'r')
        pnet(imSocket,'write','r');
        break;
    end
end

disp('received ready command');