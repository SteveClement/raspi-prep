raspi-prep
----------

All the most common tweaks you want to do on your raspi

```
sudo apt-get install vim mercurial python-dev python-numpy python3-dev  python3-numpy libsdl-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsmpeg-dev libportmidi-dev libavformat-dev libswscale-dev libjpeg-dev libfreetype6-dev htop nginx php5-cgi php5-cli spawn-fcgi daemontools-run vim python3-pip python-pip geany geany-plugin-lua geany-plugin-prettyprinter geany-plugin-latex geany-plugin-spellcheck python-imaging rrdtool curl wget lynx zip unzip unrar-free nmap gnupg rsync rdiff-backup smartmontools tmux libglade2-dev bzr libunicap2-dev intltool libgconf2-dev build-essential ntpdate ca-certificates
sudo ntpdate -u ntp.ubuntu.com
#libunicapgtk2-dev
```

wireless
--------

Remove:

```
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
```

If you need the iw command to do:

```
iw scan wlan0
```

if this command returns 'nl80211 not found.' it means the wifi driver does not support the newer nl80211 api. Which in turn means you need the older hostapd.

Amend:

```
allow-hotplug wlan0
auto wlan0

iface wlan0 inet dhcp
        wpa-ssid "ssid"
        wpa-psk "password"
```

pibrella
--------

```
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install vim python3-pip python-pip geany tmux
sudo pip-3.2 install pibrella
sudo pip install pibrella
```

camera module
-------------

```
sudo apt-get install vlc-nox
sudo modprobe bcm2835-v4l2 # add 'bcm2835-v4l2' to /etc/modules

# Very slow:
cvlc v4l2:///dev/video0 --v4l2-width 1920 --v4l2-height 1080 --v4l2-chroma h264 --sout '#standard{access=http,mux=ts,dst=0.0.0.0:31337}'

# Much better but will show video on framebuffer:
raspivid -o - -t 0 -hf -w 640 -h 360 -fps 25 | cvlc -vvv stream:///dev/stdin --ut '#standard{access=http,mux=ts,dst=0.0.0.0:31337}' :demux=h264
# Connect with vlc now to: http://YOUR_IP_GOES_HERE:31337

# rtp foo: #rtp{sdp=rtsp://:8554}

# raspiStill example:
raspistill -tl 500 -t 999999 -vf -w 960 -h 720 -o /tmp/mjpg/test.jpg -n -q 50&

# mjpg_streamer example
mjpg_streamer -i 'input_file.so -f /tmp/mjpg -raspistill'
http://<raspberrypi>:8080/?action=stream
```

locale
------

```
locale
sudo locale-gen en_US en_GB
sudo vi /etc/default/locale
add: LC_ALL=en_US.UTF-8
sudo dpkg-reconfigure locales
```

pygame py2 and py3
------------------

```
sudo apt-get install vim mercurial python-dev python-numpy python3-dev  python3-numpy libsdl-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsmpeg-dev libportmidi-dev libavformat-dev libswscale-dev libjpeg-dev libfreetype6-dev

cd ~/Desktop ; mkdir code ; cd code

hg clone https://bitbucket.org/pygame/pygame

cd pygame

python3 setup.py build
sudo python3 setup.py install

make clean
python setup.py build
sudo python setup.py install
```

Disable screen sleep
--------------------

If X is running:

```
sudo vi /etc/lightdm/lightdm.conf
xserver-command=X -s 0 dpms
```

If only on console:

```
sudo vi /etc/kbd/config
BLANK_TIME=0
POWERDOWN_TIME=0
```

LED Matrix
----------

```
sudo apt-get install python-dev python-imaging
cd ~/Desktop/code
git clone git@github.com:adafruit/rpi-rgb-led-matrix.git
cd rpi-rgb-led-matrix/
make
sudo ./minimal-example
sudo ./led-matrix -D 0
sudo python matrixtest.py
```

Use the RTC
-----------

```
sudo modprobe rtc-ds1307
echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device (rev 2 Pi)
```

Soya 3d and Python3
-------------------

```
sudo apt-get install cython3 libsdl2-dev  libglew-dev libopenal-dev libcal3d12-dev  libsdl2-image-dev libstdc++-4.8-dev python3-cerealizer blender mercurial libvorbis-dev
sudo apt-get install python3-pip
sudo pip-3.2 install cython
mkdir ~/Desktop/code ; cd ~/Desktop/code
hg clone https://bitbucket.org/jibalamy/soya3
cd soya3
python3 ./setup.py build
sudo python3 ./setup.py install
```

raspi:

```
sudo apt-get install cython libsdl1.2-dev  libglew-dev libopenal-dev libcal3d12-dev  libsdl-image1.2-dev libstdc++-4.8-dev python-cerealizer blender mercurial libvorbis-dev
```

