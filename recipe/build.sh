#!/bin/bash

ARGS="-DSYSTEM_FFTW3=ON -DSYSTEM_EIGEN3=ON -DSYSTEM_BOOST=ON -DSYSTEM_XDRFILE=ON"
export SOURCE_DIR=`pwd`
mkdir build_serial
cd build_serial
cmake ../ -DPYTHON_EXECUTABLE="$PYTHON" $ARGS
make
export BUILD_DIR=`pwd`
make test
cp -v analisi "$PREFIX/bin/analisi_serial"
cp -v ../tools/cp2analisi.py "$PREFIX/bin/cp2analisi"
cp -v ../tools/lammps2analisi.py "$PREFIX/bin/lammps2analisi"
"$SOURCE_DIR/install/install_python.sh" #copy library in SP_DIR
cd "$SOURCE_DIR/tests"
./test_cli.sh

cd ../
mkdir build_mpi
cd build_mpi
cmake ../ -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc -DUSE_MPI=ON -DPYTHON_EXECUTABLE="$PYTHON" $ARGS
make
make test
cp -v analisi "$PREFIX/bin/analisi"
