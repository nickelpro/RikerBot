$Env:VS160COMNTOOLS = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\Common7\Tools"
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
type CMakeFiles/CMakeOutput.log
