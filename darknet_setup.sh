#!/bin/sh

# this file is similar to "darknet_on_colab.ipynb"
# prerequite was prepared in "darknet_setup.sh"
# execution in "darknet.sh"

# Install decompression tool unar
sudo yum install -y epel-release
sudo yum install -y unar

# Install OpenCV2
# follows instruction from https://linuxize.com/post/how-to-install-opencv-on-centos-7/
sudo python3 -m pip install -U pip
sudo python3 -m pip install -U setuptools
sudo pip3 install opencv-python
python3 -c "import cv2; print(cv2.__version__)"

# install sklearn
pip3 install --user Cython
pip3 install --user --install-option="--prefix=" -U scikit-learn

# install ipython and jupyter
pip3 install --user ipython
pip3 install --user jupyter
