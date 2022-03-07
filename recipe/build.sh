#!/bin/bash

ARGS="-DSYSTEM_FFTW3=ON -DSYSTEM_EIGEN3=ON -DSYSTEM_BOOST=ON -DSYSTEM_XDRFILE=ON"

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*darwin.* ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
  # export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g")
else
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

export SOURCE_DIR=`pwd`
mkdir build_serial
cd build_serial
cmake ../ -DPYTHON_EXECUTABLE="$PYTHON" $ARGS ${CMAKE_PLATFORM_FLAGS[@]}
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
cmake ../ -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc -DUSE_MPI=ON -DPYTHON_EXECUTABLE="$PYTHON" $ARGS ${CMAKE_PLATFORM_FLAGS[@]}
make
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
make test
fi
cp -v analisi "$PREFIX/bin/analisi"
