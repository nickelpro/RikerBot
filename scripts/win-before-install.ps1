$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python swig cmake ninja
choco install visualstudio2019buildtools --package-parameters "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
refreshenv
pip install wheel
pip install conan
conan install ./scripts --profile ./scripts/msvc_profile
