# Import the necessary micro:bit libraries
from microbit import *
import music
import random

# This is the main loop that runs forever
while True:
    # Check if the micro:bit has been shaken
    if accelerometer.was_gesture("shake"):
        display.show(Image.ANGRY)  # Show an angry face
        music.play(music.BA_DING)     # Play an angry-sounding noise
        sleep(1000)                   # Stay angry for 1 second

    # Check if the micro:bit is face down
    elif accelerometer.is_gesture("face down"):
        display.show(Image.SURPRISED) # Show a surprised face
        sleep(1000)                   # Stay surprised for 1 second

    # Check if button A is being pressed (like petting it)
    elif button_a.is_pressed():
        display.show(Image.HEART)     # Show a heart

    # If nothing is happening, just be happy
    else:
        display.show(Image.HAPPY)     # Show a happy face