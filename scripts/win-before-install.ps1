$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
choco install python swig cmake ninja
refreshenv
pip install wheel
pip install conan
conan install ./scripts --profile ./scripts/msvc_profile

Import-Module BitsTransfer
Start-BitsTransfer -Source "https://aka.ms/vs/16/release/vs_buildtools.exe" -Destination "C:\vs_buildtools.exe"

New-Item -ItemType directory -Path C:\BuildTools

C:\vs_buildtools.exe --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64
