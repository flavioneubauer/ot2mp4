#!/bin/bash

# This is ot2mp4 - OldTapes to Mp4 - a simple script that generates mp4 and dvd iso's
# from video tapes. 
# You need a analog-digital video converter and a vcr. Just connect the cables properly, 
# and run this script! 
# Just watch out if your laptop has a camera device, you should set the correct DEVICE.
# Usually, the laptop camera is /dev/video0, so your device will be recongnized as /dev/video1.
#
#This file is part of ot2mp4.
#
#    ot2Mp4 is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ot2mp4 is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ot2Mp4.  If not, see <http://www.gnu.org/licenses/>.

# INPUT PARAMETERS
# Set The parameters for the recording
# Duration of the recording
DURACAO_SECS=$((32*60)) 
# The device ( analog-digital audio video converter )
DEVICE=/dev/video1
# Path to temporary data
PROCDIR=/home/$USER/.tmpvideo
# Path where output files will be saved
OUTDIR=/home/$USER/Videos/$(date "+%Y%m%d%H%M%S")

# cleans and create temporary directory
cleanProcDir(){
rm -rf $PROCDIR
mkdir $PROCDIR
}

# process that captures the audio/video
capture(){
#set the sound for the capturing device
v4l2-ctl -d $DEVICE --set-standard=ntsc --set-input=0 --set-ctrl=mute=0

# start capture
# This command line already has all the parameters to have a clean audio/video
# but suggestions are welcome.
# The output file is h264/mp3
echo "capturing audio/video ..."
cvlc v4l2:///dev/video1 :v4l2-standard=NTSC :input-slave=alsa://hw:1,0 :v4l2-chroma= :v4l2-input=0 :v4l2-audio-input=0 :v4l2-width=720 :v4l2-height=576 :v4l2-aspect-ratio=4\:3 :v4l2-fps=29.97 :no-v4l2-use-libv4l2 :v4l2-tuner=0 :v4l2-tuner-frequency=-1 :v4l2-tuner-audio-mode=0 :no-v4l2-controls-reset :v4l2-brightness=-1 :v4l2-brightness-auto=-1 :v4l2-contrast=-1 :v4l2-saturation=-1 :v4l2-hue=-1 :v4l2-hue-auto=1 :v4l2-white-balance-temperature=-1 :v4l2-auto-white-balance=1 :v4l2-red-balance=-1 :v4l2-blue-balance=-1 :v4l2-gamma=-1 :v4l2-autogain=1 :v4l2-gain=-1 :v4l2-sharpness=-1 :v4l2-chroma-gain=-1 :v4l2-chroma-gain-auto=-1 :v4l2-power-line-frequency=-1 :v4l2-backlight-compensation=-1 :v4l2-band-stop-filter=-1 :no-v4l2-hflip :no-v4l2-vflip :v4l2-rotate=-1 :v4l2-color-killer=-1 :v4l2-color-effect=-1 :v4l2-audio-volume=-1 :v4l2-audio-balance=-1 :no-v4l2-audio-mute :v4l2-audio-bass=-1 :v4l2-audio-treble=-1 :no-v4l2-audio-loudness :v4l2-set-ctrls= :live-caching=300 \
--sout "#transcode{vcodec=h264,acodec=mp3,ab=128,channels=1,samplerate=48000}:duplicate{dst=std{access=file,mux=mp4,dst=video.mp4}}" --run-time=$DURACAO_SECS vlc://quit
echo "end of capture ..."
}

# Convert the mp4 file to mpg, so we can generate a ISO
convertDVD(){
echo "converting ..."
ffmpeg -i video.mp4 -target ntsc-dvd video.mpg
}

# generates the iso for dvd recording
generateDVD(){
echo "converting iso to dvd ..."
export VIDEO_FORMAT=ntsc
cat > dvd.xml << EOF
<dvdauthor>
    <vmgm />
    <titleset>
        <titles>
            <pgc>
                <vob file="video.mpg" />
            </pgc>
        </titles>
    </titleset>
</dvdauthor>
EOF

dvdauthor -x dvd.xml -o dvd

}

# generate the iso file
generateIso(){
echo "generating iso ..."
mkisofs -dvd-video -o dvd.iso dvd
echo "iso generation completed ..."
}

# Now we run!
cleanProcDir

cd $PROCDIR

capture
convertDVD
generateDVD
generateIso

#move content to output dir
mkdir $OUTDIR
mv * $OUTDIR
