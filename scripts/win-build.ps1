$Env:VS160COMNTOOLS = "C:\BuildTools\Common7\Tools"
$Env:Python_ROOT_DIR = "C:\Python38"
Get-ChildItem -Path "C:\BuildTools" -Recurse
C:\BuildTools\Common7\Tools\VsDevCmd.bat && cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
