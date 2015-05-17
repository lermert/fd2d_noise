MATLAB="/Applications/MATLAB_R2014b.app"
Arch=maci64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/Users/korbinian/.matlab/R2014b"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for run_forward_source_fast" > run_forward_source_fast_mex.mki
echo "CC=$CC" >> run_forward_source_fast_mex.mki
echo "CFLAGS=$CFLAGS" >> run_forward_source_fast_mex.mki
echo "CLIBS=$CLIBS" >> run_forward_source_fast_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> run_forward_source_fast_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> run_forward_source_fast_mex.mki
echo "CXX=$CXX" >> run_forward_source_fast_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> run_forward_source_fast_mex.mki
echo "CXXLIBS=$CXXLIBS" >> run_forward_source_fast_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> run_forward_source_fast_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> run_forward_source_fast_mex.mki
echo "LD=$LD" >> run_forward_source_fast_mex.mki
echo "LDFLAGS=$LDFLAGS" >> run_forward_source_fast_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> run_forward_source_fast_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> run_forward_source_fast_mex.mki
echo "Arch=$Arch" >> run_forward_source_fast_mex.mki
echo OMPFLAGS= >> run_forward_source_fast_mex.mki
echo OMPLINKFLAGS= >> run_forward_source_fast_mex.mki
echo "EMC_COMPILER=Xcode with Clang" >> run_forward_source_fast_mex.mki
echo "EMC_CONFIG=optim" >> run_forward_source_fast_mex.mki
"/Applications/MATLAB_R2014b.app/bin/maci64/gmake" -B -f run_forward_source_fast_mex.mk
