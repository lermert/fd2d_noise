MATLAB="/Applications/MATLAB_R2014b.app"
Arch=maci64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/Users/korbinian/.matlab/R2014b"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for run_noise_source_kernel_fast" > run_noise_source_kernel_fast_mex.mki
echo "CC=$CC" >> run_noise_source_kernel_fast_mex.mki
echo "CFLAGS=$CFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "CLIBS=$CLIBS" >> run_noise_source_kernel_fast_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "CXX=$CXX" >> run_noise_source_kernel_fast_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "CXXLIBS=$CXXLIBS" >> run_noise_source_kernel_fast_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "LD=$LD" >> run_noise_source_kernel_fast_mex.mki
echo "LDFLAGS=$LDFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> run_noise_source_kernel_fast_mex.mki
echo "Arch=$Arch" >> run_noise_source_kernel_fast_mex.mki
echo OMPFLAGS= >> run_noise_source_kernel_fast_mex.mki
echo OMPLINKFLAGS= >> run_noise_source_kernel_fast_mex.mki
echo "EMC_COMPILER=Xcode with Clang" >> run_noise_source_kernel_fast_mex.mki
echo "EMC_CONFIG=optim" >> run_noise_source_kernel_fast_mex.mki
"/Applications/MATLAB_R2014b.app/bin/maci64/gmake" -B -f run_noise_source_kernel_fast_mex.mk
