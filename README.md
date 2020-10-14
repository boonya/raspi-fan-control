# RaspberryPI Cooling Fan Control Service

## Installation

```bash
wget https://github.com/boonya/raspi-fan-control/releases/download/v1.0.1/raspi-fan-control_1.0.1_arm64.deb
sudo dpkg -i raspi-fan-control_1.0.1_arm64.deb
```

OR

```bash
cd /usr/local/
sudo git clone https://github.com/boonya/raspi-fan-control
cd raspi-fan-control
sudo pip3 install -r requirements.txt
sudo ln -s /usr/local/raspi-fan-control/main.py /usr/bin/raspi-fan-control
sudo ln -s /usr/local/raspi-fan-control/raspi-fan-control.service /etc/systemd/system/raspi-fan-control.service
sudo systemctl daemon-reload
sudo systemctl start raspi-fan-control
sudo systemctl status raspi-fan-control
sudo systemctl enable raspi-fan-control
```

## Deinstallation

```bash
sudo apt purge raspi-fan-control
```

OR

```bash
sudo systemctl disable raspi-fan-control
sudo systemctl stop raspi-fan-control
sudo rm /usr/bin/raspi-fan-control
cd /usr/local/raspi-fan-control
sudo pip3 uninstall -r requirements.txt
cd ~
sudo rm -rf /usr/local/raspi-fan-control
```

## Additional

If you working on Ubuntu Server rather then the Raspbian you may want to give your
user rights to interact with `GPIO` interface.

For doing that you need:

- [Create `gpio` group](#create-a-gpio-group)
- [Give a `gpio` group full rights to `GPIO` interface](#give-the-gpio-group-full-rights-to-the-gpio-interface)
- [Add your user to the `gpio` group](#add-your-user-to-the-gpio-group)

### Create a GPIO group

Just type in a command line interface and press enter

```bash
sudo addgroup gpio
```

### Give the gpio group full rights to the GPIO interface

Add a line below to the file `/etc/udev/rules.d/10-raspi.rules` you have to create as well.

```txt
SUBSYSTEM=="input", GROUP="input", MODE="0660"
SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
SUBSYSTEM=="spidev", GROUP="spi", MODE="0660"
SUBSYSTEM=="bcm2835-gpiomem", GROUP="gpio", MODE="0660"

SUBSYSTEM=="gpio", GROUP="gpio", MODE="0660"
SUBSYSTEM=="gpio*", PROGRAM="/bin/sh -c '\
        chown -R root:gpio /sys/class/gpio && chmod -R 770 /sys/class/gpio;\
        chown -R root:gpio /sys/devices/virtual/gpio && chmod -R 770 /sys/devices/virtual/gpio;\
        chown -R root:gpio /sys$devpath && chmod -R 770 /sys$devpath\
'"
```

This changes an owner group to `gpio` on some system objects related to gpio device.
Also it gives full rights to the `gpio` group members.

### Add your user to the gpio group

```bash
sudo usermod -aG gpio username
```

## Origin

- [GPIO for Raspberry PI GPIO Group](https://askubuntu.com/a/1233458/790519)
- [Build Your Own IoT Fan with Raspberry Pi](https://www.digikey.com/en/maker/projects/c5061a5c6cf646b69a2ff6d698298422)
- [Настройка udev rules в Linux](https://losst.ru/nastrojka-udev-rules-v-linux)
- [Raspberry Pi PWM Generation using Python and C](https://www.electronicwings.com/raspberry-pi/raspberry-pi-pwm-generation-using-python-and-c)
