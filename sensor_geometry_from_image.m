% Get sensor geometry for comsol and matlab

ifile = '/home/crowell/Nextcloud/data/turbulent-mixing/IMG_20180402_180656.jpg';

im = imread(ifile);

figure('Position', [100 100 1200 800])
imagesc(im)
axis equal

origin_scale_flag = false;
pick_sensors = false;

w_gap = 1.5; % cm
scale_ends = [1 7];
scale0 = diff(scale_ends);

if origin_scale_flag
%     zoom(3)
    
    
%     axis([1200 1900 700 1200])
    fprintf('Scale: pick scale bar ends at %i and %i cm',scale_ends(1), scale_ends(2))
    [scale,~] = ginput(2);
    scale = scale0/abs(scale(2)-scale(1)); % cm/px
%     zoom out
    save('sensor_geometry','scale')
else
    load('sensor_geometry','scale')
end

if pick_sensors
    button = 1;
    disp('Picking sensors, press space to quit.')
%     zoom(2.5)
    
    X = [];
    Y = [];
    while button~=32
        [x,y,button] = ginput(1);
        if button ~=32
            X = [X;x];
            Y = [Y;y];
        end
    end
    save('sensor_geometry','X','Y','-append')
else
    load('sensor_geometry','X','Y')
end

% Set middle sensor (5) to origin for now, rotate
Xn = Y-Y(3);
Yn = X-X(3);

% Normalize X and Y locations to grid gap thickness
Xn = Xn*scale/w_gap;
Yn = Yn*scale/w_gap;

% Compiled sensor numbers and locations matrix
SS = [[3;4;5;6;7] Xn Yn];

figure
scatter(Xn,Yn,'o')
axis equal

