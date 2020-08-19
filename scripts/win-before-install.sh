git clone git@github.com:microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.bat
./vcpkg install botan
./vcpkg install zlib
./vcpkg install boost
./vcpkg integrate install
