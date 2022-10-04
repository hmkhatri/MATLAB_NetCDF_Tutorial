
% -------------------------------------- 
% Specify path for the data file and display its contents
% -------------------------------------- 

data_file = "../Data_SST.nc";

% ncdisp(data_file)  % displays all information about the data
% ncinfo(data_file)

% -------------------------------------- 
% Read data
% -------------------------------------- 

% vardata = ncread(source,varname)

% lat = ncread(data_file, 'lat'); % use disp(lat) in command window to see values
% lon = ncread(data_file, 'lon');
% time = ncread(data_file, 'time'); % try this datestr(time)
% 
% sst = ncread(data_file, 'sst');
% 
% sst(sst < -10000) = NaN; % convert missing values to nan

% vardata = ncread(source,varname,start,count,stride)

% startLoc = [1 1 1]; 
% count  = [length(lon) length(lat) 100]; 
% stride = [1 1 12];  
% sst_subset = ncread(data_file, 'sst',startLoc,count,stride);

% -------------------------------------- 
% Write data
% -------------------------------------- 

% sst_mean = mean(sst_subset, 3);
% 
% nccreate("Data_write.nc","SST_mean","Dimensions",{"lon",length(lon),"lat",length(lat)},"Datatype","double");
% 
% ncwrite("Data_write.nc","SST_mean", sst_mean);
% ncwriteatt("Data_write.nc","SST_mean","Units","°​C");
% 
% ncdisp("Data_write.nc")
