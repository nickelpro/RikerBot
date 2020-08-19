choco install python pip swig cmake ninja visualstudio2019buildtools conan
refreshenv
conan user
conan install ./scripts

# git clone https://github.com/microsoft/vcpkg.git
# cd vcpkg
# ./bootstrap-vcpkg.bat
# ./vcpkg install --triplet x64-windows zlib botan boost-asio boost-log boost-interprocess
# ./vcpkg integrate install
