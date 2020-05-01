function varargout = comparison(varargin)
% COMPARISON M-file for comparison.fig
%      COMPARISON, by itself, creates a new COMPARISON or raises the existing
%      singleton*.
%
%      H = COMPARISON returns the handle to a new COMPARISON or the handle to
%      the existing singleton*.
%
%      COMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARISON.M with the given input arguments.
%
%      COMPARISON('Property','Value',...) creates a new COMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comparison

% Last Modified by GUIDE v2.5 03-Mar-2015 22:39:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comparison_OpeningFcn, ...
                   'gui_OutputFcn',  @comparison_OutputFcn, ...
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


% --- Executes just before comparison is made visible.
function comparison_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comparison (see VARARGIN)

% Choose default command line output for comparison
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comparison_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CaptureImage.
function CaptureImage_Callback(hObject, eventdata, handles)
% hObject    handle to CaptureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=videoinput('winvideo',1);
obj.ReturnedColorspace = 'rgb';

A=getsnapshot(obj);
axes(handles.axes1);
imshow(A);
imwrite(A,'A.jpg');
delete(obj);


% --- Executes on button press in StartComparison.
function StartComparison_Callback(hObject, eventdata, handles)
% hObject    handle to StartComparison (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global go;
    go = true;
  while go

obj=videoinput('winvideo',1);
obj.ReturnedColorspace = 'rgb';
B=getsnapshot(obj);
axes(handles.axes2);
imshow(B);
imwrite(B,'B.jpg');
delete(obj);

global I1;
global I2;

I1 = imread('A.jpg');
I2 = imread('B.jpg');
%  convert images to type double (range from from 0 to 1 instead of from 0 to 255)
Imaged1 = im2double(I1);
Imaged2 = im2double(I2);

% reduce three channel [ RGB ]  to one channel [ grayscale ]
Imageg1 = rgb2gray(Imaged1); 
Imageg2 = rgb2gray(Imaged2);  

% Calculate the Normalized Histogram of Image 1 and Image 2
hn1 = imhist(Imageg1)./numel(Imageg1); 
hn2 = imhist(Imageg2)./numel(Imageg2); 

% Calculate the histogram error/ Difference
f1 = sum((hn1 - hn2).^2);  
%set(handles.text1,'String',f1)
serialOne=serial('COM1', 'BaudRate', 9600);
fopen(serialOne);
if f1 > 0.009
    fprintf(serialOne,'a');
    set(handles.text1,'String','Change Detected')
    go = false;
end
if f1 < 0.009
    fprintf(serialOne,'b');
    set(handles.text1,'String','No change')
   
end
fclose(serialOne);

                      
  
  end

function StopComparison_Callback(hObject, eventdata, handles)
close all;
