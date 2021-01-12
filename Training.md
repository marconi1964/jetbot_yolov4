# This file describes how to conduct training on Colab and on server

## Training on Colab

## Training on a server
### 0. Prerequisite - prepare a server with GPU, and CentOS 7 installed (CentOS is chosen as it is open source version of RedHat)
- 0.1 - Python 3.6.8 is installed as default Python in CentOS 7 by checking with the following command

```
$ python3 --version
Python 3.6.8
$
```

- 0.2 Check GPU status
> - 參考 [NVidia 官網 - CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
>   - Some actions must be taken before the CUDA Toolkit and Driver can be installed on Linux:
>     - Verify the system has a CUDA-capable GPU.
>     - Verify the system is running a supported version of Linux.
>     - Verify the system has gcc installed.
>     - Verify the system has the correct kernel headers and development packages installed.
>     - Download the NVIDIA CUDA Toolkit.
>     - Handle conflicting installation methods.


Table 1. Native Linux Distribution Support in CUDA 11.2 

|Distribution 	|Kernel1 	|Default GCC 	|GLIBC 	|GCC2,3 	|ICC3 	|PGI3 	|XLC3 	|CLANG 	|Arm C/C++|
|:------------- |:-------------|:-----|:-----|:-----|:-----|:-----|:-----|:-----|:-----|
|x86_64||||||||||
|RHEL 8.y (y <= 3) 	|4.18 	|8.3.1 	|2.28 	|9.x 	|19.1 	|19.x, 20.x 	|NO 	|9.0.0 	|NO|
|CentOS 8.y (y <= 3) 	|4.18 	|8.3.1 	|2.28| ditto ||||||
|RHEL 7.y (y <= 9) 	|3.10 	|4.8.5 	|2.17| ditto ||||||
|CentOS 7.y (y <= 9) 	|3.10 	|4.8.5 	|2.17| ditto ||||||
|OpenSUSE Leap 15.y (y <= 2) 	|4.12.14 	|7.4.0 	|2.26-lp151| ditto ||||||
|SUSE SLES 15.y (y <= 2) 	|4.12.14 	|7.3.1 	|2.26| ditto ||||||
|Ubuntu 20.04.15 	|5.4.0 	|9.3.0 	|2.31| ditto ||||||
|Ubuntu 18.04.z (z <= 5) 	|4.15.0 	|8.2.0 	|2.27| ditto ||||||
|Ubuntu 16.04.z (z <= 7) 	|4.5 	|5.4.0 	|2.23| ditto ||||||
|Debian 10.6 	|4.19.0 	|8.3.0 	|2.28| ditto ||||||
|Fedora 33 	|5.8 	|10.0.1 	|2.31| ditto ||||||


> - 0.2.1 - Verify the system has a CUDA-capable GPU

```
$ lspci | grep -i NVIDIA
58:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
d8:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
$
```

> - 0.2.2 - Verify the system is running a supported version of Linux

```
$ uname -m && cat /etc/*release
$
```
### 1. 
