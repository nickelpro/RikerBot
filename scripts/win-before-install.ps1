choco python
eval $(powershell -NonInteractive -Command 'write("export PATH=`"" + ([Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH","User")).replace("\","/").replace("C:","/c").replace(";",":") + ":`$PATH`"")')
pip install conan
eval $(powershell -NonInteractive -Command 'write("export PATH=`"" + ([Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH","User")).replace("\","/").replace("C:","/c").replace(";",":") + ":`$PATH`"")')
conan user
conan install ./scripts

# git clone https://github.com/microsoft/vcpkg.git
# cd vcpkg
# ./bootstrap-vcpkg.bat
# ./vcpkg install --triplet x64-windows zlib botan boost-asio boost-log boost-interprocess
# ./vcpkg integrate install
