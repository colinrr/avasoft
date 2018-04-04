% Sample driver to load an avasoft text file
clear all; close all

% Data directory: CHANGE THIS!
% datadir  = '~/Nextcloud/data/turbulent-mixing/avasoft/4.02.2018/run2_mixedblue';
datadir  = '~/Nextcloud/data/turbulent-mixing/avasoft/4-02-2018/run1_hit7withblue/';
% ifile    = 'run2_mixedblue/';
plot_opt = []; %'full';  % 'tavg', []

% ifiles    = {'red_dye/fresh/fresh_1602173U5.txt'};
% ifiles  = {'73_1602173U5.TXT',  '74_1602174U5.TXT'};
ifiles = {'3_1602173U5.TXT',  '5_1602175U5.TXT',  '7_1602177U5.TXT',  '4_1602174U5.TXT',  '6_1602176U5.TXT'};
% filelist  = {'1602173U5.str8', '1602174U5.str8', '1602175U5.str8', '1602176U5.str8' , '1602177U5.str8'};

% Wavelength(s)
lambda_pick = 640;


%%
figure
hold on
for i = 1:numel(ifiles)
    dat(i) = read_avasoft(fullfile(datadir,ifiles{i}),plot_opt);
    
    [lamda,ix] = closest(lambda_pick,dat(i).lambda);

    % Normalize - just flat for now
    dat(i).I = dat(i).I./repmat(dat(i).ref,[1 size(dat(i).I,2)]);
    
    plot(dat(i).t,dat(i).I(ix,:),'linewidth',2)
end

% Pull specific wavelength(s)?
% Normalize amplitudes?