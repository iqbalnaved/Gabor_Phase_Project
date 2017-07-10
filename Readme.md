# Different Gabor filter Performance Test for Face Recognition , version 2012

MATLAB Version used: R2009b, R2010a

## Face Databases used

* FERET - 100 and 1000 subjects [fa and fb set]
* Indian Face Database - 40 subjects
* In-house - 60 subjects

## Folder structure:

![Folder structure](https://raw.githubusercontent.com/iqbalnaved/Gabor_Phase_Project/master/gabor_phase_project.png)


## Process flow

* Step 1: Create filters and save in 'filters' folder
* Step 2: Convolve gallery/probe images using appropriate Gabor filter of choice
* Step 3: Create lgbp of gallery/probe images from the convolved images 
* Step 5: Create local histogram sequence of lgbp images and store them in 'lh' folder as (gallery and probe as .mat)
* Step 6: Perform appropriate distance measure (histogram intersection/euclidean/cityblock) between face images, highest score is the matched image
* Step 7: Store result in 'results' folder

## Library functions:

Name of Function |		Description
---------------- |		-----------
LogGaborWavelet  |			The log-Gabor wavelet function
create_gcc_filter|		Create Gabor orient=concat,scale=concat filter  
create_gcs_filter|		Create Gabor orient=concat,scale=sum filter
create_gcv_filter|		Create Gabor orient=concat,scale={0,..4} filter
create_gmuc_filter|		Create Gabor orient={0,..,7},scale=concat filter
create_gmus_filter|		Create Gabor orient={0,..,7},scale=sum filter
create_gmuv_filter|		Create Gabor orient={0,..,7},scale{0,..,4} filter
create_gsc_filter|		Create Gabor orient=sum,scale=concat filter
create_gss_filter|		Create Gabor orient=sum,scale=sum filter
create_gsv_filter|		Create Gabor orient=sum,scale={0,..,4} filter
gcc_convolve|			Convolve image with Gabor orient=concat,scale=concat filter  
gcs_convolve|			Convolve image with Gabor orient=concat,scale=sum filter
gcv_convolve|			Convolve image with Gabor orient=concat,scale={0,..4} filter
gmuc_convolve|			Convolve image with Gabor orient={0,..,7},scale=concat filter
gmus_convolve|			Convolve image with Gabor orient={0,..,7},scale=sum filter
gmuv_convolve|			Convolve image with Gabor orient={0,..,7},scale{0,..,4} filter
gsc_convolve|			Convolve image with Gabor orient=sum,scale=concat filter
gss_convolve|			Convolve image with Gabor orient=sum,scale=sum filter
gsv_convolve|			Convolve image with Gabor orient=sum,scale={0,..,4} filter
efficientLGBP|			Encode convolved image to LGBP
efficientLH|				Create local histogram sequence from encoded LGBP
direct_matching|			Generates face match score using histogram intersection/eulidean/city-block distance
weighted_matching|		Generates weighted face match score using histogram intersection/eulidean/city-block distance

Please cite the following papers if you're using this code. Thank you

>@Article{Nouyed2016,
  Title                    = {A study on the discriminating characteristics of Gabor phase-face and an improved method for face recognition},
  Author                   = {Nouyed, Iqbal
and Poon, Bruce
and Amin, M. Ashraful
and Yan, Hong},
  Journal                  = {International Journal of Machine Learning and Cybernetics},
  Year                     = {2016},
  Month                    = {Dec},
  Number                   = {6},
  Pages                    = {1115--1130},
  Volume                   = {7},
  Day                      = {01},
  Doi                      = {10.1007/s13042-015-0440-8},
  ISSN                     = {1868-808X},
  Url                      = {http://dx.doi.org/10.1007/s13042-015-0440-8}
}

>@inproceedings{nouyed2011human,
  title={Human face recognition using weighted vote of Gabor magnitude filters},
  author={Nouyed, I and Poon, B and Amin, MA and Yan, H},
  booktitle={Proceedings of the 7th International Conference on Information Technology and Application, Sydney, Australia},
  pages={21--24},
  year={2011}
}

>@INPROCEEDINGS{6017000, 
author={I. Nouyed and B. Poon and M. A. Amin and H. Yan}, 
booktitle={2011 International Conference on Machine Learning and Cybernetics}, 
title={Face recognition accuracy of Gabor phase representations at different scales and orientations}, 
year={2011}, 
volume={4}, 
pages={1767-1772}, 
keywords={Gabor filters;face recognition;feature extraction;image representation;Gabor phase representations;different orientations;different scales;face recognition accuracy;feature representations;Educational institutions;Face;Face recognition;Gabor filters;Histograms;Kernel;Tensile stress;Face recognition;Gabor;Gabor magnitude;Gabor phase;Histogram Intersection;Local Gabor Binary Pattern}, 
doi={10.1109/ICMLC.2011.6017000}, 
ISSN={2160-133X}, 
month={July},}

>@inproceedings{nouyed2013facial,
  title={Facial authentication using Gabor phase feature representations},
  author={Nouyed, Iqbal and Poon, Bruce and Amin, M Ashraful and Yan, Hong},
  booktitle={Proceedings of the international multiconference of engineers and computer scientists},
  volume={1},
  pages={413--418},
  year={2013}
}
