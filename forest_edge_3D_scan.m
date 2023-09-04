%% This script needs access to raw data "vegetation_scan_night_45_30"
% The data was aquired with the Fluorescence Hyperspectral lidar
% the lidar is continuosly moving in a pattern:
% 1. horizontal right motion, contrinually aquiring data.
% 2. it then takes a step 1 degree vertically upwards. not recording data.
% 3. horizontal left motion, contrinually aquiring data.
% 4. it then takes a step 1 degree vertically upwards. not recording data.
%  Then repeats from 1-4
%
% Each aqcuisition records a full spectrum at each range.
% This code creates a struct for each measurement file. and puts those structs in a matrix 
% The structs contain the mean spectra, the mean horizontal position represented by the file.
% and the horizontal position. It also takes the mean intesity in some spectral windows, 
% and the range of the max signal. 
%
% The data is then visualized with a RGB point cloud based on the positions calculated by known angles and range
% In this code only the left to right scanning sweeps are utilized, hence vertical resolution can easily be improved by a factor of 2
% the horizontal resolution can be improved 25 times, since each file contains 25 recordings which are in this code averaged
% 
% Author: Hampus Manefjord 2023
% Licence: CC BY 2.0 https://creativecommons.org/licenses/by/2.0/
% You are free to:
% Share and copy and redistribute the material in any medium or format
% Adapt and remix, transform, and build upon the material for any purpose, even commercially.
% Under the following terms:
% Attribution - You must give appropriate credit, provide a link to the license, and indicate if changes were made.

load('range_FHSL_stensoffa')
load('la.mat');
fn='D:\scan_15_8\vegetation_scan_night_45_30\';
range_vector = interp1(1:length(range_vector),range_vector,1:0.5:length(range_vector))
swipe_angle = 45;

for vert_i = 0:30
    sweep_name = ['hor_0-45_vert_' num2str(vert_i) ',0.FSHLecho'];
    files = dir([[fn] ['*' sweep_name]]);
    deg_per_file = swipe_angle/(length(files)-1);
    plot_on=0;
    for i=1:length(files)
        [data, range_pixels, spect_pixels,nbr_images] = read_FHSL_file(files(i));
        data_range_spectra=squeeze(mean(data,1));
        data_range=max(data_range_spectra,[],2);
        [peak_val,range_ind]=max(data_range);
        data_spectra=squeeze(mean(data_range_spectra(range_ind-20:range_ind+20,:),1));

        veg_struct(i,vert_i+1).spect=data_spectra;
        veg_struct(i,vert_i+1).range_ind=range_ind;
        veg_struct(i,vert_i+1).range=range_vector(range_ind);
        veg_struct(i,vert_i+1).elastic=mean(data_spectra(find(la>390,1):find(la>420,1)));
        veg_struct(i,vert_i+1).spect_440_520=mean(data_spectra(find(la>420,1):find(la>520,1)));
        veg_struct(i,vert_i+1).spect_660_700=mean(data_spectra(find(la>660,1):find(la>700,1)));
        veg_struct(i,vert_i+1).spect_715_755=mean(data_spectra(find(la>715,1):find(la>755,1)));
        veg_struct(i,vert_i+1).vert_deg = vert_i; % vetrical steps were 1 degree
        veg_struct(i,vert_i+1).hor_deg = (i-1)*deg_per_file;
    end
end

hor_span =1:size(veg_struct,1)-1;
ver_span = 1:size(veg_struct,2);
veg_spect= [veg_struct(hor_span,ver_span).spect];
veg_spect = reshape(veg_spect,length(hor_span)*length(ver_span),length(veg_struct(1,2).spect));

red= [veg_struct(hor_span,ver_span).spect_715_755]';
green= [veg_struct(hor_span,ver_span).spect_660_700]';
blue= [veg_struct(hor_span,ver_span).spect_440_520]';    
color = [red,green,blue];

x_dist =[veg_struct(hor_span,ver_span).range].*cosd([veg_struct(hor_span,ver_span).vert_deg]).*cosd([veg_struct(hor_span,ver_span).hor_deg]);
y_dist =[veg_struct(hor_span,ver_span).range].*cosd([veg_struct(hor_span,ver_span).vert_deg]).*sind([veg_struct(hor_span,ver_span).hor_deg]);
z_dist =[veg_struct(hor_span,ver_span).range].*sind([veg_struct(hor_span,ver_span).vert_deg]);

figure;scatter3(x_dist,y_dist,z_dist,50,color, 'filled')
xlabel('X',  'FontSize', 14)
ylabel('Y', 'FontSize', 14)
zlabel('Z', 'FontSize', 14)
xlim([0, inf])



