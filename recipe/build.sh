#!/bin/bash

ARGS="-DSYSTEM_FFTW3=ON -DSYSTEM_EIGEN3=ON -DSYSTEM_BOOST=ON -DSYSTEM_XDRFILE=ON"


export SOURCE_DIR=`pwd`
git submodule update --init --recursive
mkdir build_serial
cd build_serial
cmake ../ -DPYTHON_EXECUTABLE="$PYTHON" $ARGS ${CMAKE_ARGS}
make
export BUILD_DIR=`pwd`
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
make test
fi
cp -v analisi "$PREFIX/bin/analisi_serial"
cp -v ../tools/cp2analisi.py "$PREFIX/bin/cp2analisi"
cp -v ../tools/lammps2analisi.py "$PREFIX/bin/lammps2analisi"
"$SOURCE_DIR/install/install_python.sh" #copy library in SP_DIR
cd "$SOURCE_DIR/tests"
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
./test_cli.sh
fi

cd ../
mkdir build_mpi
cd build_mpi
cmake ../ -DUSE_MPI=ON -DPYTHON_EXECUTABLE="$PYTHON" $ARGS ${CMAKE_ARGS}
make
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
make test
fi
cp -v analisi "$PREFIX/bin/analisi"
