function [data, range_pixels, spect_pixels,nbr_images] = read_FHSL_file(file)
%read_FHSL_file reads fluorescence lidar data


fid=fopen([file.folder '\' file.name],'r','b');
raw_data=fread(fid,'*int16');
fclose(fid);
spect_pixels = raw_data(2); %spect
range_pixels = raw_data(4); %range
nbr_images = raw_data(6);% nbr
raw_data=raw_data(7:end);

raw_data=reshape(raw_data,[nbr_images range_pixels spect_pixels ]);


odd = 1:2:nbr_images-1;
even = 2:2:nbr_images; 
data_odd = raw_data(odd,:,:);
data_even = raw_data(even,:,:);
if mean(mean(mean(data_even)))>mean(mean(mean(data_odd)))
    data=data_even-data_odd;
    background = data_odd;
else
    data=data_odd-data_even;
    background = data_even;
end
data = flip(data, 3); % flip spectral, not needed for UCC Lidar
data= double(data);
nbr_images=size(data,1);
end

