raspi-prep
----------

All the most common tweaks you want to do on your raspi

```
sudo apt-get install vim mercurial python-dev python-numpy python3-dev  python3-numpy libsdl-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsmpeg-dev libportmidi-dev libavformat-dev libswscale-dev libjpeg-dev libfreetype6-dev htop nginx php5-cgi php5-cli spawn-fcgi daemontools-run vim python3-pip python-pip geany geany-plugin-lua geany-plugin-prettyprinter geany-plugin-latex geany-plugin-spellcheck python-imaging rrdtool curl wget lynx zip unzip unrar-free nmap gnupg rsync rdiff-backup smartmontools tmux libglade2-dev bzr libunicap2-dev intltool libgconf2-dev build-essential ntpdate ca-certificates
sudo ntpdate -u ntp.ubuntu.com
#libunicapgtk2-dev
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
