#!/usr/bin/env sh
echo --% >/dev/null;: ' | out-null
<#'

#
# sh part
#
dpkg-query -l libfuse2
if [ $? -eq 0 ]
then
sudo add-apt-repository universe
fi
sudo apt-get install fuse libfuse2 libusb-0.1-4 -y
URL=https://downloads.arduino.cc/arduino-ide/arduino-ide_2.0.3_Linux_64bit.AppImage
DIGI=https://gist.githubusercontent.com/nick-ls/7df7efc04a17b7256eaaffb8cb82ed6d/raw/5e51cb7b06501db8d3747aaa3210e0ba44cc6ea7/package_digistump_index.json
ESC="https:\/\/gist.githubusercontent.com\/nick-ls\/7df7efc04a17b7256eaaffb8cb82ed6d\/raw\/5e51cb7b06501db8d3747aaa3210e0ba44cc6ea7\/package_digistump_index.json"

# Download AppImage
wget -O ~/Desktop/Arduino.AppImage $URL
chmod +x ~/Desktop/Arduino.AppImage

# Allow USB Serial Access
cd /etc/udev/rules.d/
sudo wget https://github.com/micronucleus/micronucleus/blob/master/commandline/49-micronucleus.rules
echo "SUBSYSTEM==\"usb\", MODE=\"0660\", GROUP=\"$(id -gn)\"" | sudo tee /etc/udev/rules.d/00-usb-permissions.rules
sudo udevadm control --reload-rules

# Make the config files exist
cd ~/Desktop
./Arduino.AppImage &
PSID=$!
sleep 10
kill -9 $PSID

# Edit the config files and inject the patched micronucleus
mkdir -p ~/.arduino15/
cd ~/.arduino15/
wget $DIGI
mkdir -p ~/.arduinoIDE/
cd ~/.arduinoIDE/
mv arduino-cli.yaml temp
cat temp | sed "s/additional_urls.*\$/additional_urls: \n  - $ESC/" | tee -a arduino-cli.yaml
rm -rf temp

# Finally run the actual program
cd ~/Desktop
./Arduino.AppImage &

# end bash part

exit #>

#
# Windows powershell script
#
$URL = "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.0.3_Windows_64bit.exe"
$DIGI = "https://gist.githubusercontent.com/nick-ls/7df7efc04a17b7256eaaffb8cb82ed6d/raw/5e51cb7b06501db8d3747aaa3210e0ba44cc6ea7/package_digistump_index.json"
$DRIVERS = "https://github.com/digistump/DigistumpArduino/releases/download/1.6.7/Digistump.Drivers.zip"

echo "Downloading $($URL)"
$tempFolderPath = Join-Path $Env:Temp $(New-Guid); New-Item -Type Directory -Path $tempFolderPath | Out-Null
(New-Object System.Net.WebClient).DownloadFile($URL, "$($tempFolderPath)\arduino-install.exe")

echo "Downloading digistump board definitions..."
mkdir -Force "$($env:LOCALAPPDATA)\Arduino15"
(New-Object System.Net.WebClient).DownloadFile($DIGI, "$($env:LOCALAPPDATA)\Arduino15\package_digistump_index.json")
Start-Process powershell.exe -Verb RunAs -ArgumentList "-Command `"[Environment]::SetEnvironmentVariable('ARDUINO_BOARD_MANAGER_ADDITIONAL_URLS', '$($DIGI)', 'Machine')`""


echo "Downloading drivers..."
(New-Object System.Net.WebClient).DownloadFile($DRIVERS, "$($tempFolderPath)\drivers.zip")

echo "Installing drivers..."
Expand-Archive "$($tempFolderPath)\drivers.zip" -DestinationPath "$($tempFolderPath)\drivers"
Start-Process "$($tempFolderPath)\drivers\Digistump Drivers\DPinst64.exe" -Wait -Verb runAs | Out-Null

echo "Running installer..."
& "$($tempFolderPath)\arduino-install.exe" | Out-Null
echo "Success"
