function[dat] = read_avasoft(file,plot_opt)
% Function to read in avasoft text files
%  INPUT:   file     = full path to file or local file name
%           plot_opt = OPTIONAL input to plot data: 
%                          'full' = plot surface (lambda vs t vs amplitude)
%                          'tavg'  = plots the time-averaged signal for
%                                   calibration runs
%
%  OUTPUT:  dat = structure with various data fields...
%                   I       = amplitude matrix
%                   t       = time vector
%                   lamda   = wavelength vector
%                   other fields = stored meta data from text file
%
% C Rowell, Mar 2018
%
% clear all; close all
% test file
% file = '/home/crowell/Nextcloud/data/turbulent-mixing/avasoft/dye_concentrations/red_dye/red10/red10_1602173U5.txt';

if nargin<2
   plot_opt = [];  
end

% fid = fopen(file);
% C = textscan(fid,'%f','Delimiter',';','HeaderLines',skipn);

A = importdata(file,';');

% Parse meta data'
met = A.textdata(:,1:3);
% headers = char('Run','dt','t_unit','n_steps','n_smooth','spectromter','mode','Units');
% str = textscan(met{1,1},'%s','Delimiter',':'); dat.run = str{1}{1};                    % experiment name
% str = textscan(met{2,1},'%s','Delimiter',':'); dat.t_int = str2double(str{1}{2});      % integration time
% str2 = strsplit(str{1}{1},' ') ;               dat.t_unit = str2{3};                    % time step units
% str = textscan(met{3,1},'%s','Delimiter',':'); dat.n_steps = str2num(str{1}{2});       % number of time steps
% str = textscan(met{4,1},'%s','Delimiter',':'); dat.n_smooth = str2num(str{1}{2});      % number of smoothed pixels
% str = textscan(met{5,1},'%s','Delimiter',':'); dat.spectrometer = str{1}{2};           % spectrometer name
% str = textscan(met{6,1},'%s','Delimiter',':'); dat.mode = str{1}{2};                   % measurement mode
% str = textscan(met{7,1},'%s','Delimiter',':'); dat.units = str{1}{2};                  % Intensity units
% 'red dye, [0.10]'
%     'Integration time [ms]:   4.122'
%     'Nr. of StoreToRam scans: 126'
%     'Smoothing Nr. [pixels]: 0'
%     'Data measured with spectrometer [name]: 1602173U5'
%     'Measurement mode: Scope'
%     'Units: [counts]'
%     'Wave   ;Dark     ;Reference;Samples'
%     '[nm]   '
dat.comment = {};
for i = 1:size(met,1)
    str = textscan(met{i,1},'%s','Delimiter',':');
    if strfind(str{1}{1},'Integration time')
        dat.t_int = str2double(str{1}{2});                              % integration time
        str2 = strsplit(str{1}{1},' ') ;   dat.t_unit = str2{3};        % time step units
    elseif strfind(str{1}{1},'Nr. of StoreToRam scans')
        dat.n_steps = str2num(str{1}{2});                               % number of time steps
    elseif strfind(str{1}{1},'Smoothing Nr.')
        dat.n_smooth = str2num(str{1}{2});                              % number of smoothed pixels
    elseif strfind(str{1}{1},'Data measured with spectrometer')
        dat.spectrometer = str{1}{2};                                   % spectrometer name
    elseif strfind(str{1}{1},'Measurement mode')
        dat.mode = str{1}{2};                                           % measurement mode
    elseif strfind(str{1}{1},'Units')
        dat.units = str{1}{2};                                          % Intensity units
    elseif isempty(strfind(str{1}{1},'Wave')) && isempty(strfind(str{1}{1},'[nm]'))
        dat.comment{numel(dat.comment)+1} = str{1}{1};                  % experiment name
    end
end
% Get data matrix and vectors - there is some uncertainty as to whether I
% did this right...
% dat.t = 0:dat.t_int:dat.t_int*(dat.n_steps-1);
dat.t        = A.data(1,5:end);
dat.lambda   = A.data(2:end,1);
dat.I        = A.data(2:end,5:end);  % CURRENTLY SKIPPING FIRST MEASUREMENT BECAUSE FIRST TIME IS FUCKED/CONFUSING
dat.n_lambda = size(dat,1);                                                         % number wavelength samples

% Quick check
if size(dat.I,2)~=numel(dat.t); %dat.n_steps
    error('Data and time vectors do not match in size! Ya dun broke sumthin...')
end

% Reference wavelengths
dat.dark = A.data(2:end,2);
dat.ref  = A.data(2:end,3);

% Optional plot(s)?
if ~isempty(plot_opt)
    figure
    if strcmp(plot_opt,'full')
        surf(dat.t,dat.lambda,dat.I,'EdgeAlpha',0.05)
        xlabel(sprintf('t %s',dat.t_unit))
        ylabel(sprintf('%s %s','\lambda',A.colheaders{1}))
        zlabel(sprintf('%s %s',dat.mode,dat.units))
        title(sprintf('%s: 3D spectrum',dat.spectrometer))
    elseif strcmp(plot_opt,'tavg')
        plot(dat.lambda,dat.dark,'--k','linewidth',2)
        hold on
        plot(dat.lambda,dat.ref,'color',[0.4 0.4 0.4])
        plot(dat.lambda,mean(dat.I,2))
        xlabel(sprintf('%s [nm]','\lambda'))
        ylabel(sprintf('%s %s',dat.mode,dat.units))
        title(sprintf('%s: Time-averaged amplitude',dat.spectrometer))
        legend('Dark','Ref','Run')
        hold off
    else
        disp('Plot option not recognized, plotting skipped.')
    end
end


