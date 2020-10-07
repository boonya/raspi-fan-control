# RaspberyPI Temperature Control Service

## Preparation

To enable your user works with GPIO interface on a Ubuntu Server you have to:

- Create `gpio` group
- Add GPIO device to the `gpio` group
- Add your user to the `gpio` group

### Create GPIO group

Just type in a command line interface and press enter

```bash
sudo addgroup gpio
```

### Add GPIO device to the gpio group

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

## Installation

```bash
cd /usr/local/
sudo git clone https://github.com/boonya/raspi-temp-control
cd raspi-temp-control
sudo pip3 install -r requirements.txt
sudo ln -s /usr/local/raspi-temp-control/main.py /usr/bin/raspi-temp-control
sudo ln -s /usr/local/raspi-temp-control/raspi-temp-control.service /etc/systemd/system/raspi-temp-control.service
sudo systemctl daemon-reload
sudo systemctl start raspi-temp-control
sudo systemctl enable raspi-temp-control
```

## Origin

- [](https://askubuntu.com/a/1233458/790519)
- [](https://www.digikey.com/en/maker/projects/c5061a5c6cf646b69a2ff6d698298422)
- [udev RUS](https://losst.ru/nastrojka-udev-rules-v-linux)
- [](https://www.electronicwings.com/raspberry-pi/raspberry-pi-pwm-generation-using-python-and-c)