x11vnc
------

I use x11vnc and have lxde autostart it. I found x11vnc was better for me as I wanted to access the same session as being displayed via HDMI (console 0). Plus, it supports UVNC and TightVNC file transfer.

install and set password

```
x11vnc -storepasswd
```

create autostart entry

```
cd .config
mkdir autostart
cd autostart
vi x11vnc.desktop
```

- paste following text:

```
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=X11VNC
Comment=
Exec=x11vnc -forever -usepw -display :0 -ultrafilexfer
StartupNotify=false
Terminal=false
Hidden=false
```

raspi router
------------

```
sudo apt-get install rfkill zd1211-firmware hostapd hostap-utils iw dnsmasq bridge-utils
sudo cp /etc/network/interfaces /etc/network/interfaces.orig
sudo vi /etc/network/interfaces
sudo ifdown wlan0
sudo ifup wlan0
sudo cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.orig
sudo vi /etc/hostapd/hostapd.conf
sudo cp /etc/default/hostapd /etc/default/hostapd.orig
sudo vi /etc/default/hostapd
sudo cp /usr/sbin/hostapd /usr/sbin/hostapd.orig
cd /usr/sbin
sudo rm -f hostapd
sudo wget http://dl.dropbox.com/u/1663660/hostapd/hostapd
sudo chown root:root hostapd
sudo chmod 755 hostapd
sudo service networking restart
sudo service hostapd restart
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo vi /etc/dnsmasq.conf
sudo service dnsmasq restart
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
```

dnsmasq
-------

```
domain-needed

interface=wlan0

dhcp-range=192.168.2.1,192.168.2.254,12h
```


default/hostapd

```
DAEMON_CONF=”/etc/hostapd/hostapd.conf”
```

hostapd/hostapd.conf

network/interfaces

```
auto lo
auto br0

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0
allow-hotplug eth0
iface wlan0 inet manual

iface br0 inet dhcp
        bridge_fd 1
        bridge_hello 3
        bridge_maxage 10
        bridge_stp off
        bridge_ports eth0 wlan0
```

This setup can be used to hide private networks. Additional routing (DNAT, SNAT) is requried.

```
auto brnat
iface brnat inet static
  address 10.10.10.254
  netmask 255.255.255.0
  bridge_stp off
  bridge_maxwait 5
  pre-up  /usr/sbin/brctl addbr brnat
  post-up /usr/sbin/brctl setfd brnat 0
  #post-up /sbin/iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE
  #post-up echo 1 > /proc/sys/net/ipv4/ip_forward
```

More on bridges: http://www.stefan-seelmann.de/wiki/bridged-network

LE DEbug: sudo hostapd -d /etc/hostapd/hostapd.conf

```
sudo apt-get install watchdog

sudo modprobe bcm2708_wdog

sudo vi /etc/modules
```

Add:  

```
bcm2708_wdog
```


```
sudo update-rc.d watchdog defaults
sudo nano /etc/watchdog.conf
```

#uncomment the following:
```
max-load-1
watchdog-device
```

```
sudo service watchdog start
sudo apt-get install ufw
sudo ufw allow 22
sudo ufw enable
sudo ufw status verbose
sudo apt-get install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo service fail2ban restart
wondershaper to restrict upload
sudo wondershaper wlan0 100000 400
sudo wondershaper clear wlan0
```

onionizing
----------

Cleaning apt dist dir:

```
sudo rm -r /var/cache/apt
```

custom resolution
-----------------

```
hdmi_cvt=1680 1050 60 5 0 0 1
hdmi_cvt=1720 1440 60 3 0 0 1
```

Raspi FrameBuffer pygame
------------------------

```
import os
import pygame
import time
import random

class pyscope :
    screen = None;

    def __init__(self):
        "Ininitializes a new pygame screen using the framebuffer"
        # Based on "Python GUI in Linux frame buffer"
        # http://www.karoltomala.com/blog/?p=679
        disp_no = os.getenv("DISPLAY")
        if disp_no:
            print "I'm running under X display = {0}".format(disp_no)

        # Check which frame buffer drivers are available
        # Start with fbcon since directfb hangs with composite output
        drivers = ['fbcon', 'directfb', 'svgalib']
        found = False
        for driver in drivers:
            # Make sure that SDL_VIDEODRIVER is set
            if not os.getenv('SDL_VIDEODRIVER'):
                os.putenv('SDL_VIDEODRIVER', driver)
            try:
                pygame.display.init()
            except pygame.error:
                print 'Driver: {0} failed.'.format(driver)
                continue
            found = True
            break

        if not found:
            raise Exception('No suitable video driver found!')

        size = (pygame.display.Info().current_w, pygame.display.Info().current_h)
        print "Framebuffer size: %d x %d" % (size[0], size[1])
        self.screen = pygame.display.set_mode(size, pygame.FULLSCREEN)
        # Clear the screen to start
        self.screen.fill((0, 0, 0))
        # Initialise font support
        pygame.font.init()
        # Render the screen
        pygame.display.update()

    def __del__(self):
        "Destructor to make sure pygame shuts down, etc."

    def test(self):
        # Fill the screen with red (255, 0, 0)
        red = (255, 0, 0)
        self.screen.fill(red)
        # Update the display
        pygame.display.update()

# Create an instance of the PyScope class
scope = pyscope()
scope.test()
time.sleep(10)
```

