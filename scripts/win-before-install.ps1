$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python swig cmake ninja visualstudio2019buildtools
refreshenv
runas /noprofile /user:Administrator "pip install --upgrade pip"
pip install wheel
pip install conan
conan profile new default --detect
conan profile update settings.compiler="Visual Studio" default
conan profile update settings.compiler.version=16 default
conan install ./scripts

# git clone https://github.com/microsoft/vcpkg.git
# cd vcpkg
# ./bootstrap-vcpkg.bat
# ./vcpkg install --triplet x64-windows zlib botan boost-asio boost-log boost-interprocess
# ./vcpkg integrate install
