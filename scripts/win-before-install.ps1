choco install python pip cmake ninja visualstudio2019buildtools
refreshenv

git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.bat
./vcpkg install botan
./vcpkg install zlib
./vcpkg install boost
./vcpkg integrate install
