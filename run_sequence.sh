# The purpose of this script is to play a sequence of test images, audio, and video
# from a Raspberry Pi 4's A/V jack for recording onto a video cassette tape for measurement purposes.

start_delay=5
sleep_between_tests=1
test_duration=10

# Change the terminal color to black to "clear the screen"
sudo sh -c "TERM=linux setterm -foreground black -clear all >/dev/tty0"

echo "Setting volume to 0 dBFS in alsa"
#amixer sset 'Master' 100%
#amixer cset numid=1 100%
amixer sset 'Master' 56200 > /dev/null 2>&1 # shows as 0 dB in alsamixer
amixer cset numid=1 56200 > /dev/null 2>&1 # ¯\_(ツ)_/¯

echo "Beginning test sequence in.."

for (( i=$start_delay ; i>0 ; i-- )); 
do
    echo $i
    sleep 1
done

echo "SMPTE Color Bars / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --aspect-ratio=3:2 --image-duration=$test_duration images/SMPTE_Color_Bars.png 2> /dev/null

sleep $sleep_between_tests

echo "EIA Resolution Char / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --aspect-ratio=3:2 --image-duration=$test_duration images/EIA_RESOLUTION_CHART.png 2> /dev/null

sleep $sleep_between_tests

echo "SMPTE Color Bars / 330 Hz Sine Wave -30 dBFS"
cvlc --play-and-exit --verbose=-1 audio/330_Hz_-30_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --aspect-ratio=3:2 --image-duration=$test_duration images/RCA_Indian_Head_test_pattern.JPG 2> /dev/null

sudo python3 tweakvec/tweakvec.py --enable-chroma 0
echo "Disabled Composite Chroma Burst"
sleep $sleep_between_tests

echo "NTSC Frequency Sweep / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --image-duration=$test_duration images/NTSC-sweep.bmp 2> /dev/null

sleep $sleep_between_tests

echo "NTSC Frequency Sweep (Reduced Levels) / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --image-duration=$test_duration images/NTSC-sweep-reduced-levels.bmp 2> /dev/null

sleep $sleep_between_tests

echo "NTSC Multi-Sweep / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --image-duration=$test_duration images/NTSC-multisweep.bmp 2> /dev/null

sleep $sleep_between_tests

echo "NTSC Multi-Sweep (Reduced Levels) / 3 kHz Sine Wave -5 dBFS"
cvlc --play-and-exit --verbose=-1 audio/3_kHz_-5_dB_10s.wav 2> /dev/null &
cvlc --play-and-exit --verbose=-1 --no-video-title-show --image-duration=$test_duration images/NTSC-multisweep-reduced-levels.bmp 2> /dev/null

sleep $sleep_between_tests

sudo python3 tweakvec/tweakvec.py --enable-chroma 1
echo "Enabled Composite Chroma Burst"

echo "Big Buck Bunny"
cvlc --play-and-exit --verbose=-1 --no-video-title-show --no-autoscale --start-time=391 --stop-time=439 video/big_buck_bunny_480p_h264.mov 2> /dev/null

echo "End of test sequence."
sleep $sleep_between_tests

# Set the terminal back to normal
sudo sh -c "TERM=linux setterm -foreground white -clear all >/dev/tty0"