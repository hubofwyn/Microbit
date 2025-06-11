"""
Python template for micro:bit.

This script is a starting point for writing MicroPython code
to run on a BBC micro:bit. Modify it as desired.
"""

from microbit import *

# Example: Blink the LED display
while True:
    display.show(Image.HEART)
    sleep(500)
    display.clear()
    sleep(500)