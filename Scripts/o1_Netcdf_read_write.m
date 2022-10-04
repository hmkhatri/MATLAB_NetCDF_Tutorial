
% -------------------------------------- 
% Specify path for the data file and display its contents

data_file = "../sst.mnmean.v4.nc"; %Data_SST.nc";

% ncdisp(data_file)  % displays all information about the data
% ncinfo(data_file)

% -------------------------------------- 
% Read data

lat = ncread(data_file, 'lat');
lon = ncread(data_file, 'lon');
time = ncread(data_file, 'time');

% use disp(lat) in command window to see values
% try this datestr(time)

sst = ncread(data_file, 'sst');

sst(sst < -10000) = NaN;