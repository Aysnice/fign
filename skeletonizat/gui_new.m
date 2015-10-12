 function varargout = gui_new(varargin)

% GUI_NEW MATLAB code for gui_new.fig
%      GUI_NEW, by itself, creates a new GUI_NEW or raises the existing
%      singleton*.
%
%      H = GUI_NEW returns the handle to a new GUI_NEW or the handle to
%      the existing singleton*.
%
%      GUI_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_NEW.M with the given input arguments.
%
%      GUI_NEW('Property','Value',...) creates a new GUI_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_new_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_new_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_new

% author Ays.G. 

% last modified 14.06.2013

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_new_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_new_OutputFcn, ...
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


% --- Executes just before gui_new is made visible.
function gui_new_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_new (see VARARGIN)

% Choose default command line output for gui_new
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_new_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_download.
function btn_open_Callback(hObject, eventdata, handles)
[FileName,PathName]  = uigetfile('*.*','Please select a file');
tst=fullfile(PathName,FileName);
set(handles.text_filename, 'String',tst);

% [path,user_cance]=imgetfile();
% if(user_cance)
%     msgbox(sprintf('Error'),'Error','Error');
%     return;
% end
global bw
bw=imread(tst);
axes(handles.axes2);
imshow(bw);

% ��������� ��������� ������ par ��������� ���� integral
guidata(hObject, handles);

%end


% --- Executes on button press in btn_start.
function btn_start_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tst = handles.test1.t; 
% %edit_number = str2number(get(handles.text_vertices, 'string'));
% edit_str = get(handles.text_vertices, 'string');
% p=get(handles.VideoAx,'Position');
% video=VideoReader(tst);
% hf = handles.VideoAx; 
% set(hf);%, 'Position', [100 100 360 640]);
% vidtofr(video,hf,p);
number_vertices = str2double(get(handles.text_vertices, 'String'));
hf = handles.axes3;
global bw
apply_algorithm( bw, hf, number_vertices );

% global resultant_image
% 
% axes(handles.axes3);
% imshow(resultant_image);

guidata(hObject,handles)


% --------------------------------------------------------------------
function MenuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to MenuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles)



function text_vertices_Callback(hObject, eventdata, handles)
% hObject    handle to text_vertices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_vertices as text
%        str2double(get(hObject,'String')) returns contents of text_vertices as a double


% --- Executes during object creation, after setting all properties.
function text_vertices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_vertices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
