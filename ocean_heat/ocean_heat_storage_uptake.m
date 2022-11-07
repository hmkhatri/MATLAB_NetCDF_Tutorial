clear;clc;close all;
%!! NOTE: to upload in matlab online files from your pc go to: https://drive.matlab.com
% We will estimate the additional heat stored in two ocean regions (subpolar/North Atlantic and subtropical/South Atlantic) 
%due to climate change, and the portion of this heat that is taken/absorbed by
%this ocean region locally/directly from the atmosphere

% We will use outputs from the Canadian CMIP6 model: CanESM5
%forced by a very simplistic scenario of 1% atmospheric CO2 increase per
%year for 100 years.

% author: Anna Katavouta

%% add your paths to your m_map and colormap tools (that we used previously)
addpath ../m_map/;
addpath ../brewermap/;% your new colormap, awesome for anomalies

%% Read the data/variables from the necdf file
% choose either the S. Atlantic or the N. Atlanti region below (uncomment/comment line): 
%file='CAN-ESM5_1pctCO2_r1i1p1f1_gn_100y_SAtlantic.nc'
file='CAN-ESM5_1pctCO2_r1i1p1f1_gn_100y_NAtlantic.nc'
% to know more about what these data are type in the command window: ncdisp(file)

lon=double(ncread(file,'longitude'));
lat=double(ncread(file,'latitude'));
area_cell=double(ncread(file,'areacello'));%the area of each of the model cell (m^2)
volume_cell=double(ncread(file,'volcello'));% the volume of each of the model cell (m^3)
time=double(ncread(file,'time'))'; %time in years

DT=double(ncread(file,'Dthetao')); %the ocean temperature anomaly relatively to preindustrial at each model cell (units: oC)

Dheat_flux=double(ncread(file,'Dhfds')); %the additional heat flux (per unit area) from the atmosphere to the ocean relative to the pre-industrial at each model cell (units: W/m^2)


%% plot/checkout the region, to have an idea where we are in the world
figure(1)
m_proj('ortho','lat',25','long',340');
m_pcolor(lon, lat,  DT(:,:,1,100)); shading flat 
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('linest','-','xticklabels',[],'yticklabels',[]);
colorbar('southoutside');
title('SST anomaly year 100','fontsize',10);
set(gcf,'color','w');
%clim([0 30])
caxis([-2 4])
colormap(brewermap([],'*RdBu'));
% Interesting!!! For the North Atlantic: can you notice the blob of water that gets slightly cooler? 
% But I thought with climate change in the future it will get warmer!!!
% Well, not everywhere; remember from the last class: there are some ocean regions that get less warm than others (or even experiencing cooling)


%% Estimate the additional heat stored in the ocean region for an idealised 1% increase of atmospheric CO2 per year.

% for simplicity we will assume a constant specific heat capacity for ocean water. This is generally a good approximation:
cp=3990; % specific heat capacitiy of seawater, units: J/(kg oC)

% for simplicity we will also assume a constant density of seawater for our estimates. This is generally an ok approximation for estimating the heat content.
rho_c=1026; % background density of the seawater, units: kg/m3

% estimate the heat content anomaly (i.e. the additional heat stored in the ocean region)
Dheat_cont = rho_c * cp .* DT ; % heat content anomaly per unint volume at each of the model cell (x,y,z)

% estimate the heat content anomaly for the whole region, aka: the volume intergal for the region
%!HELPFUL ASIDE: in numerical methods intergation is approximated by summation!
for tt=1:size(Dheat_cont,4) 
    dummy=Dheat_cont(:,:,:,tt).*  volume_cell; 
    OHC_region(tt)=sum(dummy(:),1,'omitnan'); %volume intergated heat content anomaly in year tt. 
end

%!!!QUESTION!!!: In what units is this heat content anomaly: OHC_region ???? (grab your pencils if you need to)


%% Estimate the additional heat gain in our ocean region that is directly by the atmosphere

% Integrate in time the air-sea flux to get the ocean heat gain from the atmosphere, aka: the cumulative ocean heat uptake
Dt=365*24*3600 % our data are for yearly fluxes, and one year = 365*24*3600 s (note leap years are ignored in these simulations)
for tt=1:size(Dheat_flux,3)
    heat_uptake(:,:,tt)=sum(Dheat_flux(:,:,1:tt).* Dt,3,'omitnan'); 
end

% estimate the cumulative heat uptake for the whole region, aka: the area integral for the region
for tt=1:size(heat_uptake,3) 
    dummy2=heat_uptake(:,:,tt).* area_cell; 
    OHU_region(tt)=sum(dummy2(:),1,'omitnan'); % area intergated cumulative heat flux anomaly.
end

%!!!QUESTION!!!: In what units is this cumulative ocean heat uptake? !!! Note 1 W = 1 J/s


%% plot your results and let us discuss some implications
figure(2)
%subplot('Position',[0.1 0.55 0.40, 0.40])
m_proj('ortho','lat',25','long',340');
m_pcolor(lon, lat,sum(Dheat_cont(:,:,:,end).*volume_cell,3,'omitnan')); shading flat
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('linest','-','xticklabels',[],'yticklabels',[]);
colorbar('southoutside');
title('heat storage, year 100 (J)','fontsize',9);
set(gca,'color','w');
%clim([-1 1]*10^20)
caxis([-1 1]*10^20)
colormap(brewermap([],'*RdBu'));

%subplot('Position',[0.55 0.55 0.40, 0.40])
figure (3)
m_proj('ortho','lat',25','long',340');
m_pcolor(lon, lat, heat_uptake(:,:,end).*area_cell); shading flat
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('linest','-','xticklabels',[],'yticklabels',[]);
colorbar('southoutside');
title('cumulative heat uptake from the atmosphere, year 100 (J)','fontsize',6);
set(gca,'color','w');
%clim([-2 2]*10^20)
caxis([-2 2]*10^20)
colormap(brewermap([],'*RdBu'));

%subplot('Position',[0.1 0.1 0.85, 0.40])
figure(4)
plot(time,OHC_region,'k'); hold on;
plot(time,OHU_region,'r');
plot(time,OHC_region-OHU_region,'b');
legend('heat storage anomaly', 'cumulative heat upake from the atmosphere','heat transport + small portion towards ice melting/freezing');
xlabel('year relative to pre-industrial');ylabel('heat (J)')
title('Heat budget in region, 1% increase in pCO2 per year')
grid on;
set(gca,'color','w');
set(gca,'fontsize',5);