rpi-update kernel
-----------------

https://github.com/Hexxeh/rpi-update

To go to the "next" kernel level:

```
sudo BRANCH=next rpi-update
```

Display-o-tron 3000
-------------------

Python 2.x

```
sudo apt-get install python-dev python-pip python-smbus
sudo pip install sn3218 st7036
```

Python 3.x

```
sudo apt-get install python3-dev python3-pip
sudo pip-3.2 install sn3218 st7036
```

Python3 smbus
```
mkdir -p ~/Desktop/code ; cd ~/Desktop/code
git clone git@github.com:SteveClement/fearMe.git
mkdir -p ~/Desktop/code/fearMe/Downloads
cd ~/Desktop/code/fearMe/Downloads
wget -c http://ftp.de.debian.org/debian/pool/main/i/i2c-tools/i2c-tools_3.1.0.orig.tar.bz2
tar xf i2c-tools_3.1.0.orig.tar.bz2
cd i2c-tools-3.1.0/py-smbus
cp smbusmodule.c smbusmodule.c.orig
cat ~/Desktop/code/fearMe/Patches/smbusmodule.c.diff | patch
wget -c http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-2.10.8.tar.gz
tar xfz lm_sensors-2.10.8.tar.gz
cp lm_sensors-2.10.8/kernel/include/i2c-dev.h .
rm -r lm_sensors-2.10.8*
python3 setup.py build
sudo python3 setup.py install
sudo pip-3.2 install dot3k
```

Build and Install
-----------------

```
cd ~/Desktop/code
git clone https://github.com/pimoroni/dot3k
cd ~/Desktop/code/dot3k/python/library
python ./setup.py build
sudo python ./setup.py install
sudo python ./setup.py clean
python3 ./setup.py build
sudo python3 ./setup.py install
```

Testing
-------

```
cd ~/Desktop/code/dot3k/python/examples/basic
sudo python hellow_world.py
sudo pip-3.2 install sn3218 st7036
```


crontab
-------

If you want your script to be run on-boot, in a tmux session. Follow these lines.

Add:

```
@reboot ~/Desktop/code/raspi-prep/Scripts/myScript_tmux.sh
```

to your $LUSER crontab this runs given script after a reboot

setting hostname
----------------

```
sudo vi /etc/hostname /etc/hosts
sudo /etc/init.d/hostname.sh
```

munin-node
----------

```
sudo apt-get install munin-node
# change the allow line in munin-node.conf
sudo vi /etc/munin/munin-node.conf

```

Add temperature to graph:

```
sudo vi /etc/munin/plugins/temp
```

```
#!/bin/sh
case $1 in
config)
cat <<'EOM'
graph_category system
graph_title Temperature
graph_vlabel temp
temp.label Celsius
EOM
exit 0;;
esac
echo -n "temp.value "
/opt/vc/bin/vcgencmd measure_temp | cut -d "=" -f2 | cut -d "'" -f1
```

```
sudo chmod +x /etc/munin/plugins/temp
sudo vi /etc/munin/plugin-conf.d/temp.conf
```

```
[temp]
user root
```

```
sudo /etc/init.d/munin-node restart
```

