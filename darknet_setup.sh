#!/bin/sh

# this file is similar to "darknet_on_colab.ipynb"
# prerequite was prepared in "darknet_setup.sh"
# execution in "darknet.sh"

# check README_CUDA_installation.md and README_training_on_server.md

# before execution of this shell, remember to take the actions below
#  - $ cd jetbot_yolov4 
#  - $ chmod +x *
#  - $ ./darknet_setup.sh            # and make sure no 'sudo'


# Install decompression tool unar
sudo yum install -y epel-release
sudo yum install -y unar

# Install OpenCV2
# follows instruction from https://linuxize.com/post/how-to-install-opencv-on-centos-7/
sudo python3 -m pip install -U pip
sudo python3 -m pip install -U setuptools

sudo yum install opencv opencv-devel opencv-python
pkg-config --modversion opencv

# sudo pip3 install opencv-python
# python3 -c "import cv2; print(cv2.__version__)"

# install sklearn
pip3 install --user Cython
pip3 install --user -U scikit-learn               # remove --install-option to work
#pip3 install --user --install-option="--prefix=" -U scikit-learn

# install ipython and jupyter
pip3 install --user ipython
pip3 install --user jupyter

pip3 install labelme2coco

# install and compile darknet
cd ~
git clone https://github.com/AlexeyAB/darknet.git
sed -i "s/GPU=0/GPU=1/g" ~/darknet/Makefile
sed -i "s/CUDNN=0/CUDNN=1/g" ~/darknet/Makefile
sed -i "s/OPENCV=0/OPENCV=1/g" ~/darknet/Makefile

# Check https://stackoverflow.com/questions/33107237/implicit-declaration-of-timersub-function-in-linux-what-must-i-define
# to modify Makefile
# add in the top of the Make file #define _BSD_SOURCE
# add and remove CFLAG=--std=c99 

cd darknet
make

# current directory is ~/darket
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights
./darknet detect ~/darknet/cfg/yolov4.cfg yolov4.weights ~/darknet/data/dog.jpg -dont_show


cd ~
git clone https://github.com/ssaru/convert2Yolo.git
cd convert2Yolo
# modify requirements.txt to numpy=1.15.1 for convert2yolo dependency
sed -i "s/numpy==1.14.3/numpy==1.15.1/g" requirements.txt
pip3 install -r requirements.txt
