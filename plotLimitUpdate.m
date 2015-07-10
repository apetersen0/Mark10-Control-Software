function [outH] = plotLimitUpdate(hObject,handles)

check=[get(handles.checkbox_autoleft,'Value'),...
        get(handles.checkbox4,'Value'),...
        get(handles.checkbox_autoright,'Value'),...
        get(handles.checkbox5,'Value')];
    
limits=[str2double(get(handles.edit7,'String')),str2double(get(handles.edit6,'String')),...
    str2double(get(handles.edit13,'String')),str2double(get(handles.edit12,'String')),...
    str2double(get(handles.edit15,'String')),str2double(get(handles.edit14,'String')),...
    str2double(get(handles.edit9,'String')),str2double(get(handles.edit8,'String')),...
    str2double(get(handles.edit17,'String')),str2double(get(handles.edit16,'String'))];

disp('***')
disp(handles.plotLimits)
disp(limits)

%checks for valid entries into axes range textboxes
if(limits(2)<limits(1) || limits(2)==limits(1) || limits(4)<limits(3) || limits(4)==limits(3))
    set(handles.edit7,'String',num2str(handles.plotLimits(1)));
    set(handles.edit6,'String',num2str(handles.plotLimits(2)));
    set(handles.edit13,'String',num2str(handles.plotLimits(3)));
    set(handles.edit12,'String',num2str(handles.plotLimits(4)));
    
    limits(1)=handles.plotLimits(1);
    limits(2)=handles.plotLimits(2);
    limits(3)=handles.plotLimits(3);
    limits(4)=handles.plotLimits(4);
end
if(limits(6)<limits(5) || limits(6)==limits(5))
    set(handles.edit15,'String',num2str(handles.plotLimits(5)));
    set(handles.edit14,'String',num2str(handles.plotLimits(6)));
    
    limits(4)=handles.plotLimits(5);
    limits(5)=handles.plotLimits(6);
end

if(limits(8)<limits(7) || limits(8)==limits(7))
    set(handles.edit9,'String',num2str(handles.plotLimits(7)));
    set(handles.edit8,'String',num2str(handles.plotLimits(8)));
    
    limits(7)=handles.plotLimits(7);
    limits(8)=handles.plotLimits(8);
end
if(limits(10)<limits(9) || limits(10)==limits(9))
    set(handles.edit17,'String',num2str(handles.plotLimits(9)));
    set(handles.edit16,'String',num2str(handles.plotLimits(10)));
    
    limits(9)=handles.plotLimits(9);
    limits(10)=handles.plotLimits(10);
end

%sets the axes properties
if(check(1)==1)
    set(handles.axes_yy(1),'YLimMode','auto');
    set(handles.axes_yy(2),'YLimMode','auto');
else
    set(handles.axes_left,'YLimMode','manual');
    set(handles.axes_yy(1),'YLim',[limits(1),limits(2)]);
    set(handles.axes_yy(2),'YLim',[limits(3),limits(4)]);
end

if(check(2)==1)
    set(handles.axes_yy(1),'XLimMode','auto');
    set(handles.axes_yy(2),'XLimMode','auto');
else
    set(handles.axes_left,'XLimMode','manual');
    set(handles.axes_yy(1),'XLim',[limits(5),limits(6)]);
    set(handles.axes_yy(2),'XLim',[limits(5),limits(6)]);
end

if(check(3)==1)
    set(handles.axes_right,'YLimMode','auto');
else
    set(handles.axes_right,'YLimMode','manual');
    set(handles.axes_right,'YLim',[limits(7),limits(8)]);
end

if(check(4)==1)
    set(handles.axes_right,'XLimMode','auto');
else
    set(handles.axes_right,'XLimMode','manual');
    set(handles.axes_right,'XLim',[limits(9),limits(10)]);
end

handles.plotLimits = limits;
disp(handles.plotLimits)

outH=handles;
% handles.plotLimits = [str2double(get(handles.edit7,'String')),str2double(get(handles.edit6,'String')),...
%     str2double(get(handles.edit13,'String')),str2double(get(handles.edit12,'String')),...
%     str2double(get(handles.edit15,'String')),str2double(get(handles.edit14,'String')),...
%     str2double(get(handles.edit9,'String')),str2double(get(handles.edit8,'String')),...
%     str2double(get(handles.edit17,'String')),str2double(get(handles.edit16,'String'))];
