@echo ON
setlocal enabledelayedexpansion
git submodule update --init --recursive
mkdir build 
cd build

cmake ../ -G "NMake Makefiles" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      -DBUILD_MMAP=OFF -DBUILD_TESTS=OFF -DSYSTEM_XDRFILE=ON ^
      -DSYSTEM_FFTW3=ON -DSYSTEM_EIGEN3=ON -DSYSTEM_BOOST=ON 

if errorlevel 1 exit 1

:: Build!
nmake
if errorlevel 1 exit 1

:: Install!
mkdir %SP_DIR%\pyanalisi
copy pyanalisi* %SP_DIR%\pyanalisi\
copy ..\pyanalisi\common.py %SP_DIR%\pyanalisi\
copy ..\pyanalisi\__init__.py %SP_DIR%\pyanalisi\
if errorlevel 1 exit 1
