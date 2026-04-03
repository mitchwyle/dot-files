#!/bin/bash
ffmpeg -i "$1" \
  -af "highpass=f=200,lowpass=f=3000,dynaudnorm=f=250:g=15" \
  -ar 16000 -ac 1 -c:a pcm_s16le \
  "${1%.*}_whisper_ready.wav"
