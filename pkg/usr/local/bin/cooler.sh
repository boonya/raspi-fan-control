#!/bin/bash

# Device references
dev_temp=/sys/class/thermal/thermal_zone0/temp
dev_pwm=/sys/class/pwm/pwmchip0/pwm0
dev_enable=$dev_pwm/enable
dev_duty=$dev_pwm/duty_cycle
dev_period=$dev_pwm/period

# Export pwm0 if it's not available
if [ ! -e $dev_pwm ]; then
    echo 0 > /sys/class/pwm/pwmchip0/export
    sleep 2
fi

# PWM frequency (nanoseconds)
period=15000000

# temperature breakpoints (millidegrees)
off_low=34000
low_off=30000
low_high=40000
high_low=36000

# fan-speed (nanoseconds)
low=5000000
high=14999999

# on/off values
off=0
on=1

# update interval (seconds)
interval=10

# initialise the fan
next=($off $low)
echo $period > $dev_period
echo ${next[0]} > $dev_enable
echo ${next[1]} > $dev_duty

update_status() {
    if [[ $(cat $dev_enable) == 1 ]]; then
        if [[ $(cat $dev_duty) == $high ]]; then
            nvalue=3
            svalue="High"
        else
            nvalue=2
            svalue="Low"
        fi
    else
        nvalue=1
        svalue="Off"
    fi
    logger "Fan $svalue"
}

while [ : ]
do
    temp=$(cat $dev_temp)
    current=($(cat $dev_enable) $(cat $dev_duty))
    if [ $temp -gt $off_low ]; then
        next[0]=$on
        if [ $temp -gt $low_high ]; then
            next[1]=$high
        elif [ $temp -lt $high_low ]; then
            next[1]=$low
        fi
    elif [ $temp -lt $low_off ]; then
        next[0]=$off
    fi

    if [ "${next[*]}" != "${current[*]}" ]; then
        echo ${next[1]} > $dev_duty
        echo ${next[0]} > $dev_enable
        update_status
    fi
    sleep $interval
done
