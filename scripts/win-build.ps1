$Env:VS160COMNTOOLS = "C:\BuildTools\Common7\Tools"
$Env:CC = "cl.exe"
$Env:CXX = "cl.exe"
$Env:Python_ROOT_DIR = "C:\Python38"
C:\BuildTools\Common7\Tools\VsDevCmd.bat
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -DCMAKE_CXX_COMPILER="cl.exe" -DCMAKE_CC_COMPILER="cl.exe" -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
