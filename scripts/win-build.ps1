$Env:Python_ROOT_DIR = "C:\Python38"
C:\BuildTools\Common7\Tools\VsDevCmd.bat -help
C:\BuildTools\Common7\Tools\VsDevCmd.bat
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -G "Visual Studio 16 2019" -A x64
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
