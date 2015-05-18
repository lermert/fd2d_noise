# fd2d_noise
fd2d_noise is a tool to calculate noise correlations and kernels for various misfit measurements. The forward solution is based on a 2D staggered grid finite difference discretization of the seismic wave equation. The kernels form the basis for an iterative inversion procedure.

<<<<<<< HEAD
=======
forward solution: based on a 2D staggered grid finite discretization of the seismic wave equation
inversion: based on adjoint techniques (different adjoint sources)
>>>>>>> origin/master


INPUT PARAMETERS:
---------------------------------------------------------------------------------------

GENERAL INPUT: /input/input_parameters.m
* size of the computational domain
* number of grid points
* time step and number of time steps
* finite-difference order
* model type as defined in /code/propagation/define_material_parameters.m
  (be careful, some are hardcoded, has to be changed)

ABSORBING BOUNDARY SPECIFICATIONS: /input/absorb_specs.m
* width of boundaries
* on/off switches for each side

OUTPUT SPECIFICATIONS: /input/output_specs.m
* adjoint source path
* verbose switch
* plot switch
* movie switch and location

SOURCE TIME FUNCTION: /input/freq_specs.m
(only relevant for simulation_mode=forward, useful e.g. for debugging)
* min and max frequency for source time function



COMPUTING NOISE CORRELATIONS: /code/calculate_data.m
---------------------------------------------------------------------------------------
* specify the desired noise source in /input/interferometry/make_noise_sources.m
* make sure that the frequency sampling of the Green's function specified in /input/interferometry/input_interferometry.m is sufficient
  (if the sampling is too low in the frequency domain, artefacts appear on the correlation source function. trial and error?)
* flip_sr is not important for now, but will be for structure kernels
* define receiver array and which stations will act as reference stations
* results are saved in array_xx_ref.mat and data_xx_ref.mat with xx="number of reference stations"


The computation of noise correlations in calculate_data.m basically proceeds in two steps.

STEP 1: Computation of the Green’s function with source at the reference station (simulation_mode=“forward_green”)
* The source (in earthquake simulations) acts as the reference station in noise correlation simulations.
* The Green's function for the reference station is calculated.
* Its Fourier transform is computed on-the-fly and is stored as “G_2_xx.mat” in the directory /output/interferometry/“.

STEP 2: Computing the actual correlation function (simulation_mode=“correlation”)
* The calculated Green's function together with the specified noise source act as source for the correlation wavefield.



COMPUTING NOISE SOURCE KERNELS: /code/calculate_kernels.m
---------------------------------------------------------------------------------------
* specify "initial" noise source in /input/interferometry/make_noise_sources.m
* set type to "source"
* flip_sr is not important for now, but will be for structure kernels
* load respective array_xx_ref.mat and data_xx_ref.mat
* choose desired measurement for adjoint source calculation
* kernel for each reference station are stored in K_s
* sum is saved in K_s_all, not smoothed


The computation of noise source kernels proceeds in three steps.
STEP 1: Computation of "initial" correlations (no need to calculate the Green's functions for the reference stations again, if they are still available in /output/interferometry/)
STEP 2: Measurements and computation of adjoint sources with /tools/make_adjoint_sources.m
STEP 3: Computing the actual kernels with run_noise_source_kernel.m

FOR DATA-INDEPENDENT KERNELS:
Without actual data (or at least fake data), one can only compute data-independent adjoint sources, for instance adjoint sources for cross-correlation traveltimes. For this, run “make_adjoint_sources(u,0*u,t,'dis','cc_time_shift’)”. This will compute the adjoint source for cross-correlation time shifts performed on velocity correlations. 
!!! In this mode, the Green's functions still have to be calculated !!!



INVERSION FOR NOISE SOURCE DISTRIBUTION: 
---------------------------------------------------------------------------------------
GENERAL COMMENT:
The inversion uses the *_fast.m scripts in /code. These are prepared for conversion to mex-files for a possible speed-up up to a factor of 5. For most set-ups (to my knowledge all set-ups without picture as source distribution or model) the conversion can easily be done with /code/mex_functions/compile.m. If the conversion is successful, _mex has to be appended to run_forward_source_fast(...) and run_noise_source_kernel_fast(...) in get_obj_grad.m (e.g. run_forward_source_fast_mex(...)). The price for the speed-up is that one has to do the conversion after each change of the code. In my opinion it is worth the trouble for playing around with different initial models or different data sets.

RUN INVERSION: /inversion/start_inversion_local.m
* specify initial model
* change get_obj_grad.m
  - load correct array and data for inversion
  - use desired measurement for adjoint source calculation
  - specify desired degree of smoothing of gradient in fspecial function
* the actual inversion uses scripts by Christian Böhm

USAGE ON EULER CLUSTER: /inversion/start_inversion_euler.m
* before first usage: follow instructions here http://www.clusterwiki.ethz.ch/brutus/Parallel_MATLAB_and_Brutus#LSF_job_pool
* load matlab module
* then execute job_start.sh in /inversion
* follow progress of job with job_watch.sh
* when the job is done, log files will be save in /inversion/logs/





!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DON'T USE THE STRUCTURE PART FOR THE MOMENT, THIS FEATURE WILL BE UPDATED SOON
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

COMPUTING NOISE STRUCTURE KERNELS
---------------------------------------------------------------------------------------

The computation of noise structure kernels proceeds in three steps.

STEP 1: Make measurements and compute adjoint sources, just as for the computation of noise source kernels.

STEP 2: Compute kernel for the reference station
* Go to /input/input_parameters.m and set the simulation_mode to “noise_structure_kernel”.
* Go to /code/ and run “[X,Z,K_rho]=run_noise_structure_kernel();”
* You can plot the kernel with “pcolor(X,Z,K_rho’)”.

STEP 3: Repeat the same procedure with source (reference station) and receiver (target station) interchanged. Then add both kernels to obtain the complete kernel.
