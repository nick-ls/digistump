# Creating A BadUSB With an Attiny85
**Modified from[ Varun Gupta](https://ke.linkedin.com/in/varun-gupta-03752778)'s blog post [here](https://macrosec.tech/index.php/2021/06/10/creating-bad-usb/). Most of the content within here comes directly from this blog post with select images and instructions differing to update it to Arduino IDE 2**

## **Introduction**

A BadUSB is any USB device that was programmed (or reprogrammed) specifically to emulate a keyboard by sending a predetermined sequence of key press events to a computer in order to complete a task, which typically has the objective of gathering/stealing information, opening a backdoor on the victim machine, installing malware, or any imaginable action that can be achieved through use of the keyboard. This works thanks to the existence of a class of USB devices called HID, Human Interface Devices. A BadUSB works by identifying itself as a keyboard to the computer when connected, so the operating system will interpret the data sent by the device as key presses.

## **Setting up the Attack**

We need to set up the Arduino IDE which can be installed from the following link:

https://www.arduino.cc/en/software

After the Arduino IDE is installed, go to File > Preferences. After that, add the following URL in the “Additional Board Manager URLs” field:

https://gist.githubusercontent.com/nick-ls/7df7efc04a17b7256eaaffb8cb82ed6d/raw/5e51cb7b06501db8d3747aaa3210e0ba44cc6ea7/package_digistump_index.json

If there is already a URL in the textbox, then the URLs can be separated using a semicolon.

![](https://github.com/nick-ls/digistump/raw/main/pic1.PNG "pic1")

This URL will tell our IDE where to look for the packages and plug-ins related to our board, in our case, it will point to all products made by Digistump. Click OK and go to Tools > Board: > Board Manager, a window will open, you can type Digispark in the textbox on the top right and select the board named "**Digispark (Default - 16.5mhz)**", an “Install” notification will appear, and clicking **Yes** on the popup will download and install the packages we need to program the Digispark.

![](https://github.com/nick-ls/digistump/raw/main/pic2.PNG "pic2")

After that is done, we need to now install the drivers of the board, so Windows is able to recognize it. Go to the link below and download the Digistump.Drivers.zip file and run the “InstallDrivers.exe” file to install the drivers. Make sure to download the latest version. The link to the drivers is:

https://github.com/digistump/DigistumpArduino/releases

![](https://macrosec.tech/wp-content/uploads/2021/05/Picture4.png "Picture4")

After all that is done, we are now ready to program the device.

## **Programming the BadUSB**

To program the device, we need to make sure that the correct board is selected. Go to Tool > Board: > Digistump AVR Boards and then select the first option as shown below:

![](https://macrosec.tech/wp-content/uploads/2021/05/Picture5.png "Picture5")

After that is done, we just need a simple script to program our BadUSB. There are many GitHub repositories for Digispark scripts. The ones which I like the most are:

-   [https://github.com/CedArctic/DigiSpark-Scripts](https://github.com/CedArctic/DigiSpark-Scripts)
-   [https://github.com/MTK911/Attiny85/tree/master/payloads](https://github.com/MTK911/Attiny85/tree/master/payloads)

For example, let us take an example of a simple payload dropper.

The code for the payload dropper can be found here:

[https://github.com/MTK911/Attiny85/blob/master/payloads/PayLoad%20Dropper/Remote_PS_Exec.ino](https://github.com/MTK911/Attiny85/blob/master/payloads/PayLoad%20Dropper/Remote_PS_Exec.ino)

Copy and paste the script to your Arduino IDE. You can make changes to the script as needed. After that click on “Verify” button to verify if the script has no errors. You might need to save the file in order to continue.

After that, click on the “Upload” button and then put in the ATTINY85 Arduino board in the USB port of your computer. Wait for the script to finish uploading. When the “Micronucleus done. Thank you!” message appears, it means that the script has finished uploading and you can unplug your BadUSB.

After that, set up your C2 and the listener to catch a reverse connection back.

Thereafter, plug the BadUSB in the victim computer and wait for the LED to flash to indicate that the program has finished running. Once that happens, you can unplug the BadUSB from the victim and you will see a connection back to your C2 if everything was configured properly.

![](https://macrosec.tech/wp-content/uploads/2021/05/Picture6.png "Picture6")

As you can see, I got a connection back to my PoshC2 and I can run various commands on the victim machine, and I have full access to the victim machine.

This is just one of the examples of the usage of BadUSB. There can be many other examples like Stealing Wi-Fi Passwords, a fork bomb, changing wallpaper, and among others. The only limit to the usage of BadUSB is your imagination.

Therefore, I urge you to try the attack yourself and have fun with it!

## **Defense and Investigation**

### **Defenses**

-   Egress filtering in Firewalls.
-   Physically block USB Ports.
-   Disable automatic installation of new USB devices.

### **Investigation**

-   Resource Monitor/Network Monitor
-   Observing Computer screen for suspicious activity

## **References**

-   [https://0x00sec.org/t/a-complete-beginner-friendly-guide-to-the-digispark-badusb/8002](https://0x00sec.org/t/a-complete-beginner-friendly-guide-to-the-digispark-badusb/8002)
-   [https://www.youtube.com/watch?v=uH-4btjE56E&t=426s](https://www.youtube.com/watch?v=uH-4btjE56E&t=426s)
-   [https://github.com/CedArctic/DigiSpark-Scripts](https://github.com/CedArctic/DigiSpark-Scripts)
-   [https://github.com/MTK911/Attiny85](https://github.com/MTK911/Attiny85)
