#!/bin/zsh

# https://apple.stackexchange.com/a/311511
# usage: installdmg https://example.com/path/to/pkg.dmg
function installdmg {
    set -x
    tempd=$(mktemp -d)
    curl $1 > $tempd/pkg.dmg
    listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls -1 "$volume" | grep .pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach "$(echo "$listing" | cut -f 1)"
    rm -rf $tempd
    set +x
}

arch=$(uname -m)
url="";

if [ $arch == "x86_64" ]; then
    url="https://downloads.arduino.cc/arduino-ide/arduino-ide_2.0.3_macOS_64bit.dmg"
else
    url="https://downloads.arduino.cc/arduino-ide/arduino-ide_2.0.3_macOS_ARM64.dmg"
fi

installdmg $url
