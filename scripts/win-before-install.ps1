$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python swig cmake ninja visualstudio2019buildtools
refreshenv
pip install wheel
pip install conan
conan install ./scripts --profile ./scripts/msvc_profile
