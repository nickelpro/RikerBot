$Env.Path = [Environment]::GetEnvironmentVariable("CUSTOM_PATH", "User")
cmake --version
cmake . -DCMAKE_TOOLCHAIN_FILE=./scripts/conan_paths.cmake -G Ninja
cmake --build . --target rikerbot_all
python3 setup.py bdist_wheel
