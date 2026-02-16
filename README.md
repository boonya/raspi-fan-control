# Cooler

## RaspberryPI Cooling Fan Control Service

### Installation

First, you'll need to enable PWM, which isn't as straightforward as it might seem. The hardware PWM clock is not initialized at boot and by default only activates when the on-board sound card is in use. However, there is an alternative Device Tree Overlay that enables the hardware PWM clock for general use.

Open the `/boot/firmware/config.txt` file and add the following line:

```sh
dtoverlay=pwm-2chan
```

Then reboot your Raspberry Pi.

Once this is complete, you can download and install the package.

```sh
v=0.1.0
wget https://github.com/boonya/raspi-fan-control/releases/download/${v}/cooler_${v}_arm64.deb
sudo dpkg -i cooler_${v}_arm64.deb
```

### Deinstallation

```sh
sudo apt purge cooler
```

### A bit about PWM & schematic

To stop the motor from whining, you need to tune up the Frequency (how many times the PWM cycles per second).

- Go Ultrasonic (Recommended): Set the frequency above 20,000 Hz (Period < 50,000). The vibration will still happen, but you won't hear it.
- Go Low: Set the frequency below 100 Hz. The pitch will turn into a low hum or vibration, which is less annoying but might make the motor "jittery."

Quick Summary Table

| Frequency Period (ns) | Human Hearing Result |
| --------------------- | -------------------- | -------------------------------------------------- |
| 100 Hz                | 10,000,000           | Low hum Vibration, no high pitch                   |
| 1,000 Hz              | 1,000,000            | Loud whistle Your current (annoying) state         |
| 25,000 Hz             | 40,000               | Silent Perfect silence, but transistor may get hot |

#### Pro Tips

Hardware PWM: At high frequencies (20kHz+), standard Python libraries (like RPi.GPIO) struggle. Use the pigpio library for stable, high-speed hardware PWM.
The Diode: Ensure you have a flyback diode (like 1N4007 or a Schottky) across the motor terminals. It protects your transistor from voltage spikes that also contribute to noise.

### Origin

- [GPIO for Raspberry PI GPIO Group](https://askubuntu.com/a/1233458/790519)
- [Build Your Own IoT Fan with Raspberry Pi](https://www.digikey.com/en/maker/projects/c5061a5c6cf646b69a2ff6d698298422)
- [Настройка udev rules в Linux](https://losst.ru/nastrojka-udev-rules-v-linux)
- [Raspberry Pi PWM Generation using Python and C](https://www.electronicwings.com/raspberry-pi/raspberry-pi-pwm-generation-using-python-and-c)
- [Raspberry pi fan control and monitoring with bash](https://wiki.domoticz.com/Raspberry_pi_fan_control_and_monitoring_with_bash)
