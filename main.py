#!/usr/bin/env python3
from time import sleep
import RPi.GPIO as GPIO

PWM_PIN_NUMBER = 12
PWM_FREQUENCY = 100

def init_pwm_out():
    # Configure GPIO14 as an output
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(PWM_PIN_NUMBER, GPIO.OUT)

    # Create a PWM object
    pwm_out = GPIO.PWM(PWM_PIN_NUMBER, PWM_FREQUENCY)   # Create PWM instance with frequency
    pwm_out.start(0)                                    # Start PWM of required Duty Cycle

    return pwm_out

def read_temp():
    f = open("/sys/class/thermal/thermal_zone0/temp")
    temp = int(f.read()) / 1000.0
    f.close()
    return temp

def calc_duty_cycle(temp):
    if temp > 80.0:
        return 100
    if temp > 70.0:
        return 90
    if temp > 60.0:
        return 70
    if temp > 50.0:
        return 50
    if temp > 40.0:
        return 30
    return 0

def main():
    pwm_out = init_pwm_out()
    while True:
        temp = read_temp()
        print("CPU Temperature %.2f°C" % temp)
        duty_cycle = calc_duty_cycle(temp)
        print("Duty Cycle is %s" % duty_cycle)
        pwm_out.ChangeDutyCycle(duty_cycle)
        sleep(30)

if __name__ == "__main__":
    main()