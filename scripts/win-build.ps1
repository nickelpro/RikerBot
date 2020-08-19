cmake . -G Ninja -DCMAKE_TOOLCHAIN_FILE=${TRAVIS_BUILD_DIR}\vcpkg\scripts\buildsystems\vcpkg.cmake
cmake --build . --target rikerbot_all
python3 setup.py bdist_wheel
