clear;clc;close all;
%We will plot maps of future warming projected from one of the latest 
%generation Earth System Models (the Norwegian: NorESM2 model)

%% Read netcdf data  
% -------------------------------------- 
% load the first 10 years in the pre-industrial, years:1850-1860
data_file_d1 = "../tos_Omon_NorESM2-LM_historical_r1i1p1f1_gn_185001-185912.nc";
ncdisp(data_file_d1) % will print what is inside the files (e.g. all the variables + information)

lat = ncread(data_file_d1, 'latitude'); 
lon = ncread(data_file_d1, 'longitude');
time_d1 = ncread(data_file_d1, 'time'); 

SST_1850_1860=ncread(data_file_d1, 'tos'); %this will load sst in the pre-industrial decade 1850-1860
%check out what is printed in the window:
size(SST_1850_1860)
%this tells you your data have: 
%360 x 385 points in the longitude x latitude
% and 120 time records =10 years *12 months

% load the sst at the last decade of the century, years:2090-2100
data_file_d100 = "../tos_Omon_NorESM2-LM_ssp585_r1i1p1f1_gn_209101-210012.nc";
SST_2090_2100=ncread(data_file_d100, 'tos');
time_d2 = ncread(data_file_d100, 'time'); 

%% estimate the warming that is projected to occur in the last decade of the century:
%------------------------------------------
SST_preind=mean(SST_1850_1860,3,'omitnan');% maps of average decadal sst during the pre-industial
%the '3': takes the mean in the 3rd dimention, so in time
%'omitnan': to avoid problems with the
% model having "not a number" where there is land

SST_futur=mean(SST_2090_2100,3,'omitnan');% maps of average decadal sst in the future 2090-2100

SST_anomaly=SST_futur-SST_preind;%this is the warming of the ocean surface at the end
% of the century relative to the pre-industrial (i.e., the sst anomaly)

%% plot the map of the anomaly 
figure(1);
pcolor(lon, lat, SST_anomaly);shading flat;colormap('jet');colorbar('southoutside');
title('SST anomaly (Deg C)');
ylabel('latitude')
xlabel('longitude')
set(gca,'color', [0.4 0.4 0.4],'FontSize',12);
set(gcf,'color','w');
%!!! AAAAH this looks horrible what did I do wrong you may ask????
% Nothing: the model is in a weird grid, sometimes you will encounter that
% some of the models have on puprose weird grids in the ocean to avoid 
% problems with the north pole or other reasons.

%% Solution for visualising/ploting weird grids: Interpolation 
%create your own grid of latitudes longitudes (with a 1 degree intervals)
my_lon=1:360;
my_lat=-90:90;
[LG,LT]=meshgrid(my_lon,my_lat);

%interpolate to your own-standard grid
SST_anomaly_int=griddata(lon,lat,SST_anomaly,LG,LT,'linear');

%try plotting it now
figure(2);
pcolor(LG, LT, SST_anomaly_int);shading flat;colormap('jet');colorbar('southoutside');
title('SST anomaly (Deg C)');
ylabel('latitude')
xlabel('longitude')
set(gca,'color', [0.4 0.4 0.4],'FontSize',12);
set(gcf,'color','w');
% wow! yes it looks much better!!!

%% final nice plot using the m_map tool + new colormap
addpath ../m_map/;
addpath ../brewermap/;% your new colormap, awesome for anomalies

figure(3)
m_proj('robinson','lon',[0 360]);
m_pcolor(LG, LT, SST_anomaly_int);
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('tickdir','out','linewi',2);
colorbar('southoutside');
title('SST anomaly (Deg C)','fontsize',14);
set(gcf,'color','w');
clim([-5 5])
colormap(brewermap([],'*RdBu'));%this is our new colormap

% try typing in your command window: brewermap_view 
%this will show you a selection of colormaps that you can choose from
% simply find the one you like and use it in colormap(brewermap([],'I_LIKE_THIS'));
% NOTE!! the * before e.g., RdBu, will simply flip the colorbar try adding it and see what will happen:
figure(4)
m_proj('robinson','lon',[0 360]);
m_pcolor(LG, LT, SST_anomaly_int);
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('tickdir','out','linewi',2);
colorbar('southoutside');
title('SST anomaly (Deg C)','fontsize',14);
set(gcf,'color','w');
clim([-5 5])
colormap(brewermap([],'PuBuGn'));%try instead '*PuBuGn' and see what happens




