$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python
$Env:Path
refreshenv
$Env:Path
pip install conan
conan user
conan install ./scripts

# git clone https://github.com/microsoft/vcpkg.git
# cd vcpkg
# ./bootstrap-vcpkg.bat
# ./vcpkg install --triplet x64-windows zlib botan boost-asio boost-log boost-interprocess
# ./vcpkg integrate install
