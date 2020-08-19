$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python swig cmake ninja visualstudio2019buildtools
refreshenv
pip install wheel
pip install conan
conan install ./scripts -pr=./scripts/msvc_profile

# git clone https://github.com/microsoft/vcpkg.git
# cd vcpkg
# ./bootstrap-vcpkg.bat
# ./vcpkg install --triplet x64-windows zlib botan boost-asio boost-log boost-interprocess
# ./vcpkg integrate install
