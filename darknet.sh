#!/bin/sh
# this file is similar to "darknet_on_colab.ipynb"
# prerequite was prepared in "darknet_setup.sh"
# execution in "darknet.sh"

# check README_CUDA_installation.md and README_training_on_server.md

# Download tag'ed image files from 
cd ~
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yf4clDi07G_DMF0Jfh9ZZVp-E7L3KFkJ' -O Object_11_20.rar
unar -o sample/ Object_11_20.rar 