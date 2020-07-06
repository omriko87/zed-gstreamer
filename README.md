<h1 align="center">
  ZED GStreamer plugins
</h1>

<h4 align="center">GStreamer plugins for the ZED stereo camera family</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#build">Build</a> •
  <a href="#plugins-parameters">Plugins parameters</a> • 
  <a href="#example-pipelines">Example pipelines</a> • 
  <a href="#related">Related</a> •
  <a href="#license">License</a>
</p>
<br>

# Key Features
GStreamer plugin package for ZED Cameras. The package is composed of two plugins:

* `zedsrc`: acquires camera color image and depth map and pushes them in a GStreamer pipeline
* `zeddemux`: receives a composite `zedsrc` stream (`color left + color right` data or `color left + depth map`), processes the eventual depth data and pushes them in two separated new streams named `src_left` and `src_aux`

## Build

### Prerequisites

 * Stereo camera: [ZED 2](https://www.stereolabs.com/zed-2/), [ZED](https://www.stereolabs.com/zed/), [ZED Mini](https://www.stereolabs.com/zed-mini/)
 * CMake (v3.1+)
 * GStreamer


### Linux installation

#### Install prerequisites

* Install the latest ZED SDK from the [official download page](https://www.stereolabs.com/developers/release/)

* Install GCC compiler and build tools

     `$ sudo apt install build-essential`

* Install CMake build system

     `$ sudo apt install cmake`

#### Clone the repository

    $ git clone https://github.com/stereolabs/zed-gstreamer.git
    $ cd zed-gstreamer

#### Build

    $ mkdir build
    $ cd build
    $ cmake -DCMAKE_BUILD_TYPE=Release ..
    $ make
    $ sudo make install 

#### Add plugin library path
   
    $ echo "export GST_PLUGIN_PATH="/usr/lib/gstreamer-1.0/" >> ~/.bashrc

Close the console

### Installation test

 * Check `ZED Video Source Plugin` installation inspecting its properties:
 
      `gst-inspect-1.0 zedsrc`

 * Check `ZED Video Demuxer` installation inspecting its properties:

      `gst-inspect-1.0 zeddemux`

## Plugins parameters

### `ZED Video Source Plugin` parameters

 * `resolution`: stream resolution - {VGA (3), HD270 (2), HD1080 (1), HD2K (0)}
 * `framerate`: stream framerate - {15, 30, 60, 100}
 * `verbose`: SDK verbose mode - {TRUE, FALSE}
 * `flip`: flip streams vertically - {TRUE, FALSE}
 * `camera-id`: camera ID - [0, 256]
 * `camera-sn`: camera serial number
 * `svo-file-path`: SVO file path for SVO input
 * `stream-ip-addr`: device IP address for remote input
 * `stream-port`: IP port for remote input
 * `stream-type`: type of video stream - {Left image (0), Right image (1), Stereo couple (2), 16 bit depth (3), Left+Depth (4) }
 * `min-depth`: Minimum depth value
 * `max-depth `: Maximum depth value
 * `disable-self-calib`: Disable the self calibration processing when the camera is opened - {TRUE, FALSE}
 * `depth-stability`: Enable depth stabilization - {TRUE, FALSE}

### `ZED Video Demuxer Plugin` parameters

 * `is-depth`: indicates if the bottom stream of a composite `stream-type` of the `ZED Video Source Plugin` is a color image (Right image) or a depth map.

## Example pipelines

### RGB stream + stream rendering

    gst-launch-1.0 zedsrc ! autovideoconvert ! fpsdisplaysink

### 16 bit Depth stream + stream rendering

    gst-launch-1.0 zedsrc stream-type=1 ! autovideoconvert ! fpsdisplaysink

### Left/Right stream + demux + streams rendering

    gst-launch-1.0 zedsrc stream-type=2 ! queue ! zeddemux is-depth=false name=demux demux.src_left ! queue ! autovideoconvert ! fpsdisplaysink  demux.src_aux ! queue ! autovideoconvert ! fpsdisplaysink

### Left/Depth stream + demux + streams rendering

    gst-launch-1.0 zedsrc stream-type=4 ! queue ! zeddemux name=demux demux.src_left ! queue ! autovideoconvert ! fpsdisplaysink  demux.src_aux ! queue ! autovideoconvert ! fpsdisplaysink

## Related

- [Stereolabs](https://www.stereolabs.com)
- [ZED 2 multi-sensor camera](https://www.stereolabs.com/zed-2/)
- [ZED SDK](https://www.stereolabs.com/developers/)

## License

This library is licensed under the LGPL License.