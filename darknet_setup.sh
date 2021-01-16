#!/bin/bash

# Install decompression tool unar
sudo yum install -y epel-release
sudo yum install -y unar

# Install OpenCV2
# follows instruction from https://linuxize.com/post/how-to-install-opencv-on-centos-7/
sudo python3 -m pip install -U pip
sudo python3 -m pip install -U setuptools
sudo pip3 install opencv-python
python3 -c "import cv2; print(cv2.__version__)"

# install ipython and jupyter
pip3 install --user ipython
pip3 install --user jupyter
