function varargout = PointDetection(varargin)
% POINTDETECTION MATLAB code for PointDetection.fig
%      POINTDETECTION, by itself, creates a new POINTDETECTION or raises the existing
%      singleton*.
%
%      H = POINTDETECTION returns the handle to a new POINTDETECTION or the handle to
%      the existing singleton*.
%
%      POINTDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINTDETECTION.M with the given input arguments.
%
%      POINTDETECTION('Property','Value',...) creates a new POINTDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PointDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PointDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PointDetection

% Last Modified by GUIDE v2.5 08-Aug-2017 16:05:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PointDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @PointDetection_OutputFcn, ...
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


% --- Executes just before PointDetection is made visible.
function PointDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PointDetection (see VARARGIN)
clc
% Choose default command line output for PointDetection
handles.output = hObject;
set(hObject,'toolbar','figure') %get toolbar 
% set default pic
axis(handles.axes_showfile); 
default_img = imread('default_img.png');
imshow(default_img);

%initial matrix values
handles.coordinates = [];
handles.markers = [];
handles.img = [];
handles.autoplot = [];
handles.autopoints = [];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PointDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PointDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_loadfile.
function pb_loadfile_Callback(hObject, eventdata, handles) % loads file for analyzing
%get file
 [pathname,dirname] = uigetfile();
 img = imread(fullfile(dirname, pathname));
 handles.img = img;
 
 axis(handles.axes_showfile);
 imshow(img)
 
 guidata(hObject, handles);
% hObject    handle to pb_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_clearfile.
function pb_clearfile_Callback(hObject, eventdata, handles)
cla (handles.axes_showfile, 'reset');
axis(handles.axes_showfile); 
default_img = imread('default_img.png');
imshow(default_img);

% hObject    handle to pb_clearfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
%get current point 
cp = get(gca,'CurrentPoint');
cp = cp(1,1:2)';

coords = handles.coordinates;
if isempty(coords)
% save points in matrix 'coordinates'
cps = [coords  cp];
handles.coordinates = cps; 
axis(handles.axes_showfile);
hold on
m = plot(cp(1), cp(2) ,'r.','MarkerSize',20); % set red markerpoints
hold off
% save markerpoints in matrix 'm'
 m = [handles.markers m];
handles.markers = m;  
else
    if coords(:,end) ~= cp
     cps = [coords  cp];
     handles.coordinates = cps;     
     %plot red markerpoints
     axis(handles.axes_showfile);
     hold on
     m = plot(cp(1), cp(2) ,'r.','MarkerSize',20); % set red markerpoints
     hold off
     % save markerpoints in matrix 'm'
     m = [handles.markers m];
     handles.markers = m;    
     else
     cps = coords;
     handles.coordinates = cps;  
    end
end

%put data in uitable
set(handles.lastelements, 'Data', cps')

guidata(hObject , handles);
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_delete.
function pb_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cps = handles.coordinates;
if isempty(cps)
else
cps(:,end) = [];
m = handles.markers;
delete(m(end));
m(end) = [];
handles.coordinates = cps;
handles.markers = m;
set(handles.lastelements,'Data',cps')
guidata(hObject , handles);
end

% --- Executes on button press in pb_deleteall.
function pb_deleteall_Callback(hObject, eventdata, handles)
choice = questdlg('Are you sure?','Warning','Yes', 'Cancel','Cancel');

switch choice 
    case 'Yes'
    handles.coordinates = [];
    m = handles.markers;
    delete(m);
    handles.markers = [];
    set(handles.lastelements,'Data',[])
    guidata(hObject , handles);
    autoplot = handles.autoplot;
    delete(autoplot);
    handles.autoplot = [];
    case 'Cancel'
end


% hObject    handle to pb_deleteall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_savecoordinates.
function pb_savecoordinates_Callback(hObject, eventdata, handles)

coordinates = handles.coordinates;
coordinates = [coordinates; ones(1, size(coordinates,2))];
uisave('coordinates', 'data')

% hObject    handle to pb_savecoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_autodetection.
function pb_autodetection_Callback(hObject, eventdata, handles)
progress = 0;


img = handles.img;
if isempty(img)
    errordlg('Please load file!','FILE ERROR')
else
    graytone = get(handles.edit_graytone,'String');
    graytone = str2num(graytone);
    if isempty(graytone)
        errordlg('Please set marker gray value!','FILE ERROR')
    else    

        autopoints = autodetect(img, graytone, handles);    
        axis(handles.axes_showfile);
        hold on
        autoplot = plot(autopoints(1,:), autopoints(2,:), 'r+');
        hold off
        autoplot = [autoplot handles.autoplot];
        handles.autoplot = autoplot;
        handles.autopoints = autopoints;
        guidata(hObject , handles);
    end
end

% hObject    handle to pb_autodetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit_graytone_Callback(hObject, ~, handles)
% hObject    handle to edit_graytone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_graytone as text
%        str2double(get(hObject,'String')) returns contents of edit_graytone as a double


% --- Executes during object creation, after setting all properties.
function edit_graytone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_graytone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_grayscaled.
function pb_grayscaled_Callback(hObject, eventdata, handles)
% hObject    handle to pb_grayscaled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles. img;
if isempty(img)
    errordlg('Please load file!','FILE ERROR')
else 
     if sum(size(size(img)))== 4
    img = rgb2gray(img);
    axis(handles.axes_showfile); 
    hold on
    imshow(img)
    hold off
     else 
     end
end



function edit_mintolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mintolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mintolerance as text
%        str2double(get(hObject,'String')) returns contents of edit_mintolerance as a double


% --- Executes during object creation, after setting all properties.
function edit_mintolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mintolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxtolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxtolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxtolerance as text
%        str2double(get(hObject,'String')) returns contents of edit_maxtolerance as a double


% --- Executes during object creation, after setting all properties.
function edit_maxtolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxtolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_markersize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_markersize as text
%        str2double(get(hObject,'String')) returns contents of edit_markersize as a double


% --- Executes during object creation, after setting all properties.
function edit_markersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_confirm.
function pb_confirm_Callback(hObject, eventdata, handles)

autopoints = handles.autopoints;
if isempty(autopoints)
    errordlg('Please click autodetection first!', 'DETECTION ERROR')
else
img = handles.img;
axis(handles.axes_showfile);
hold on
imshow(img)
        autoplot = plot(autopoints(1,:), autopoints(2,:), 'r+');
        hold off
        autoplot = [autoplot handles.autoplot];
        handles.autoplot = autoplot;
        handles.autopoints = autopoints;
        guidata(hObject , handles);
end
% hObject    handle to pb_confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pv_saveautocoordinates.
function pv_saveautocoordinates_Callback(hObject, eventdata, handles)

autopoints = handles.autopoints;
uisave('autopoints', 'data')




% hObject    handle to pv_saveautocoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
