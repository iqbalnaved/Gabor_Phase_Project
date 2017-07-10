# Different Gabor filter Performance Test for Face Recognition , version 2012
===========================================================================

MATLAB Version used: R2009b, R2010a

## Face Databases used
===================

FERET - 100 and 1000 subjects [fa and fb set]
Indian - 40 subjects
In-house - 60 subjects

## Folder structure:
=================
`Gabor_Project_v5
   |
   --- db [Stores face data]
   |   |
   |   --- gallery set 
   |   --- probe set
   --- lh [Stores local histograms, gallery set and probe set as .mat files]
   --- filters [Created Gabor filters are stored here]
   --- lib [Code goes here]
   --- results [Stores matching score in .txt here in corresponding test folder]
   --- tests [Codes created for specific tests goes here]`

## Process flow
============
* Step 1: Create filters and save in 'filters' folder
* Step 2: Convolve gallery/probe images using appropriate Gabor filter of choice
* Step 3: Create lgbp of gallery/probe images from the convolved images 
* Step 5: Create local histogram sequence of lgbp images and store them in 'lh' folder as (gallery and probe as .mat)
* Step 6: Perform appropriate distance measure (histogram intersection/euclidean/cityblock) between face images, highest score is the matched image
* Step 7: Store result in 'results' folder

## Library functions:
=================
`
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
`


