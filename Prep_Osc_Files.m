
clear
close all
clc


% Get the files
[files,path] = uigetfile('*.txt',MultiSelect='on');

% Load data
curdir = cd(path);
if ischar(files) % only one file
    num_files = 1;
    file_to_load = files;
    Data = Load_Osc_Data(file_to_load);
else %multiple files
    num_files = length(files);
    for indf = 1:num_files
        file_to_load = files{indf};
        Data(indf) = Load_Osc_Data(file_to_load);
    end
end
cd(curdir);

% Plot and clean the files
for indf = 1:num_files
figure
hax1 = subplot(2,1,1); hold on
hax2 = subplot(2,1,2); hold on

for indf = 1:num_files

    cla(hax1)
    cla(hax2)

    %cart 1
    ylabel(hax1,'cart 1')
    title('Click on point and press enter')
    hPlot=plot(hax1,Data(indf).time,Data(indf).cart1,'DisplayName',[Data(indf).Astr ' C1'],...
         "ButtonDownFcn",@(src,event)displayCoordinates(src,event,hax1));
    pause % waiting for the user to click on the plot and then hit enter
    hold on
    plot(xyp(1), xyp(2),'r*') % plot the aquired point
    dist_yyp = sqrt((Data(indf).cart1-xyp(2)).^2);
    [~,ind1] = min(dist_yyp);

    %cart 2
    ylabel(hax2,'cart 2')
    title('Click on point and press enter')
    hPlot=plot(hax2,Data(indf).time,Data(indf).cart2,'DisplayName',[Data(indf).Astr ' C2'],...
        "ButtonDownFcn",@(src,event)displayCoordinates(src,event,hax2));
    pause % waiting for the user to click on the plot and then hit enter
    hold on
    plot(xyp(1), xyp(2),'r*') % plot the aquired point
    dist_yyp = sqrt((Data(indf).cart2-xyp(2)).^2);
    [~,ind2] = max(dist_yyp);

    Data(indf).numlines = max(ind1,ind2);
    % call clean_osc_files
    Data(indf).file_trim = clean_osc_files (Data(indf).filenm,Data(indf).numlines);
end


end


% define the function to put the data in base workspcae
function displayCoordinates(~,e,~)
assignin('base','xyp',e.IntersectionPoint(1:2));
end