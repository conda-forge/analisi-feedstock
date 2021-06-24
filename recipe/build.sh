#!/bin/bash

ARGS="-DSYSTEM_FFTW3=ON -DSYSTEM_EIGEN3=ON -DSYSTEM_BOOST=ON -DSYSTEM_XDRFILE=ON"

mkdir build_serial
cd build_serial
cmake ../ -DPYTHON_EXECUTABLE="$PYTHON" $ARGS
make
make test
cp -v analisi "$PREFIX/bin/analisi_serial"
mkdir -p "$SP_DIR/pyanalisi"
cp -v pyanalisi*.so "$SP_DIR/pyanalisi"
cp -v ../notebooks/common.py "$SP_DIR/pyanalisi"
echo 'from pyanalisi.pyanalisi import *
from pyanalisi.common import *
' > "$SP_DIR/pyanalisi/__init__.py"
cp -v ../tools/cp2analisi.py "$PREFIX/bin/cp2analisi"
cp -v ../tools/lammps2analisi.py "$PREFIX/bin/lammps2analisi"

cd ../
mkdir build_mpi
cd build_mpi
cmake ../ -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc -DUSE_MPI=ON -DPYTHON_EXECUTABLE="$PYTHON" $ARGS
make
make test
cp -v analisi "$PREFIX/bin/analisi"
