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

ndata = str2double(deblank(cellstr(char(fread(fid,8))'))) # Number of data records "-1" if
                                      # unknown

dur = str2double(deblank(cellstr(char(fread(fid,8))'))) # Duration of a data record, in
                                   # seconds

N = str2double(deblank(cellstr(char(fread(fid,4))'))) # Number of channels (N) in data
                                                 # record

chnl = cellstr(char(fread(fid,N*16))'); # Labels of the channels

ttype = cellstr(char(fread(fid,N*80))'); # Transducer type

pdim = cellstr(char(fread(fid,N*8))'); # Physical dimension of
                                        # channels

pmin = cellstr(char(fread(fid,N*8))'); # Physical minimum in units of
                                        # physical dimension

pmax = cellstr(char(fread(fid,N*8))'); # Physical maximum in units of
                                       # physical dimension

dmin = cellstr(char(fread(fid,N*8))'); # Digital minimum

dmax = cellstr(char(fread(fid,N*8))'); # Digital maximum

prefilter = cellstr(char(fread(fid,N*80))'); # Prefiltering

cellstr(char(fread(fid,(N-1)*8'))'); # Number of samples in each
          # data record (Sample-rate if Duration of data record = "1")

nsamp = str2double(deblank(char(fread(fid,8'))'))

reserved = cellstr(char(fread(fid,N*32))'); # Reserved

data = fread(fid,[dur*nsamp,N])';
