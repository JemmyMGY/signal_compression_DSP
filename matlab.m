function varargout = matlab(varargin)
% MATLAB MATLAB code for matlab.fig
%      MATLAB, by itself, creates a new MATLAB or raises the existing
%      singleton*.
%
%      H = MATLAB returns the handle to a new MATLAB or the handle to
%      the existing singleton*.
%
%      MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLAB.M with the given input arguments.
%
%      MATLAB('Property','Value',...) creates a new MATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matlab

% Last Modified by GUIDE v2.5 13-Mar-2019 18:16:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @matlab_OutputFcn, ...
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


% --- Executes just before matlab is made visible.
function matlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matlab (see VARARGIN)

% Choose default command line output for matlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in compressionType.
function compressionType_Callback(hObject, eventdata, handles)
% hObject    handle to compressionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns compressionType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from compressionType
path = get(handles.path, 'String');
if(~strcmp(path,''))
    type = get(handles.signalType, 'value');
    domain = get(handles.transform, 'Value');
    loss = get(handles.compressionType, 'Value');
    [c, ratio] = compress(handles.signal, type, domain, loss, handles.Size);
    set(handles.ratio, 'String', ratio);
    axes(handles.axes4);
    plot(c);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function compressionType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compressionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName] = uigetfile({'*.wav; *.mat; *.xlsx'}, 'Open');
handles.address = fullfile(pathName,fileName);
set(handles.path, 'String', handles.address);
type = get(handles.signalType, 'Value');
domain = get(handles.transform, 'Value');
loss = get(handles.compressionType, 'Value');

s=dir(handles.address);
handles.Size=s.bytes;
display(handles.Size);

handles.signal=0;
switch type
    case 1
        [handles.signal, fs] = audioread(handles.address);
    case 4
        handles.signal = xlsread(handles.address);
    case 2
        x=load(handles.address);
        handles.signal = (x.val)';
    case 3
        x=load(handles.address);
        handles.signal = x.ult_sig;
end
axes(handles.axes3);
plot(handles.signal);

[c, ratio] = compress(handles.signal, type, domain, loss, handles.Size);
set(handles.ratio, 'String', ratio);
axes(handles.axes4);
plot(c);
guidata(hObject, handles);

% --- Executes on selection change in transform.
function transform_Callback(hObject, eventdata, handles)
% hObject    handle to transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns transform contents as cell array
%        contents{get(hObject,'Value')} returns selected item from transform
path = get(handles.path, 'String');
if(~strcmp(path,''))
    type = get(handles.signalType, 'value');
    domain = get(handles.transform, 'Value');
    loss = get(handles.compressionType, 'Value');
    [c, ratio] = compress(handles.signal, type, domain, loss, handles.Size);
    set(handles.ratio, 'String', ratio);
    axes(handles.axes4);
    plot(c);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function transform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratio as text
%        str2double(get(hObject,'String')) returns contents of ratio as a double


% --- Executes during object creation, after setting all properties.
function ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in signalType.
function signalType_Callback(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalType
path = get(handles.path, 'String');
if(~strcmp(path,''))
    type = get(handles.signalType, 'value');
    domain = get(handles.transform, 'Value');
    loss = get(handles.compressionType, 'Value');
    [c, ratio] = compress(handles.signal, type, domain, loss, handles.Size);
    set(handles.ratio, 'String', ratio);
    axes(handles.axes4);
    plot(c);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function signalType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
