#!/usr/bin/env python

from pyowm.owm import OWM
# setup, exit on failure
owm = OWM('a9fcb0683b9a9a8d43539e4f6fc397ff')

try:
    mgr = owm.weather_manager()
    observation = mgr.weather_at_place("Markham, CA")
    w = observation.weather
except:
    exit(0)

t = w.temperature('celsius')
temperature = "{}°".format(int(t['temp']))
status = w.status

# Print status and temp
print(temperature, status)

# Print just temp
#print(temperature)
