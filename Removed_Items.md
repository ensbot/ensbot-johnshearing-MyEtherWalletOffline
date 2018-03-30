

#### Graceful Shutdown on Low Battery While not Plugged In or If User Presses Power Button without Initiating Shutdown at Main Menu  
First I need to measure the current:  
* When the power button is in and the device is running,  
* When the power button is in but the device has been shutdown at the main menu,  
* When the power button is out.  
 
This requires a small circuit which:  
1. Holds the enable pins on the boost converters high (disconnects then from ground) when the power button is pressed in and the low battery pin is high which indicates the battery is charged.  
2. Initiates shutdown first and then pulls the enable pin low (connects to ground) when the power button is pressed out or if the low battery pin goes low indicating that the battery will soon fail for lack of charge and the battery charger is not plugged in.  

The materials required are  
* An OR type logic gate to handle the three input signals (1.power switch, 2.low bat pin, and 3.the 5 Volts from the AC power supply) and output a shut down command by forcing some pin on the pi low (probably pin BCM 17) if the power switch is low or if the low battery pin is low and the power supply is not pluged in.
* Hopefully some pin on the pi shows five volts when the pi is running and 0 volts when the pi has been shut down. If not I will need to make a circuit to pull the enable pins low on the boost converters which will remove power from everything except the charging circuit. 
* Finally, a resistor will be needed to hold the enable pins high once power has been reapplied.

