# fd2d
2D staggered rid finite differences of the wave equation

Die Anleitung:

GENERAL INPUT PARAMETERS: /input/input_parameters.m
----------------------------------------------------------------------------------

* size of the computational domain
* number of grid points
* length and number of time steps
* finite-difference order

* model type as defines in /code/propagation/define_material_parameters.m

* source time function (only relevant for simulation_mode=forward)

* simulation_mode (type of forward or adjoint simulation)

* source and receiver positions

* absorbing boundaries (where and how wide)


COMPUTING NOISE CORRELATIONS
-----------------------------------------------------

The computation of noise correlations proceeds in two steps.

STEP 1: Computation of the Green’s function with source at the reference station
* Edit the simulation parameters in input_parameters.m (domain, time step, receivers, …).
* The source (in earthquake simulations) acts as the reference station in noise correlation simulations.
* Set the simulation_mode to “forward_green”.
* Go to /input/interferometry/input_interferometry.m and edit the frequency sampling of the Green’s function. 
(If the sampling is too low in the frequency domain, then artefacts appear on the correlation source function. Trial and error?)
* Go to /code/ and run “run_forward()”.
* This will compute the forward Green’s function.
* The Fourier transform of the Green’s function is computed on-the-fly, i.e. during the simulation.
* The Fourier transform is then stored as “G_2.mat” in the directory /output/interferometry/“

STEP 2: Computing the actual correlation function
* Go to /input/interferometry/make_noise_source.m and edit the noise source spectrum and the noise source geometry.
* Go to /input/input_parameters.m and set the simulation_mode to “correlation”.
* Go to /code/ and run “[u,t,rec_x,rec_z]=run_forward();” 
* The resulting correlation functions will be written to “u”. Neither “u” nor “t” are automatically stored!
* Go to /tools/ and use “plot_recordings(u,t,'vel’)” to plot velocity correlations or “plot_recordings(u,t,’dis’)” to plot displacement correlations.


COMPUTING NOISE SOURCE KERNELS
---------------------------------------------------------

The computation of noise source kernels proceeds in two steps, as well.

STEP 1: Make measurements and compute adjoint sources
* Go to /tools/. Without actual data (or at least fake data), one can only compute data-independent adjoint sources, for instance adjoint sources for cross-correlation traveltimes. For this, run “make_adjoint_sources(u,0*u,t,'vel','cc_time_shift’)”. This will compute the adjoint source for cross-correlation time shifts performed on velocity correlations. These adjoint sources are written to /input/sources/adjoint/.

STEP 2: Computing the actual kernels
* Go to /input/input_parameters.m and set the simulation_mode to “noise_source_kernel”.
* Go to /code/ and run “[X,Z,K_s]=run_noise_source_kernel();”.
* The kernel as a function of “X” and “Z” is then in “K_s”.
* Go to /tools/ and use “plot_noise_source_kernels(X,Z,K_s)” to plot noise source kernels for specific frequency bands.

COMPUTING NOISE STRUCTURE KERNELS
---------------------------------------------------------------

The computation of noise structure kernels proceeds in three steps.

STEP 1: Make measurements and compute adjoint sources, just as for the computation of noise source kernels.

STEP 2: Compute kernel for the reference station
* Go to /input/input_parameters.m and set the simulation_mode to “noise_structure_kernel”.
* Go to /code/ and run “[X,Z,K_rho]=run_noise_structure_kernel();”
* You can plot the kernel with “pcolor(X,Z,K_rho’)”.

STEP 3: Repeat the same procedure with source (reference station) and receiver (target station) interchanged. Then add both kernels to obtain the complete kernel.
