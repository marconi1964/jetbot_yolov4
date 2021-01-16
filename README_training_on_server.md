# This file describes how to conduct jetbot_yolov4 training on a server
Assume "CUDA_installation.md" is completed

## 1. Install required packages
> - jetbot_yolov4 requires the following packages and tools
>   - OpenCV       # OpenCV 2
>   - unar         # decompression tool
>   - iPython and Jupyter for iPython notebook

```
$ git clone https://github.com/marconi1964/jetbot_yolov4.git
$ cd jetbot_yolov4
$ ./darknet_setup.sh
```

## 2. Execute Darknet compilation and training
```
$ ./darknet.sh
```