(source: https://yeri.be/munin-raspberry-pi-temperature-updated)

bluetooth-le
------------

```
sudo apt-get install libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev wireshark
```

```
mkdir -p ~/Desktop/code/bluez
cd ~/Desktop/code/bluez
wget https://www.kernel.org/pub/linux/bluetooth/bluez-5.29.tar.xz
tar xfvJ bluez-5.29.tar.xz
cd bluez-5.29a
./configure --disable-systemd --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc --enable-library
make
sudo make install

cd ..
git clone git@github.com:carsonmcdonald/bluez-ibeacon.git
cd bluez-ibeacon/bluez-beacon
make
# test it, with UUID: 34021335-3b49-46ed-b9da-b5f8419171de
sudo /usr/bin/hciconfig hci0 up
sudo /usr/bin/hciconfig hci0 leadv 3
sudo /usr/bin/hciconfig hci0 noscan
sudo /home/pi/Desktop/code/bluez/bluez-ibeacon/bluez-beacon/ibeacon 200 340213353b4946edb9dab5f8419171de 1 1 -29 
```

ibeacon.sh

```
#!/bin/bash
/usr/bin/hciconfig hci0 up
/usr/bin/hciconfig hci0 leadv 3
/usr/bin/hciconfig hci0 noscan
/usr/bin/hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 00 00 00 00 C8 00
export UUID="34 02 13 35 3b 49 46 ed b9 da b5 f8 41 91 71 de"
/usr/bin/hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 ${UUID} 00 00 00 00 C5 00
#1E 02 01 1A 1A FF 4C 00 02 15 [ 92 77 83 0A B2 EB 49 0F A1 DD 7F E3 8C 49 2E DE ] [ 00 00 ] [ 00 00 ] C5 00
##/home/pi/bluez/bluez-ibeacon/bluez-beacon/ibeacon 200 e2c56db5dffb48d2b060d0f5a71096e0 1 1 -29
```

To genereate unique uuid's install the uuid package on debian:

```
$ sudo apt-get install uuid
$ uuid
e8d0ccea-c40c-11e4-a04e-3f235bbf7686
```

Inside this field, you need the following values:
ID (uint8_t)               - This will always be 0x02
Data Length (uint8_t)      - The number of bytes in the rest of the payload = 0x15 (21 in dec)
128-bit UUID (uint8_t[16]) - The 128-bit ID indentifying your company/store/etc
Major (uint16_t)           - The major value (to differentiate individual stores, etc.)
Minor (uint16_t)           - The minor value (to differentiate nodes withing one location, etc.)
TX Power (uint8_t)         - This value is used to try to estimate distance based on the RSSI value

For example, the following is a valid iBeacon payload (separators added for clarity sake):
The only other missing piece is that, following the Bluetooth standard, the Manufacturer Specific
Data needs to be preceded by the Company Identifier (http://adafru.it/cYt). The company identifier

/usr/bin/hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 00 00 00 00 C8 00

1E significant octets
02 1st block of ad data is 2 octets long
01 advertising octet(s) are BT flags
1A binary value derived when certain of thos flags are set
1A next group is 26 octets long
FF identifies the group as manufacturer-specific data
4C 00 Apple Manufacturer ID
02 ???
15 ???
[UUID]
[MAJ]
[MIN]
C5 Power
00 ???

#1E 02 01 1A 1A FF 4C 00 02 15 [ 92 77 83 0A B2 EB 49 0F A1 DD 7F E3 8C 49 2E DE ] [ 00 00 ] [ 00 00 ] C5 00

This is how you decode the command: the "hci0" identifies your Bluetooth dongle, "cmd" tells hcitool to send the following command data to the device. The "0x08" is the Bluetooth command group - the "OGF" in the official parlance - and "0x0008" is the specific command ("OCF"), HCI_LE_Set_Advertising_Data.

The first "1E" is the number of “significant” octets in the advertising data that follow, up to a maximum of 31. The non-significant part should only comprise pairs of zeroes to take the number of octets up to 31 and which, to save power, are not transmitted.

The ad data is split into groups, each formatted with a single octet providing the number of remaining octets in the group - essentially it tells the Bluetooth sub-system how further along the list of octets is the next group. It’s followed by a single octet which defines the type of data, and then any number of octets holding the data itself. You can put as many of these groups into the advertising data packet as you can fit into the 31 octets allowed.

In my example, the first "02" in the sequence says the first block of ad data is two octets long. The next octet, "01" says the advertising octet(s) following are Bluetooth flags, and the "1A" is the binary value derived when certain of those flags are set.

‘1A’ says the next group is 26 octets long, and the "FF" identifies the group as manufacturer-specific data. The Bluetooth 4.0 specification says the next two octets have to expose the manufacturer: the "4C 00" is Apple’s Bluetooth manufacturer ID.

I’m not yet sure what the "02" and "15" signify, but as I say, the Proximity UUID, Major and Minor values, and the power level complete the 26 octets of manufacturer data - and the 30 octets of the entire advertising data.

Increase advertising frequency from 1/second to 10/second
https://stackoverflow.com/questions/21124993/is-there-a-way-to-increase-ble-advertisement-frequency-in-bluez

Generic Access Profile:
https://www.bluetooth.org/en-us/specification/assigned-numbers/generic-access-profile

ID | DL | UUID                                            | Minor | Major | TX Power
02 | 15 | E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 | 00 00 | 00 00 | C8

