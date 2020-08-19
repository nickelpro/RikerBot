$Env:VS160COMNTOOLS = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7"
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -DPython_ROOT_DIR=C:\Python38 -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
