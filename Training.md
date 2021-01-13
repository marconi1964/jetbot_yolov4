# This file describes how to conduct training on Colab and on server

## Training on Colab

## Training on a server
### 0. Prerequisite - prepare a server with GPU, and CentOS 7 installed (CentOS is chosen as it is open source version of RedHat)

#### 0.1 - Add User to Sudoers in CentOS (necessary for installation)
> - Reference [Add User to Sudoers in CentOS](https://linuxize.com/post/how-to-add-user-to-sudoers-in-centos/) 
>   - Add user to the sudoer list by editing the file /etc/sudoers

```
$ su                   # use root to modify /etc/sudoers
# vi /etc/sudoers
```
>     - and add the following line at the end of /etc/sudoers. Need to change the 'username' to the user id you log in
```
username  ALL=(ALL) NOPASSWD:ALL
```
>   - Or, instead of editing the sudoers file, you can achieve the same by creating a new file with the authorization rules in the /etc/sudoers.d directory. Add the same rule as you would add to the sudoers file:

```
$ echo "username  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
$
```

#### 0.2 - Installation RDP server for GUI remote acess 
> - Reference [Installing and configuring an RDP Server on CentOS 7](https://serverspace.io/support/help/installing-and-configuring-an-rdp-server-on-centos-7/) and follow the following instructions

```
# Update the packages installed on the system:

$ sudo yum -y update

# Then install the necessary packages:

$ sudo yum install -y epel-release
$ sudo yum install -y xrdp
$ sudo systemctl enable xrdp
$ sudo systemctl start xrdp

# CentOS uses FirewallD, open port 3389/TCP for RDP:

$ sudo firewall-cmd --add-port=3389/tcp --permanent
$ sudo firewall-cmd --reload
$
```


#### 0.3 - Python 3.6.8 is installed as default Python in CentOS 7 by checking with the following command

```
$ python3 --version
Python 3.6.8
$
```

#### 0.4 Check GPU status
> - 參考 NVidia 文章
> - [CUDA Quick Start Guide](https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#linux)
> - [CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
> - [CUDA Toolkit Download](https://developer.nvidia.com/cuda-downloads)

> - 0.4.1 - System requirements : To use CUDA on your system, you will need the following installed:
>   - CUDA-capable GPU
>   - A supported version of Linux with a gcc compiler and toolchain
>   - NVIDIA CUDA Toolkit (available at https://developer.nvidia.com/cuda-downloads)

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


> - 0.4.1 - Verify the system has a CUDA-capable GPU

```
$ lspci | grep -i NVIDIA
58:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
d8:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
$
```

> - 0.4.2 - Verify the system is running a supported version of Linux

```
$ uname


```


### 1. 
