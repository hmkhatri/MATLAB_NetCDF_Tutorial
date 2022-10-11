
% -------------------------------------- 
% Read netcdf data 
% -------------------------------------- 

data_file = "../Data_SST.nc";

lat = ncread(data_file, 'lat'); % use disp(lat) in command window to see values
lon = ncread(data_file, 'lon');
time = ncread(data_file, 'time'); % try this datestr(time)

sst = ncread(data_file, 'sst');

sst(sst < -10000) = NaN;

% ----------------------------------
% Line Plot
% ----------------------------------

% figure(1)
% tmp1 = sst(100, :, 1);
% plot(lat, tmp1, LineWidth=3, LineStyle="-")
% tmp1 = sst(110, :, 1);
% hold on
% plot(lat, tmp1, LineWidth=3, LineStyle="-.")
% grid('on')
% xlabel('Latitude', FontSize=14);
% ylabel('Sea Surface Temperature (deg C)', FontSize=14)

% -----------------------------------
% Contour Plot
% -----------------------------------

% ---------------
figure(2)
tmp = sst(:,:,100)';
contourf(lon, lat, tmp, 20) %, 'LineStyle','none')
clim([-2 30]); c=colorbar();
title('Sea Surface Temperature (deg C)');
xlabel('Longitude');
ylabel('Latitude');

% ---------------
% figure(3)
% subplot(1,2,1)
% contourf(lon, lat, tmp, 20)
% clim([-2 30]); c=colorbar();
% title('Contourf');
% xlabel('Longitude');
% ylabel('Latitude');
% 
% subplot(1,2,2)
% s = pcolor(lon, lat, tmp);
% clim([-2 30]); c=colorbar(); %s.FaceColor = 'interp';
% set(s,'edgecolor','none')
% title('Pcolor');
% xlabel('Longitude');
% ylabel('Latitude');


% ------------------------
% m-map plot
% ------------------------

% addpath ../m_map/;
% 
% tmp = sst(:,:,100)';
% [LG,LT]=meshgrid(lon,lat);
% 
% figure(4)
% m_proj('robinson','lon',[0 360]);
% m_pcolor(LG, LT, tmp);
% m_coast('patch',[.7 .7 .7],'edgecolor','none');
% m_grid('tickdir','out','linewi',2);
% 
% h=colorbar('northoutside');
% title(h,'SST (Deg C)','fontsize',14);
% set(h,'pos',get(h,'pos')+[.2 .10 -0.4 0.0],'tickdir','out')
% set(gcf,'color','w');
% 
% figure(5)
% m_proj('ortho','lat',48','long',-123');
% m_pcolor(LG, LT, tmp);
% m_coast('patch',[.7 .7 .7],'edgecolor','none');
% m_grid('tickdir','out','linewi',2);
% 
% h=colorbar('eastoutside');
% title(h,'SST (Deg C)','fontsize',14);
% set(gcf,'color','w');