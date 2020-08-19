$Env:VS160COMNTOOLS = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7"
$Env:CC = "cl.exe"
$Env:CXX = "cl.exe"
$Env:Python_ROOT_DIR = "C:\Python38"
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -DCMAKE_CXX_COMPILER="cl.exe" -DCMAKE_CC_COMPILER="cl.exe" -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
