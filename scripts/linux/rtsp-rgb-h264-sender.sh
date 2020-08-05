#!/bin/bash

# Example pipeline to start an RGB RTSP server

# install RTSP libraries to compile RTSP server:
# `sudo apt install libgstrtspserver-1.0-0 libgstrtspserver-1.0-dev`

HOST_IPS=(`hostname -I`)
export SERVER_IP=${HOST_IPS[0]}


gst-zed-rtsp-launch -a ${SERVER_IP} \
 zedsrc stream-type=2 resolution=2 framerate=30 stream-type=0 ! identity silent=false ! \
 videoconvert ! video/x-raw, format=I420 ! \
 x264enc tune=zerolatency bitrate=5000 speed-preset=ultrafast key-int-max=30 qp-min=8 qp-max=51 qp-step=1 ! \
 rtph264pay config-interval=-1 mtu=1500 pt=96 name=pay0
