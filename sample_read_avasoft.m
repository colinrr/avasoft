% Sample driver to load an avasoft text file
clear all; close all

% Data directory: CHANGE THIS!
datadir  = '~/Nextcloud/data/turbulent-mixing/avasoft/dye_concentrations/';
ifile    = 'red_dye/red10/red10_1602173U5.txt';
plot_opt = 'full';  % 'tavg'


%%
dat = read_avasoft(fullfile(datadir,ifile),plot_opt);