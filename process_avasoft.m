% Sample driver to load an avasoft text file
clear all; close all

% Data directory: CHANGE THIS!
% datadir  = '~/Nextcloud/data/turbulent-mixing/avasoft/4.02.2018/run2_mixedblue';
datadir  = '~/Nextcloud/data/turbulent-mixing/avasoft/4-02-2018/run1_hit7withblue/';
% ifile    = 'run2_mixedblue/';
plot_opt = 'full'; %'full';  % 'tavg', []

% ifiles    = {'red_dye/fresh/fresh_1602173U5.txt'};
% ifiles  = {'73_1602173U5.TXT',  '74_1602174U5.TXT'};
% ifiles = {'3_1602173U5.TXT',  '5_1602175U5.TXT',  '7_1602177U5.TXT',  '4_1602174U5.TXT',  '6_1602176U5.TXT'};
% filelist  = {'1602173U5.str8', '1602174U5.str8', '1602175U5.str8', '1602176U5.str8' , '1602177U5.str8'};

% Wavelength(s) - choose a single number, a range [min max], or empty []
lambda_pick = [450 700]; %640;
ref_band    = [800 1000]; % Use this band to normalize to


%%

% Automatically pulls txt files
ifiles = dir(fullfile(datadir,'*.TXT'));
name = split(datadir,'/');
name = name(end-1);
% ifiles = ifiles(5);

figure(1)
hold on
for i = 1:numel(ifiles)
    dat(i) = read_avasoft(fullfile(datadir,ifiles(i).name),plot_opt);

    if numel(lambda_pick)==1
        [lamda,ix] = closest(lambda_pick,dat(i).lambda);
        amp = dat(i).units;
        I = dat(i).I(ix,:);
        laml = sprintf('%.1f nm',lambda);
    elseif numel(lambda_pick)==2
        ix   = find(and(dat(i).lambda>min(lambda_pick),dat(i).lambda<max(lambda_pick)));
        iref = find(and(dat(i).lambda>min(ref_band),dat(i).lambda<max(ref_band)));
        lambda = dat(i).lambda(ix);
        lam_ref = dat(i).lambda(iref);
        amp = '"Power"';
        I = dat(i).I(ix,:);
        R = dat(i).I(iref,:);
%         figure
%         surf(dat(i).t,lambda,I,'EdgeAlpha',0.05)
        % Calc total power in this band
        I = trapz(lambda,I,1);
        R = trapz(lam_ref,R,1);
        laml = sprintf('%.1f - %.1f nm',min(lambda),max(lambda));
    elseif ~isempty(lambda_pick)
        error('Can''t process wavelength selection')
    end

    % Normalize - just flat for now
    % Ref's/Darks are fucked, normalize to initial value for now
    I = I./repmat(I(:,1),[1 size(I,2)]);
    
    figure(1)
    plot(dat(i).t,I,'linewidth',2)
%     plot(dat(i).t,dat(i).I(ix,:),'linewidth',2)
    xlabel('time?')
    ylabel(sprintf('Normalized %s',amp))
    title(sprintf('%s: %s',name,laml))
    legend(dat.spectrometer,'Location','SouthEast')
end

% Pull specific wavelength(s)?
% Normalize amplitudes?