Setting this up:  
[Source for the following advice](http://www.stderr.nl/Blog/Hardware/RaspberryPi/PowerButton.html)
Get and build the DT overlay.  
If a file /boot/overlays/gpio-shutdown.dtbo is already available on your system, you can skip this step.  

Download the devicetree overlay file. 
The easiest is to run wget on the raspberry pi itself:  
Run the following command in the pi's terminal window.
`wget http://www.stderr.nl/static/files/Hardware/RaspberryPi/gpio-shutdown-overlay.dts`  

Compile the devicetreefile:  
Run the following command in the pi's terminal window.  
`dtc -@ -I dts -O dtb -o gpio-shutdown.dtbo gpio-shutdown-overlay.dts`  
Ignore any "Warning (unit_address_vs_reg): Node /fragment@0 has a unit name, but no reg property" messages you might get.  

Copy the compiled file to /boot/overlays where the loader can find it:  
Run the following command in the pi's terminal window.  
`sudo cp gpio-shutdown.dtbo /boot/overlays/`  

Enable the overlay by adding a line to /boot/config.txt:  
`dtoverlay=gpio-shutdown`  
If you need to use a different gpio, or different settings, see the dts file for available options and the Rpi devicetree docs for setting them.  

Also in config.txt put the following line.  
This will make pin 26 go high on bootup and low on halt.  
Now pin 26 can be used shutdown power after the system has been halted.  
`dtoverlay=gpio-poweroff,active_low `  

If running systemd older than v225 (check with systemd --version), create a file called /etc/udev/rules.d/99-gpio-power.rules containing the following lines:
```
ACTION!="REMOVE", SUBSYSTEM=="input", KERNEL=="event*", SUBSYSTEMS=="platform", \
    DRIVERS=="gpio-keys", ATTRS{keys}=="116", TAG+="power-switch"
```   

On systemd v225 and above (Raspbian stretch version 2017.08.16 and upwards) this should not be needed, but I have not tested this.

Reboot your pi for changes to take effect.

Then, if you connect a pushbutton to GPIO3 and GND (pin 5 and 6 on the 40-pin header), you can let your raspberry shutdown and startup using this button. Connecting pins 5 and 6 momentarily will cause the pi to shut down gracefully but it will still be drawing a small amount of current. At this point you can remove the power source without damaging the pi. Reapplying power or connecting pins 5 and 6 again momentarily will cause the pi to start again.

All this was tested on a Rpi Zero W, a Rpi B, a Rpi B+ and a Rpi 2.

This overlay was merged into the official kernel repository, so in the future step 1 above should no longer be needed. It is included in the 1.20170811-1 kernel release, which will hopefull be included in Raspbian images soon (but the 2017.08.16 image does not include it yet).

When the new kernel is included in Raspbian, it would only leave a simple modification to /boot/config.txt to set this up :-D




Implement an SSD drive with full disk encryption.  
As of March 18 2018 full disk encryption has been implemented on the SD card. It seems to work fine. I don't see a need to go further by implementing an SSD because it is easy enough to make backup images of the encrypted SD card.  
https://www.youtube.com/watch?v=wuKgWK7O9p8  
It turns out there is no difference between a thumb drive and an SD card except that an SD card can not be removed without disassembling the device. Also, the pi 3 is the only one that will boot off a thumb drive. So we are stuck with using an SD card and swaping out the card for different people would be very cumbersome. A Solid State Drive is far better than a thumb drive or an SD card because it is much more sophisticated even though the basic technology is the same. A SSD is faster, will last longer, because it is built like a mini RAID system. The extra speed of an SSD may even make full disk encryption practical for this project. 

[Download Putty.exe found here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to  **PiSetup**.  
Look under **Alternative Binary Files**  
Download Putty.exe - the SSH/Telnet client.  
I am using the 64 bit version. You should too if you are using a 64 bit machine.  
This exe is ready to run. No need to install.  
The SHA1 hash can be checked using NodeJS the same way that the Raspian OS was checked or you can use the Win32 Disk Imager.  
There is a link at the very bottom of the download page that will take you to a listing of all the SHA1 hashes for the various downloads offered.  
I have read that getting the SHA1 hash from the same website that the downloaded file comes from is a pretty useless exercise if the website has been compromised but I am doing it anyway because at least it ensures that the file has not been tampered with during the download process. 

#### Enable SSH.  
Now that we are using a keyboard it is unnecessary to us SSH and it is a security risk.  
But I am leaving this section in just in case there is reason to use SSH in the future.  
Open NotePad and type some random characters into the document. It doesn't matter what the characters are as long as there is something to save.  

Click **Save**, navigate to the SD card, and then select **All Files** from the **File type** pulldown menu.  

Save the file as `"ssh"` (the quotation marks are included in the name). The reason for the quotation marks is to ensure that the file is created without any extensions appended to the file name.  

In order for ssh to work on a raspberry pi this file must exist in the root directory of the SD card.  

Putty.exe would be the application to use on your windows machine if you wish to SSH into your pi.  
Connect the two devices with an ethernet cable and boot up the pi  
Get the IP address of your pi by taping on the Networking icon near the upper right of the Task Bar and enter this into putty.  
Putty will then prompt you for user name and password.  
That's it! Your in.  


#### Install the Florence virtual keyboard 
Since we are using a keyboard now there is no reason to install Florence. So skip this section.  
From the VNC session you just created, open the command line interpreter (AKA Terminal Window) on your pi.  
To do this, click the icon on your pi's task bar that looks like a terminal window.  
You can also find it on in your pi's menu under **Accessories**.  

Now install Florence.  
Execute the following in the pi's terminal window.  
`sudo apt-get update && sudo apt-get install florence`  

Florence will not run correctly unless you install the **at-spi2-core** package.  
Execute the following line of code in your pi's terminal window.  
`sudo apt-get install at-spi2-core`  

Finally, reboot your pi.  

When the pi wakes up again, the Florence virtual keyboard will be available in the pi's menu under **Universal Access**  

One of the virtual keys bears the icon of a wrench. This opens your settings dialog. Under **Layout** I selected the **Standard** keyboard with the **Navigation** **Numeric** and **Florence** keyboard extensions. Under **Behavior** I selected **Mouse** as the input method and nothing was selected in the **Auto hide** checkbox group.  Under **Window** in the **Features** checkbox group **Transparent**, **Task bar**, and **Floating icon** were deselected.  

#### Install an icon to start the Florence virtual keyboard in the Application Launch Bar  
No need to do this now since we are not using the Florence keyboard.  
The process is documented here only in order to show how to add an icon to the **Application Launch Bar**  
Start this process by right clicking on the **Task Bar**, then click on **Panel Settings**, Then click on the **Panel Applets** tab, then select **Application Launch Bar** Then click the **Preferences** button. Then under **Universal Access** pick the **Florence** virtual keyboard and then press the **Add** button. Once added, the icon can be positioned with the **Up** and **Down** buttons.

#### Install the GDM3 Display Manager
No need to do any of this. GDM3 is only useful for the onscreen keyboard we needed when there was no actual keyboard.
The display manager is responsible for managing the user authentication screen. The Raspian OS comes with the LightDM display manager which does not have a virtual keyboard for password entry. The Florence virtual keyboard we just installed will not work either because there is no apparent way to load it before the login screen shows up. So we will switch out LightDM with GDM3 which does have an integrated virtual keyboard.  
[More info about that here.](https://askubuntu.com/questions/829108/what-is-gdm3-kdm-lightdm-how-to-install-and-remove-them)  

From the VNC session you just created, open the command line interpreter (AKA Terminal Window) on your pi.  
To do this, click the icon on your pi's task bar that looks like a terminal window.  
You can also find it on in your pi's menu under **Accessories**.  

Make your pi aware of the latest packages available for install.  
Execute the following line of code in your pi's terminal window.  
`sudo apt-get update`  

Now install the GDM3 display manager.  
`sudo apt-get install gdm3`  

This is a long install during which you will be asked to verify switching from LightDM to GDM3. 

Install an Application for changing GDM3 settings and other settings in GNOME  
`sudo apt-get install dconf-tools.` 
