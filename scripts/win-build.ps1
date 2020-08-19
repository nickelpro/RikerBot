$Env:VS160COMNTOOLS = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7"
$Env:CC = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.27.29110\bin\Hostx64\x64\cl.exe"
$Env:CXX = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.27.29110\bin\Hostx64\x64\cl.exe"
$Env:Python_ROOT_DIR = "C:\Python38"
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -DCMAKE_CXX_COMPILER="C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.27.29110/bin/Hostx64/x64/cl.exe" -DCMAKE_CC_COMPILER="C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.27.29110/bin/Hostx64/x64/cl.exe" -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
