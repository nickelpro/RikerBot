cmake --version
cmake . -DCMAKE_TOOLCHAIN_FILE=./conan_paths.cmake -G Ninja
cmake --build . --target rikerbot_all
python setup.py bdist_wheel
