clear all, close all
addpath('/home/justin/EEG/data/Multi-modal Face Dataset/EEG');
addpath('/home/justin/EEG/functions');

load('downsample.m')
load('montage.m')

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
id = cellstr(char(fread(fid,7))'); # Identification code

lsi = cellstr(char(fread(fid,80))'); # Local subject identification

lri = cellstr(char(fread(fid,80))'); # Local recording identification

sd = cellstr(char(fread(fid,8))'); # Startdate of recording

st = cellstr(char(fread(fid,8))'); # Starttime of recording

nbytes = str2double(deblank(cellstr(char(fread(fid,8))'))); # Number of bytes in header
                                       # record

ver = cellstr(char(fread(fid,44))'); # Version of data format

ndata = str2double(deblank(cellstr(char(fread(fid,8))'))) # Number of data records "-1" if unknown

dur = str2double(deblank(cellstr(char(fread(fid,8))'))) # Duration of a data record, in seconds

N = str2double(deblank(cellstr(char(fread(fid,4))'))) # Number of
                                # channels (N) in data record

chnl = cell(N,10);
for i = 1:N
  chnl(i,1) = char(fread(fid,16))'; # Labels of the channels
end

for i = 1:N
  chnl(i,2) = char(fread(fid,80))'; # Transducer type
end

for i = 1:N
  chnl(i,3) = char(fread(fid,8))'; # Physical dimension of channels
end

for i = 1:N
  chnl(i,4) = str2double(deblank(char(fread(fid,8))')); # Physical minimum in units of
                                   # physical dimension
end

for i = 1:N
  chnl(i,5) = str2double(deblank(char(fread(fid,8))')); # Physical maximum in units of
                                   # physical dimension
end

for i = 1:N
  chnl(i,6) = str2double(deblank(char(fread(fid,8))')); # Digital minimum
end

for i = 1:N
  chnl(i,7) = str2double(deblank(char(fread(fid,8))')); # Digital maximum
end

for i = 1:N
  chnl(i,8) = char(fread(fid,80))'; # Prefiltering
end

for i = 1:N
  chnl(i,9) = str2double(deblank(char(fread(fid,8))')); # Number of samples in each
          # data record (Sample-rate if Duration of data record = "1")
end

for i = 1:N
  chnl(i,10) = char(fread(fid,32))'; # Reserved
end

nsamp = cellfun(@times,chnl(:,9),{dur}); # Number of samples for each
                                # electrode; sample rate x duration

data = fread(fid,[nsamp(i),N])';

## Downsampling of data
down_rate = 200;
data = downsample(data,nsamp,down_rate);

## Creating montage and calculating HEOG & VEOG
[data,heog,veog] = montage(data);

## Plotting the EEG before artifact removal
[m, n] = size(data);           # m = no. of electrodes, n = no. of
                               # samples

## Calculating the shifts for plotting
min_data = min(flipud(data),[],2); # flipud() used to position 1st
                                     # row at the top of the graph
max_data = max(flipud(data),[],2);
shift = flipud(cumsum([0;abs(max_data(1:end-1))+abs(min_data(2:end))]));
shifted_data = data+shift;    # baseline plot with 1st row
                              # at the top

## Defining y tick labels
electrodes = chnl(1:128,1);
set(gca,'ytick',mean(shifted_data,2),'yticklabel',electrodes);
title('EEG')
xlabel('Time(s)') % x-axis label
ylabel('Channels') % y-axis label

## Plotting the graph
period = 1/down_rate;
t = linspace(0,dur,n);
length(t)
hold on
for row = 1:m
  plot(t,shifted_data(row,:));
end
hold off



## data = fread(fid,[dur*nsamp,N])';

fclose(fid);
