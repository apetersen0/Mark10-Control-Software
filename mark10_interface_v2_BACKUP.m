%Author: Andy Petersen
%2015
%for: The Beam Team

function varargout = mark10_interface_v2_BACKUP(varargin)
% MARK10_INTERFACE_V2_BACKUP MATLAB code for mark10_interface_v2_BACKUP.fig
%      MARK10_INTERFACE_V2_BACKUP, by itself, creates a new MARK10_INTERFACE_V2_BACKUP or raises the existing
%      singleton*.
%
%      H = MARK10_INTERFACE_V2_BACKUP returns the handle to a new MARK10_INTERFACE_V2_BACKUP or the handle to
%      the existing singleton*.
%
%      MARK10_INTERFACE_V2_BACKUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARK10_INTERFACE_V2_BACKUP.M with the given input arguments.
%
%      MARK10_INTERFACE_V2_BACKUP('Property','Value',...) creates a new MARK10_INTERFACE_V2_BACKUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mark10_interface_v2_BACKUP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mark10_interface_v2_BACKUP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mark10_interface_v2_BACKUP

% Last Modified by GUIDE v2.5 11-Jun-2015 15:32:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mark10_interface_v2_BACKUP_OpeningFcn, ...
                   'gui_OutputFcn',  @mark10_interface_v2_BACKUP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mark10_interface_v2_BACKUP is made visible.
function mark10_interface_v2_BACKUP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mark10_interface_v2_BACKUP (see VARARGIN)

% Choose default command line output for mark10_interface_v2_BACKUP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mark10_interface_v2_BACKUP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp(' ');
disp(' ');
disp(' ');

cName = {'Type','Rate','Limit'};
startingData = {'Disp/Rotation Limit','80','5'};
set(handles.table_sequence,'ColumnName',cName);
set(handles.table_sequence,'Data',startingData);

%initializes handle based variables for the program
handles.selectedRow = 0;
handles.baudRate = 115200;
handles.dataBits = 8;
handles.COM = get(handles.edit_port,'String');
handles.loops = get(handles.edit_loop,'String');
handles.isAxial = get(handles.radbutton_axial,'Value');
handles.isTorque = get(handles.radbutton_torq,'Value');
handles.isLoop = 0;

handles.DISP_DATA = [];
handles.FORCE_DATA = [];

handles.ROT_DATA = [];
handles.TORQUE_DATA = [];

handles.TIMEA_DATA = [];
handles.TIMER_DATA = [];

handles.resume = 0;

handles.unitF='0';
handles.unitT='0';

handles.unitvF = get(handles.popup_unitsF,'Value');
handles.unitvT = get(handles.popup_unitsT,'Value');

set(handles.button_resume,'UserData',0);

set(handles.label_bits,'String',num2str(handles.dataBits));
set(handles.label_baud,'String',num2str(handles.baudRate));

handles.imageRate = 1;

if(get(handles.checkbox_loop,'Value')==1)
    set(handles.edit_loop,'Enable','on')
elseif(get(handles.checkbox_loop,'Value')==0)
    set(handles.edit_loop,'Enable','off')
end

set(handles.popup_unitsT,'Value',5);

%inital plot setup
t=0:.1:1;
y=zeros(length(t));

[handles.axes_yy,handles.plot_yyL,handles.plot_yyR] = plotyy(handles.axes_left,t,y,t,y);
set(handles.plot_yyL,'Color',[.0429,.0429,.789]);
set(handles.plot_yyR,'Color',[.796,.156,.156]);
handles.plotR = plot(handles.axes_right,t,y);

handles.plotLimits = [str2double(get(handles.edit7,'String')),str2double(get(handles.edit6,'String')),...
    str2double(get(handles.edit13,'String')),str2double(get(handles.edit12,'String')),...
    str2double(get(handles.edit15,'String')),str2double(get(handles.edit14,'String')),...
    str2double(get(handles.edit9,'String')),str2double(get(handles.edit8,'String')),...
    str2double(get(handles.edit17,'String')),str2double(get(handles.edit16,'String'))];

%check selected units for plot label variables
if(get(handles.popup_units,'Value')==1)
    switch(get(handles.popup_unitsF,'Value'))
        case(1)
            handles.unitF='N';
        case(2)
            handles.unitF='kN';
        case(3)
            handles.unitF='lbF';
        case(4)
            handles.unitF='ozF';
        case(5)
            handles.unitF='kgF';
    end
    switch(get(handles.popup_unitsT,'Value'))
        case(1)
            handles.unitT='N-mm';
        case(2)
            handles.unitT='kgF-mm';
        case(3)
            handles.unitT='gF-cm';
        case(4)
            handles.unitT='ozF-in';
        case(5)
            handles.unitT='N-cm';
    end
        handles.unitD='mm';
        handles.unitR='$^\circ$';
elseif(get(handles.popup_units,'Value')==2)
    
    switch(get(handles.popup_unitsF,'Value'))
        case(1)
            handles.unitF='N';
        case(2)
            handles.unitF='kN';
        case(3)
            handles.unitF='lbF';
        case(4)
            handles.unitF='ozF';
        case(5)
            handles.unitF='kgF';
    end
    switch(get(handles.popup_unitsT,'Value'))
        case(1)
            handles.unitT='N-mm';
        case(2)
            handles.unitT='kgF-mm';
        case(3)
            handles.unitT='gF-cm';
        case(4)
            handles.unitT='ozF-in';
        case(5)
            handles.unitT='N-cm';
    end
        handles.unitD='in';
        handles.unitR='rev';
end
    
