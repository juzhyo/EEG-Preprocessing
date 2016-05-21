clear all, close all
addpath('/home/justin/EEG/data/Multi-modal Face Dataset/EEG');
addpath('/home/justin/EEG/functions');

graphics_toolkit('gnuplot')

fid = fopen('faces_run1.bdf');

fseek(fid, 0, 'bof');
## Check if file if 24-bit BDF or 16-bit EDF format
byte1 = fread(fid,1);

if byte1 = 255
  disp('24 bit BDF format.')
elseif byte1 = 0
  disp('16 bit EDF format.')
else
  disp('ERROR: Unrecognized file format.')
end

fseek(fid, 1, 'bof');
id = cellstr(char(fread(fid,7))') # Identification code

lsi = cellstr(char(fread(fid,80))') # Local subject identification

lri = cellstr(char(fread(fid,80))') # Local recording identification

sd = cellstr(char(fread(fid,8))') # Startdate of recording

st = cellstr(char(fread(fid,8))') # Starttime of recording

nobytes = str2double(deblank(cellstr(char(fread(fid,8))'))) # Number of bytes in header
                                       # record

ver = cellstr(char(fread(fid,44))') # Version of data format

nodata = str2double(deblank(cellstr(char(fread(fid,8))'))) # Number of data records "-1" if
                                      # unknown

dur = str2double(deblank(cellstr(char(fread(fid,8))'))) # Duration of a data record, in
                                   # seconds

N = str2double(deblank(cellstr(char(fread(fid,4))'))) # Number of channels (N) in data
                                                 # record

chnl = cellstr(char(fread(fid,N*16))'); # Labels of the channels


