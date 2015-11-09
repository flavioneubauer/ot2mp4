# ot2mp4
Old Tape To Mp4 linux convert tool

This is ot2mp4 - OldTapes to Mp4 - a very simple script that generates mp4 and dvd iso's
from video tapes. 

You may have some old analog camera tapes and need to convert to digital video, this is a simple tool !

What you will need:
- Capture device ( analog - digital audio and video )
- VCR
- A good pc ( at least core i5 with 4GB )
- Some linux scripting knowledge ( in the future i intend to make it simpler )

Tips:
- before starting, make sure you have the dependencies installed :
    <code>sudo apt-get install v4l-utils vlc dvdauthor ffmpeg<code>
  
- Watch out if your laptop has a camera device, you should set the correct DEVICE parameter.
Usually, the laptop camera is /dev/video0, so your device will be recongnized as /dev/video1.

Any doubts: flavio.neubauer@gmail.com 
