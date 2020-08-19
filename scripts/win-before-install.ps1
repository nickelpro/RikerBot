choco install python pip swig cmake ninja visualstudio2019buildtools
refreshenv

git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.bat
./vcpkg install --triplet x64-windows zlib botan boost
./vcpkg integrate install
