$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
refreshenv

cmake --version
cmake . -DCMAKE_TOOLCHAIN_FILE=./scripts/conan_paths.cmake -G Ninja
cmake --build . --target rikerbot_all
python3 setup.py bdist_wheel
