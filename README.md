This script needs access to raw data "vegetation_scan_night_45_30"
The data was aquired with the Fluorescence Hyperspectral lidar
the lidar is continuosly moving in a pattern:
1. horizontal right motion, contrinually aquiring data.
2. it then takes a step 1 degree vertically upwards. not recording data.
3. horizontal left motion, contrinually aquiring data.
4. it then takes a step 1 degree vertically upwards. not recording data.
 Then repeats from 1-4
Each aqcuisition records a full spectrum at each range.
This code creates a struct for each measurement file. and puts those structs in a matrix 
The structs contain the mean spectra, the mean horizontal position represented by the file.
and the horizontal position. It also takes the mean intesity in some spectral windows, 
and the range of the max signal. 
The data is then visualized with a RGB point cloud based on the positions calculated by known angles and range
In this code only the left to right scanning sweeps are utilized, hence vertical resolution can easily be improved by a factor of 2
the horizontal resolution can be improved 25 times, since each file contains 25 recordings which are in this code averaged

Author: Hampus Manefjord 2023
Licence: CC BY 2.0 https://creativecommons.org/licenses/by/2.0/
You are free to:
Share and copy and redistribute the material in any medium or format
Adapt and remix, transform, and build upon the material for any purpose, even commercially.
Under the following terms:
Attribution - You must give appropriate credit, provide a link to the license, and indicate if changes were made.