% if(handles.isAxial==1)
%     %left plot AXIAL
%     title(handles.axes_left,'Real Time Displacement/Force vs. Time Data','FontSize',15,'Interpreter','Latex');    
%     xlabel(handles.axes_left,'Time (s)','FontWeight','bold','FontSize',14,'Interpreter','Latex');
%     ylabel(handles.axes_yy(1),['Displacement (',unitsD,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.0429,.0429,.789]);
%     ylabel(handles.axes_yy(2),['Force (',unitsF,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.796,.156,.156]);
%     
%     %right plot AXIAL
%     title(handles.axes_right,'Real Time Force vs. Displacement Data','FontSize',15,'Interpreter','Latex');
%     xlabel(handles.axes_right,['Displacement (',unitsD,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');
%     ylabel(handles.axes_right,['Force (',unitsF,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');
% elseif(handles.isTorque==1)
%     %left plot TORQUE
%     title(handles.axes_left,'Real Time Rotation/Torque vs. Time Data','FontSize',15,'Interpreter','Latex');    
%     xlabel(handles.axes_left,'Time (s)','FontWeight','bold','FontSize',14,'Interpreter','Latex');
%     ylabel(handles.axes_yy(1),['Rotation (',unitsR,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.0429,.0429,.789]);
%     ylabel(handles.axes_yy(2),['Torque (',unitsT,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.796,.156,.156]);
%     
%     %right plot TORQUE
%     title(handles.axes_right,'Real Time Torque vs. Rotation Data','FontSize',15,'Interpreter','Latex');
%     xlabel(handles.axes_right,['Rotation (',unitsR,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');                             
%     ylabel(handles.axes_right,['Torque (',unitsT,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');        
% end

set(handles.axes_left,'YGrid','on',...
    'YColor',[0 0 0],...
    'XGrid','on',...
    'XColor',[0 0 0],...
    'Color',[0.9725 0.9725 0.9725]);

set(handles.axes_right,'YGrid','on',...
    'YColor',[0 0 0],...
    'XGrid','on',...
    'XColor',[0 0 0],...
    'Color',[0.9725 0.9725 0.9725]);
uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles);

%used to display the beam team logo
axes(handles.axes_logo);
I = imread('bt-logo-with-brand_b.png','png');
imshow(I)

guidata(hObject,handles);


% --- Outputs from this function are returned to the command line.
function varargout = mark10_interface_v2_BACKUP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_port_Callback(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_port as text
%        str2double(get(hObject,'String')) returns contents of edit_port as a double

%text box check for valies COM port values
chosenPort = get(handles.edit_port,'String');
if(~isempty(chosenPort) && all(ismember(chosenPort,'0123456789')))
    handles.COM = chosenPort;
else
    set(handles.edit_port,'String',handles.COM);
end
msgbox('COM Port changed, make sure to select whether this is an AXIAL or ROTATIONAL load frame.');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in button_begin.
function button_begin_Callback(hObject, eventdata, handles)
% hObject    handle to button_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
import java.net.Socket
import java.io.*

sFreq = str2double(get(handles.edit_datarate,'String'));      % frequency for recording data

%potential solution (approximate) for sampling delay issue. Currently, code within sequence
%loops take about 40-50ms to complete => sampling is limited to ~20Hz max
%unless improvements can be made (note setting to 20Hz results in period
%0.086498s or ~11.5Hz)

% sPeriod=1/sFreq - 0.04; %approximate time to pull data/plot in real time
% if(sPeriod<=0)
%     sFreq=0.0001;
% end

baud = handles.baudRate; %numberic
bits = handles.dataBits; %numeric
comPort = handles.COM; %string format

set(handles.button_stop,'Enable','on');

% current handles for variable access
% handles.selectedRow
% handles.baudRate
% handles.dataBits
% handles.COM
% handles.loops  string format
% handles.isAxial
% handles.isTorque
% handles.isLoop
% handles.plotR    <-- plot handle for right plot

% handles.axes_yy
% handles.plot_yyL       <--- axes_yy return axes handles for left (1) and
                                % right(2). plot_yyL and yyR, are handles to the
                                % plot objects
% handles.plot_yyR

%begin serial connection
disp('*****************************');
disp(['COM',comPort,', Baud=',num2str(baud),' Bits=',num2str(bits)]);

handles.contrSerial = serial(['COM',comPort],'BaudRate',baud,'DataBits',bits); % this line sets an object for the controller

if(get(handles.checkbox_image,'Value')==1)
    ip='138.67.238.17';
    port='5200';
    
    disp('*****************************');
    disp(['IP',ip, '  PORT=',port]);
    
    %This code might work, test to see if it does later
    try
        imSocket = Socket(ip,str2double(port));
        dOS = DataOutputStream(imSocket.getOutputStream());
        handles.socketCreated = 1;
    catch error
        handles.socketCreated = 0;
        disp(['Socket Connection @ ',ip,' port ',port,' Failed']);
    end

        
end
%set(handles.contrSerial,'Parity','even');
try
    fopen(handles.contrSerial);    % This line opens communication to the controller
    disp('Connection Established');
    pause(0.5);
    if(get(handles.popup_units,'Value')==1)
        fprintf(handles.contrSerial,'i');
        pause(0.001);
        fprintf(handles.contrSerial,'i');
        pause(0.001);
        fprintf(handles.contrSerial,'i');
        units='i';
        disp('Code: i, units set to degrees') %sets units to mm&degrees
    elseif(get(handles.popup_units,'Value')==2)
        fprintf(handles.contrSerial,'b');
        pause(0.001);
        fprintf(handles.contrSerial,'b');
        pause(0.001);
        fprintf(handles.contrSerial,'b');
        units='b';
        disp('Code: b, units set to u=inches') %sets units to inches&rev
    end
    
    pause(1);
    
    %sets force units
    if(handles.isAxial==1)
        indcUnits=get(handles.popup_unitsF,'Value');
    elseif(handles.isTorque==1)
        indcUnits=get(handles.popup_unitsT,'Value');
    end
    
    %cycles through indicators units untill desired unit is selected
    %note that requesting the unit through 'A' has a slow resonse time from
    %the load frame, often times there is a timeout when waiting for input
    %buffer to have bytes available
    
    numC = 0;
    while(1)
        pause(0.01);
        fprintf(handles.contrSerial,'?');
        resp=fscanf(handles.contrSerial);
        
        disp(resp);
        disp(indcUnits);
        if(resp(1) == '*')            
            disp('flag')
            resp=fscanf(handles.contrSerial);    
            while(resp(1)=='*')
                resp=fscanf(handles.contrSerial);    
            end
        end
        if(handles.isAxial==1)
            switch indcUnits
                case(1)
                    if(~isempty(strfind(resp,' N')))                           
                        break;
                    end
                case(2)
                    if(~isempty(strfind(resp,'kN')))
                        break;
                    end
                case(3)
                    if(~isempty(strfind(resp,'lb')))
                        break;
                    end
                case(4)
                    if(~isempty(strfind(resp,'oz')))
                        break;
                    end
                case(5)
                    if(~isempty(strfind(resp,'kg')))
                        break;
                    end
            end
        elseif(handles.isTorque==1)
            disp(resp)
            switch indcUnits
                case(1)
                    if(~isempty(strfind(resp,'Nmm')))
                        break;
                    end
                case(2)
                    if(~isempty(strfind(resp,'gmm')))
                        break;
                    end
                case(3)
                    if(~isempty(strfind(resp,'gcm')))
                        break;
                    end
                case(4)
                    if(~isempty(strfind(resp,'zin')))
                        break;
                    end
                case(5)
                    if(~isempty(strfind(resp,'Ncm')))
                        break;
                    end
            end
        end
        fprintf(handles.contrSerial,'U');
        
        if(numC>=10)
            if(get(handles.popup_unitsT,'Value')==1)
                set(handles.popup_unitsT,'Value',5);
                msgbox('Unit not available for selection, selecting most similar unit.');
                numC=0;
            end
            if(get(handles.popup_unitsT,'Value')==3)
                msgbox('Unit not available for selection, selecting most similar unit.');
                set(handles.popup_unitsT,'Value',2);
                numC=0;
            end
            if(handles.isAxial==1)
                indcUnits=get(handles.popup_unitsF,'Value');
            elseif(handles.isTorque==1)
                indcUnits=get(handles.popup_unitsT,'Value');
            end
        end
        numC = numC+1;
    end


%     if(handles.isAxial==1)
%         switch indcUnits
%             case(1)
%                 fprintf(handles.contrSerial,'N');
%             case(2)
%                 fprintf(handles.contrSerial,'KN');
%             case(3)
%                 fprintf(handles.contrSerial,'LB');
%             case(4)
%                 fprintf(handles.contrSerial,'OZ');
%             case(5)
%                 fprintf(handles.contrSerial,'KG');
%         end
%     elseif(handles.isTorque==1)
%         switch indcUnits
%             case(1)
%                 fprintf(handles.contrSerial,'NMM');
%             case(2)
%                 fprintf(handles.contrSerial,'KGMM');
%             case(3)
%                 fprintf(handles.contrSerial,'GCM');
%             case(4)
%                 fprintf(handles.contrSerial,'OZIN');
%             case(5)
%                 fprintf(handles.contrSerial,'NCM');
%         end
%     end
        
    pause(1);
    
    %clears the plot data  
    set(handles.plot_yyL,'Ydata',0);
    set(handles.plot_yyL,'Xdata',0);
    
    set(handles.plot_yyR,'Ydata',0);
    set(handles.plot_yyR,'Xdata',0);
    
    set(handles.plotR,'Ydata',0);
    set(handles.plotR,'Xdata',0);        

    fprintf(handles.contrSerial,'z'); % sets current travel value to 0
    fprintf(handles.contrSerial,'R');
    disp('Travel Value Reset');
    
    numSeq = size(get(handles.table_sequence,'Data'),1);
    disp(['# of sequences=',num2str(numSeq)]);
    disp(['IsLoop=',num2str(handles.isLoop)]);
    
    %stores the current sequences
    dataSeq = get(handles.table_sequence,'Data');
    
    %stores if sequence gets looped
    if(handles.isLoop==1)
        tLoops=str2double(handles.loops);
    else
        tLoops=1;
    end
    
    disp(['tLoops=',num2str(tLoops)]);
    
    %contains auto scale plot info
    auto=[get(handles.checkbox_autoleft,'Value'),...
        str2double(get(handles.edit7,'String')),...
        str2double(get(handles.edit6,'String')),...
        get(handles.checkbox_autoright,'Value'),...
        str2double(get(handles.edit9,'String')),...
        str2double(get(handles.edit8,'String'))];
    
    if(handles.isAxial==1)
        
        handles.DISP_DATA = [];
        handles.FORCE_DATA = [];
        handles.TIMEA_DATA = [];
        

        for ll=1:tLoops
            for i=1:numSeq
                set(handles.text_seqNum,'String',['Sequence #: ',num2str(i)]);
                disp('*****************************')
                disp(['@ sequence # ',num2str(i)])
                type=dataSeq(i,1);
                speed = str2double(dataSeq(i,2));
                limit = str2double(dataSeq(i,3));

                disp(['Type=',type]);
                disp(['Speed=',dataSeq(i,2)]);
                disp(['Limit=',dataSeq(i,3)]);
                disp(' ');

                if(strcmp(type,'Disp/Rotation Limit'))
                     [handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA] = mark10TranslateToValueD2(handles.contrSerial,limit,sFreq,speed,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA,auto,handles,hObject);
                end
                if(strcmp(type,'Force/Torque Limit'))
                     [handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA] = mark10TranslateToValueF2(handles.contrSerial,limit,sFreq,speed,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA,auto,handles,hObject);
                end
                if(strcmp(type,'Pause (s)'))
                     [handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA] = mark10PauseTranslate2(handles.contrSerial,sFreq,limit,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMEA_DATA,handles.DISP_DATA,handles.FORCE_DATA,auto);
                end
                if(strcmp(type,'Pause (button)'))
                     fprintf(handles.contrSerial,'s');
                     set(handles.button_resume,'Enable','on')
                     while(get(handles.button_resume,'UserData')==0)
                        pause(0.01);                         
                     end
                     set(handles.button_resume,'Enable','off');
                     set(handles.button_resume,'UserData',0);
                end                
            end
        end


    elseif(handles.isTorque==1)
        
        handles.ROT_DATA = [];
        handles.TORQUE_DATA = [];
        handles.TIMER_DATA = [];
    
        for ll=1:tLoops
            for i=1:numSeq
                set(handles.text_seqNum,'String',['Sequence #: ',num2str(i)]);
                disp('*****************************')
                disp(['@ sequence # ',num2str(i)])
                type=dataSeq(i,1);
                speed = str2double(dataSeq(i,2));
                limit = str2double(dataSeq(i,3));

                disp(['Type=',type]);
                disp(['Speed=',dataSeq(i,2)]);
                disp(['Limit=',dataSeq(i,3)]);
                disp(' ');

                if(strcmp(type,'Disp/Rotation Limit'))
                     [handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA] = mark10RotateToValueD2(handles.contrSerial,limit,sFreq,speed,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA,auto,handles,hObject);
                end
                if(strcmp(type,'Force/Torque Limit'))
                     [handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA] = mark10RotateToValueT2(handles.contrSerial,limit,sFreq,speed,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA,auto,handles,hObject);
                end
                if(strcmp(type,'Pause (s)'))
                     [handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA] = mark10PauseTorque2(handles.contrSerial,sFreq,limit,units,handles.axes_yy,handles.plot_yyL,handles.plot_yyR,handles.plotR,handles.TIMER_DATA,handles.ROT_DATA,handles.TORQUE_DATA,auto);
                end
                if(strcmp(type,'Pause (button)'))
                     fprintf(handles.contrSerial,'s');
                     set(handles.button_resume,'Enable','on')
                     while(get(handles.button_resume,'UserData')==0)
                        pause(0.01);                         
                     end
                     set(handles.button_resume,'Enable','off');
                     set(handles.button_resume,'UserData',0);
                end                
            end
        end
    end
    
    fprintf(handles.contrSerial,'s'); %stop
    set(handles.text_seqNum,'String',['Sequence #: ',num2str(0)]);
    try
        disp('Sequence complete, serial connection closing...');
        fclose(handles.contrSerial);
        delete(handles.contrSerial);
        clear contrSerial;
        disp('Serial Connection Closed');
    catch ee
        disp(ee);
    end

catch error
    try
        fclose(handles.contrSerial);
        delete(handles.contrSerial);
        clear handles.contrSerial;
        disp('Serial communcation could not be established');
        disp(error);
    catch ee
        disp(ee);
    end
end

guidata(hObject,handles); 


% --- Executes on button press in button_stop.
function button_stop_Callback(hObject, eventdata, handles)
% hObject    handle to button_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    fprintf(handles.contrSerial,'s');
    fclose(handles.contrSerial);
    delete(handles.contrSerial);
    clear handles.contrSerial;
    disp('Sequence Stopped, Connection Closed');
    set(button_stop,'Enable','off');
catch ee
    disp(ee);
end

% --- Executes when entered data in editable cell(s) in table_sequence.
function table_sequence_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table_sequence (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
set(handles.table_sequence,'ColumnWidth',{115,45,41});

sequenceData = get(handles.table_sequence,'Data');

%handles case specific sequence value changes based based on context
for i=1:size(sequenceData,1)
    if(strcmp(sequenceData(i,1),'Disp/Rotation Limit') == 1)
        if(all(ismember(sequenceData{i,2},'-0123456789.')))
            if(all(ismember('-',sequenceData{i,2})))
                tString = sequenceData{i,2};  
                sequenceData(i,2) = {tString(2:end)};
            end           
        else
            sequenceData(i,2) = {'10'};
        end
        if(all(ismember(sequenceData{i,3},'-0123456789.')))
         
        else
            sequenceData(i,3) = {'1'};
        end
    end
    if(strcmp(sequenceData(i,1),'Force/Torque Limit') == 1)
        if(all(ismember(sequenceData{i,2},'-0123456789.')))
            if(all(ismember('-',sequenceData{i,2})))
                tString = sequenceData{i,2};  
                sequenceData(i,2) = {tString(2:end)};
            end           
        else
            sequenceData(i,2) = {'10'};
        end
        if(all(ismember(sequenceData{i,3},'-0123456789.')))
         
        else
            sequenceData(i,3) = {'1'};
        end
    end
    if(strcmp(sequenceData(i,1),'Pause (s)') == 1)
        sequenceData(i,2) = {'---'};
        if(all(ismember(sequenceData{i,3},'-0123456789')))
            if(all(ismember('-',sequenceData{i,3})))
                tString = sequenceData{i,3};  
                sequenceData(i,3) = {tString(2:end)};
            end           
        else
            sequenceData(i,3) = {'1'};
        end
    end
end
set(handles.table_sequence,'Data',sequenceData)
guidata(hObject,handles);


function edit_datarate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_datarate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_datarate as text
%        str2double(get(hObject,'String')) returns contents of edit_datarate as a double

tString=get(handles.edit_datarate,'String');
if(~isempty(tString) && all(ismember(tString,'-0123456789.')))
    if(all(ismember('-',get(handles.edit_datarate,'String'))))
        set(handles.edit_datarate,'String',tString(2:end));
    end 
else
    set(handles.edit_datarate,'String','20');
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_datarate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_datarate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_inverse.
function button_inverse_Callback(hObject, eventdata, handles)
% hObject    handle to button_inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_datarate,'String',num2str(1/(str2double(get(handles.edit_datarate,'String')))));
guidata(hObject,handles);

% --- Executes on selection change in popup_units.
function popup_units_Callback(hObject, eventdata, handles)
% hObject    handle to popup_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_units contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_units
if(get(handles.popup_units,'Value')==1)
    handles.DISP_DATA = handles.DISP_DATA.*25.4;
    handles.ROT_DATA = handles.ROT_DATA.*360;
elseif(get(handles.popup_units,'Value')==2)
    handles.DISP_DATA = handles.DISP_DATA./25.4;
    handles.ROT_DATA = handles.ROT_DATA./360;
end

disp(handles.unitvF)

switch(handles.unitvF)
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA.*1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA.*4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA.*0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA.*9.807;
end
switch(handles.unitvT)
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.01;
end

switch(get(handles.popup_unitsF,'Value'))
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA./1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA./4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA./0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA./9.807;
end
switch(get(handles.popup_unitsT,'Value'))
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.01;
end

handles.unitvF = get(handles.popup_unitsF,'Value');
handles.unitvT = get(handles.popup_unitsT,'Value');

if(get(handles.popup_units,'Value')==1)
    set(handles.uibuttongroup3,'Title','Sample Parameters (mm)');
elseif(get(handles.popup_units,'Value')==2)
    set(handles.uibuttongroup3,'Title','Sample Parameters (in)');
end

uibuttongroup2_ButtonDownFcn(hObject, eventdata, handles);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popup_units_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in table_sequence.
function table_sequence_CellSelectionCallback(hObject, eventdata, handles)

%current dropdown options
% Force/Torque Limit
% Disp/Rotation Limit
% Relax Time

set(handles.table_sequence,'ColumnWidth',{115,45,41});
%disp(get(handles.table_sequence,'Data'));
selectedCells = eventdata.Indices;
try 
    handles.selectedRow = selectedCells(1,1);
catch
end
guidata(hObject,handles);


% hObject    handle to table_sequence (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_add.
function button_add_Callback(hObject, eventdata, handles)
% hObject    handle to button_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedRow = handles.selectedRow;
if (selectedRow ~= 0)
    tMatrix = get(handles.table_sequence,'Data');
    tMatrix2 = vertcat(tMatrix(1:selectedRow,:),cell(1,3),tMatrix(selectedRow+1:end,:));
    set(handles.table_sequence,'Data',tMatrix2);
    handles.selectedRow = selectedRow + 1;
else
    tMatrix = get(handles.table_sequence,'Data');
    tMatrix2 = vertcat(tMatrix(1:end,:),cell(1,3));
    handles.selectedRow = size(tMatrix2,1);
    set(handles.table_sequence,'Data',tMatrix2);
end
guidata(hObject,handles);
    

% --- Executes on button press in button_delete.
function button_delete_Callback(hObject, eventdata, handles)
% hObject    handle to button_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedRow = handles.selectedRow;
if (selectedRow ~= 0)
    tMatrix = get(handles.table_sequence,'Data');
    tMatrix2 = vertcat(tMatrix(1:selectedRow-1,:),tMatrix(selectedRow+1:end,:));
    set(handles.table_sequence,'Data',tMatrix2);
    if(selectedRow>=0)
        handles.selectedRow = selectedRow -1;
    else
        handles.selectedRow = selectedRow;
    end
end
guidata(hObject,handles);


% --- Executes on button press in checkbox_loop.
function checkbox_loop_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_loop

if(get(handles.checkbox_loop,'Value')==1)
    set(handles.edit_loop,'Enable','on')
    handles.isLoop = 1;
elseif(get(handles.checkbox_loop,'Value')==0)
    set(handles.edit_loop,'Enable','off')
    handles.isLoop = 0;
end

guidata(hObject,handles);


function edit_loop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loop as text
%        str2double(get(hObject,'String')) returns contents of edit_loop as a double

loops = get(handles.edit_loop,'String');
if(~isempty(loops) && all(ismember(loops,'0123456789')))
    handles.loops = loops;
else
    set(handles.edit_loop,'String',handles.loops);
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radbutton_axial.
function radbutton_axial_Callback(hObject, eventdata, handles)
% hObject    handle to radbutton_axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radbutton_axial


% --- Executes on button press in radbutton_torq.
function radbutton_torq_Callback(hObject, eventdata, handles)
% hObject    handle to radbutton_torq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radbutton_torq


% --------------------------------------------------------------------
function uibuttongroup2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup2.
if(get(handles.radbutton_Rect,'Value')==1)
    set(handles.text_field1,'String','Width:');
    set(handles.text_field2,'String','Height:');    
    if(handles.isAxial==1)
        set(handles.edit_field1,'Enable','on');
        set(handles.edit_field2,'Enable','on');
    elseif(handles.isTorque==1)
        set(handles.edit_field1,'Enable','off');
        set(handles.edit_field2,'Enable','off');
    end
elseif(get(handles.radbutton_cyl,'Value')==1)
    set(handles.text_field1,'String','Outer Radius:');
    set(handles.text_field2,'String','Inner Radius:');
end
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isAxial = get(handles.radbutton_axial,'Value');
handles.isTorque = get(handles.radbutton_torq,'Value');

if(get(handles.popup_units,'Value')==1)
    switch(get(handles.popup_unitsF,'Value'))
        case(1)
            handles.unitF='N';
        case(2)
            handles.unitF='kN';
        case(3)
            handles.unitF='lbF';
        case(4)
            handles.unitF='ozF';
        case(5)
            handles.unitF='kgF';
    end
    switch(get(handles.popup_unitsT,'Value'))
        case(1)
            handles.unitT='N-mm';
        case(2)
            handles.unitT='kgF-mm';
        case(3)
            handles.unitT='gF-cm';
        case(4)
            handles.unitT='ozF-in';
        case(5)
            handles.unitT='N-cm';
    end
        handles.unitD='mm';
        handles.unitR='$^\circ$';
elseif(get(handles.popup_units,'Value')==2)
    
    switch(get(handles.popup_unitsF,'Value'))
        case(1)
            handles.unitF='N';
        case(2)
            handles.unitF='kN';
        case(3)
            handles.unitF='lbF';
        case(4)
            handles.unitF='ozF';
        case(5)
            handles.unitF='kgF';
    end
    switch(get(handles.popup_unitsT,'Value'))
        case(1)
            handles.unitT='N-mm';
        case(2)
            handles.unitT='kgF-mm';
        case(3)
            handles.unitT='gF-cm';
        case(4)
            handles.unitT='ozF-in';
        case(5)
            handles.unitT='N-cm';
    end
        handles.unitD='in';
        handles.unitR='rev';
end

if(handles.isAxial==1)
    %left plot AXIAL
    title(handles.axes_left,'Real Time Displacement/Force vs. Time Data','FontSize',15,'Interpreter','Latex');    
    xlabel(handles.axes_left,'Time (s)','FontWeight','bold','FontSize',14,'Interpreter','Latex');
    ylabel(handles.axes_yy(1),['Displacement (',handles.unitD,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.0429,.0429,.789]);
    ylabel(handles.axes_yy(2),['Force (',handles.unitF,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.796,.156,.156]);
    
    %right plot AXIAL
    title(handles.axes_right,'Real Time Force vs. Displacement Data','FontSize',15,'Interpreter','Latex');
    xlabel(handles.axes_right,['Displacement (',handles.unitD,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');
    ylabel(handles.axes_right,['Force (',handles.unitF,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');    
    
    
    set(handles.plot_yyL,'Ydata',handles.DISP_DATA');
    set(handles.plot_yyL,'Xdata',handles.TIMEA_DATA');

    set(handles.plot_yyR,'Ydata',handles.FORCE_DATA');
    set(handles.plot_yyR,'Xdata',handles.TIMEA_DATA');

    set(handles.axes_yy,'XLimMode','auto');
    set(handles.axes_yy,'YLimMode','auto');
    set(handles.axes_yy,'YTickMode','auto')


    set(handles.plotR,'Ydata',handles.FORCE_DATA');
    set(handles.plotR,'Xdata',handles.DISP_DATA');
    
elseif(handles.isTorque==1)
    %left plot TORQUE
    title(handles.axes_left,'Real Time Rotation/Torque vs. Time Data','FontSize',15,'Interpreter','Latex');    
    xlabel(handles.axes_left,'Time (s)','FontWeight','bold','FontSize',14,'Interpreter','Latex');
    ylabel(handles.axes_yy(1),['Rotation (',handles.unitR,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.0429,.0429,.789]);
    ylabel(handles.axes_yy(2),['Torque (',handles.unitT,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex','Color',[.796,.156,.156]);
    
    %right plot TORQUE
    title(handles.axes_right,'Real Time Torque vs. Rotation Data','FontSize',15,'Interpreter','Latex');
    xlabel(handles.axes_right,['Rotation (',handles.unitR,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');                             
    ylabel(handles.axes_right,['Torque (',handles.unitT,')'],'FontWeight','bold','FontSize',14,'Interpreter','Latex');    
    
    set(handles.plot_yyL,'Ydata',handles.ROT_DATA');
    set(handles.plot_yyL,'Xdata',handles.TIMER_DATA');

    set(handles.plot_yyR,'Ydata',handles.TORQUE_DATA');
    set(handles.plot_yyR,'Xdata',handles.TIMER_DATA');

    set(handles.axes_yy,'XLimMode','auto');
    set(handles.axes_yy,'YLimMode','auto');
    set(handles.axes_yy,'YTickMode','auto')


    set(handles.plotR,'Ydata',handles.TORQUE_DATA');
    set(handles.plotR,'Xdata',handles.ROT_DATA');
end

if(get(handles.radbutton_Rect,'Value')==1)
    set(handles.text_field1,'String','Width:');
    set(handles.text_field2,'String','Height:');    
    if(handles.isAxial==1)
        set(handles.edit_field1,'Enable','on');
        set(handles.edit_field2,'Enable','on');
    elseif(handles.isTorque==1)
        set(handles.edit_field1,'Enable','off');
        set(handles.edit_field2,'Enable','off');
    end
elseif(get(handles.radbutton_cyl,'Value')==1)
    set(handles.text_field1,'String','Outer Radius:');
    set(handles.text_field2,'String','Inner Radius:');
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function table_sequence_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to table_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.table_sequence,'ColumnWidth',{115,45,41});


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_inverse.
function button_inverse_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    
delete(hObject);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% xx=serial('COM5','BaudRate',115200,'DataBits',8);
% fopen(xx);
% disp('serial open')
% for(i=1:10)
%     fprintf(xx,'?');
% end
% % pause(2)
% x={};
% 
% % for(i=1:10)
% %     x{i}=fscanf(xx);
% % end
% fclose(xx);
% delete(xx);
% clear xx;
% disp('done')
% for(i=1:length(x))
%     disp(x{i});
% end
import java.net.Socket
import java.io.*

ip='138.67.238.17';
port='5200';

disp('*****************************');
disp(['IP',ip, '  PORT=',port]);

%This code might work, test to see if it does later
try
    imSocket = Socket(ip,str2double(port));
    dOS = DataOutputStream(imSocket.getOutputStream());
    handles.socketCreated = 1;
    
%     dOS.writeBytes('a');
    pause(2)
    dOS.writeBytes('Q');

    dOS.close();
    imSocket.close();

catch error
    handles.socketCreated = 0;
    disp(['Socket Connection @ ',ip,' port ',port,' Failed']);
    disp(error);
end

% --------------------------------------------------------------------
function uipushtool_save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = uiputfile({'*.mat','MAT File (*.mat)';...
%     '*.csv','Comma Seperated Value (*.csv)';...
    '*.txt','Tab Delimited (*.txt)';...
    '*.xlsx','Excel Spreadsheet (*.xlsx)'},'Save Output Data');

disp(filename);

%stores the values from the sample parameter text boxes
field1=str2double(get(handles.edit_field1,'String'));
field2=str2double(get(handles.edit_field2,'String'));

tempForce = handles.FORCE_DATA;
tempTorque = handles.TORQUE_DATA;

%Stress will be reported in pascals

%converts field values to (m)
if(get(handles.popup_unitsF,'Value')==1)
    field1 = field1/1000;
    field2 = field2/1000;
else
    field1 = field1*0.0254;
    field2 = field2*0.0254;
end

%converts force value to (N)
switch(get(handles.popup_unitsF,'Value'))
    case(1)
    case(2)
        tempForce = tempForce.*1000;
    case(3)
        tempForce = tempForce.*4.448;
    case(4)
        tempForce = tempForce.*0.278;
    case(5)
        tempForce = tempForce.*9.807;
end

%converts torque value to (N*m)
switch(get(handles.popup_unitsT,'Value'))
    case(1)
        tempTorque = tempTorque.*0.001;
    case(2)
        tempTorque = tempTorque.*0.009807;
    case(3)
        tempTorque = tempTorque.*0.00009807;
    case(4)
        tempTorque = tempTorque.*0.007062;
    case(5)
        tempTorque = tempTorque.*0.01;
end

%stress calculations
%field1 = outer radius/width
%field2 = inner radius/height

if(get(handles.radbutton_Rect,'Value')==1)
    if(handles.isAxial==1)
        stress=tempForce./(field1*field2);
    elseif(handles.isTorque==1)
        stress=[];
    end
elseif(get(handles.radbutton_cyl,'Value')==1)
    if(handles.isAxial==1)
        stress=tempForce./(pi*field1^2-pi*field2^2);
    elseif(handles.isTorque==1)
        stress=tempTorque./((pi/2)*(field1^4-field2^4)/field1);
    end
end


%saves the output data, along with the stress analysis data to file
if(isnumeric(filename)==0)
    disp(filename(length(filename)-2:end))
    if(strcmp(filename(length(filename)-2:end),'lsx'))
        if(handles.isAxial==1)
            exceldata = [handles.TIMEA_DATA,handles.FORCE_DATA,handles.DISP_DATA,stress];
        elseif(handles.isTorque==1)
            exceldata = [handles.TIMER_DATA,handles.TORQUE_DATA,handles.ROT_DATA,stress];
        end        
        xlswrite(filename, exceldata, 1, 'A7');
    end
    if(strcmp(filename(length(filename)-2:end),'txt'))
        if(handles.isAxial==1)
            outData = [handles.TIMEA_DATA,handles.FORCE_DATA,handles.DISP_DATA,stress];
        elseif(handles.isTorque==1)
            outData = [handles.TIMER_DATA,handles.TORQUE_DATA,handles.ROT_DATA,stress];
        end        
        save(filename,'outData','-ASCII');
    end
%     if(strcmp(filename(length(filename)-2:end),'csv'))
%         if(handles.isAxial==1)
%             outData = [handles.TIMEA_DATA,handles.FORCE_DATA,handles.DISP_DATA];
%         elseif(handles.isTorque==1)
%             outData = [handles.TIMER_DATA,handles.TORQUE_DATA,handles.ROT_DATA];
%         end        
%         disp(outData)
%         csvwrite(filename,outData);
%     end
    if(strcmp(filename(length(filename)-2:end),'mat'))
        if(handles.isAxial==1)
            outData = [handles.TIMEA_DATA,handles.FORCE_DATA,handles.DISP_DATA,stress];
        elseif(handles.isTorque==1)
            outData = [handles.TIMER_DATA,handles.TORQUE_DATA,handles.ROT_DATA];
        end        
        save(filename,'outData');
    end
end


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uiputfile({'*.dat','Sequence Data File (*.dat)'},'Save Sequence');
numSeq = size(get(handles.table_sequence,'Data'),1);
dataSeq = get(handles.table_sequence,'Data');

%saves sequence to .dat file format
for i=1:numSeq
    if(i==1)
        outData={dataSeq{i,1},dataSeq{i,2},dataSeq{i,3}};
        %disp(outData);
    else
        outData=[outData;{dataSeq{i,1},dataSeq{i,2},dataSeq{i,3}}];
        %disp(outData);
    end    
end

if(isnumeric(filename)==0)
    writetable(cell2table(outData),filename,'WriteVariableNames',0);
end

% --- Executes on button press in button_open.
function button_open_Callback(hObject, eventdata, handles)
% hObject    handle to button_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[t1,t2] = uigetfile({'*.dat','Sequence Data File (*.dat)'},'Open Sequence');
filename=[t2,t1];
%opens the sequence .dat file and loads it into the uitable
if(isnumeric(filename)==0)
    fid=fopen(filename);
    inData = textscan(fid,'%s%s%s','Delimiter',',');
    fclose(fid);
    
    M = [inData{1},inData{2},inData{3}];
    disp(M);
    set(handles.table_sequence,'Data',M);
    guidata(hObject,handles);
end

% --- Executes on button press in button_resume.
function button_resume_Callback(hObject, eventdata, handles)
% hObject    handle to button_resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%resume button for sequence entry.
%handle.resume NOT used as it does't update value while pause function is
%running. Updating user data (for the button) does save however and that is
%the current implementation used

handles.resume = 1;
disp(['from button ',num2str(handles.resume)]);
set(handles.button_resume,'UserData',1);
guidata(hObject,handles);


% --------------------------------------------------------------------
function mb_file_Callback(hObject, eventdata, handles)
% hObject    handle to mb_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mb_opseq_Callback(hObject, eventdata, handles)
% hObject    handle to mb_opseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_open_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function mb_svseq_Callback(hObject, eventdata, handles)
% hObject    handle to mb_svseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_save_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function mb_svod_Callback(hObject, eventdata, handles)
% hObject    handle to mb_svod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uipushtool_save_ClickedCallback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function mb_exit_Callback(hObject, eventdata, handles)
% hObject    handle to mb_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.output);


% --- Executes on button press in button_clear.
function button_clear_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.table_sequence,'Data',{'','',''})
handles.selectedRow=1;
guidata(hObject,handles)


% --- Executes on selection change in popup_unitsF.
function popup_unitsF_Callback(hObject, eventdata, handles)
% hObject    handle to popup_unitsF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_unitsF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_unitsF

switch(handles.unitvF)
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA.*1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA.*4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA.*0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA.*9.807;
end
switch(handles.unitvT)
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.01;
end

switch(get(handles.popup_unitsF,'Value'))
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA./1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA./4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA./0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA./9.807;
end
switch(get(handles.popup_unitsT,'Value'))
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.01;
end

handles.unitvF = get(handles.popup_unitsF,'Value');
handles.unitvT = get(handles.popup_unitsT,'Value');

 uibuttongroup2_ButtonDownFcn(hObject, eventdata, handles);
 guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popup_unitsF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_unitsF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_unitsT.
function popup_unitsT_Callback(hObject, eventdata, handles)
% hObject    handle to popup_unitsT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_unitsT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_unitsT
if(get(handles.popup_unitsT,'Value')==1)
    msgbox('Unit unavailable for program selection, chosen unit must be manually selected.');
end
if(get(handles.popup_unitsT,'Value')==3)
    msgbox('Unit unavailable for program selection, chosen unit must be manually selected.');
end

switch(handles.unitvF)
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA.*1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA.*4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA.*0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA.*9.807;
end
switch(handles.unitvT)
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA.*0.01;
end

switch(get(handles.popup_unitsF,'Value'))
    case(1)
    case(2)
        handles.FORCE_DATA = handles.FORCE_DATA./1000;
    case(3)
        handles.FORCE_DATA = handles.FORCE_DATA./4.448;
    case(4)
        handles.FORCE_DATA = handles.FORCE_DATA./0.278;
    case(5)
        handles.FORCE_DATA = handles.FORCE_DATA./9.807;
end
switch(get(handles.popup_unitsT,'Value'))
    case(1)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.001;
    case(2)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.009807;
    case(3)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.00009807;
    case(4)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.007062;
    case(5)
        handles.TORQUE_DATA = handles.TORQUE_DATA./0.01;
end

handles.unitvF = get(handles.popup_unitsF,'Value');
handles.unitvT = get(handles.popup_unitsT,'Value');

 uibuttongroup2_ButtonDownFcn(hObject, eventdata, handles);
 guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popup_unitsT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_unitsT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_field1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_field1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_field1 as text
%        str2double(get(hObject,'String')) returns contents of edit_field1 as a double
tString=get(handles.edit_field1,'String');
if(~isempty(tString) && all(ismember(tString,'0123456789.')))
    if(all(ismember('-',get(handles.edit_datarate,'String'))))
        set(handles.edit_field1,'String',tString);
    end 
else
    set(handles.edit_field1,'String','2');
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_field1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_field1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_field2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_field2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_field2 as text
%        str2double(get(hObject,'String')) returns contents of edit_field2 as a double
tString=get(handles.edit_field2,'String');
if(~isempty(tString) && all(ismember(tString,'0123456789.')))
    if(all(ismember('-',get(handles.edit_datarate,'String'))))
        set(handles.edit_field2,'String',tString);
    end 
else
    set(handles.edit_field2,'String','2');
end

% --- Executes during object creation, after setting all properties.
function edit_field2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_field2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.radbutton_Rect,'Value')==1)
    set(handles.text_field1,'String','Width:');
    set(handles.text_field2,'String','Height:');    
    if(handles.isAxial==1)
        set(handles.edit_field1,'Enable','on');
        set(handles.edit_field2,'Enable','on');
    elseif(handles.isTorque==1)
        set(handles.edit_field1,'Enable','off');
        set(handles.edit_field2,'Enable','off');
    end
elseif(get(handles.radbutton_cyl,'Value')==1)
    set(handles.text_field1,'String','Outer Radius:');
    set(handles.text_field2,'String','Inner Radius:');
    
    set(handles.edit_field1,'Enable','on');
    set(handles.edit_field2,'Enable','on');
end
guidata(hObject,handles);


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uibuttongroup2_ButtonDownFcn(hObject, eventdata, handles)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_autoright.
function checkbox_autoright_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autoright
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes on button press in checkbox_autoleft.
function checkbox_autoleft_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autoleft

handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handles=plotLimitUpdate(hObject,handles);
guidata(hObject,handles)



function edit_imagerate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imagerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_imagerate as text
%        str2double(get(hObject,'String')) returns contents of edit_imagerate as a double
handles.imageRate = str2double(get(handles.edit_imagerate,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_imagerate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imagerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox_image.
function checkbox_image_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_image
if(get(handles.checkbox_image,'Value')==1)
    set(handles.edit_imagerate,'Enable','on');
else
    set(handles.edit_imagerate,'Enable','off');
end


% --- Executes on button press in checkbox_rtplot.
function checkbox_rtplot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rtplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rtplot


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_ip_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ip as text
%        str2double(get(hObject,'String')) returns contents of edit_ip as a double


% --- Executes during object creation, after setting all properties.
function edit_ip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_port_Callback(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_port as text
%        str2double(get(hObject,'String')) returns contents of edit_port as a double


% --- Executes during object creation, after setting all properties.
function edit_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
