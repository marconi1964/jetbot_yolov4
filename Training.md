# This file describes how to conduct training on Colab and on server

## Training on Colab

## Training on a server
### 1. Prerequisite - prepare a server with GPU, and CentOS 7 installed (CentOS is chosen as it is open source version of RedHat)

#### 1.1 - Add User to Sudoers in CentOS (necessary for installation)
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

#### 1.2 - Installation RDP server for GUI remote acess 
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


#### 1.3 - Python 3.6.8 is installed as default Python in CentOS 7 by checking with the following command

```
$ python3 --version
Python 3.6.8
$
```

### 2. Pre-installation Actions
> - 參考 NVidia 文章
> - [CUDA Quick Start Guide](https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#linux)
> - [CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
> - [CUDA Toolkit Download](https://developer.nvidia.com/cuda-downloads)

> - System requirements : To use CUDA on your system, you will need the following installed:
>   - CUDA-capable GPU
>   - A supported version of Linux with a gcc compiler and toolchain
>   - NVIDIA CUDA Toolkit (available at https://developer.nvidia.com/cuda-downloads)
>   - So some actions must be taken before the CUDA Toolkit and Driver can be installed on Linux:
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

> - Remark (2) Note that starting with CUDA 11.0, the minimum recommended GCC compiler is at least GCC 5 due to C++11 requirements in CUDA libraries e.g. cuFFT and CUB. On distributions such as RHEL 7 or CentOS 7 that may use an older GCC toolchain by default, it is recommended to use a newer GCC toolchain with CUDA 11.0. Newer GCC toolchains are available with the Red Hat Developer Toolset. 

> - Follow this document [CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) and take following steps:

#### 2.1 - Verify the system has a CUDA-capable GPU

```
$ lspci | grep -i NVIDIA
58:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
d8:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
$
```

#### 2.2 - Verify the system is running a supported version of Linux

```
$ uname -m && cat /etc/*release | grep release
x86_64
CentOS Linux release 7.9.2009 (Core)
$ 
```

#### 2.3 - Verify the System Has gcc Installed
> - The gcc compiler is required for development using the CUDA Toolkit. It is not required for running CUDA applications. It is generally installed as part of the Linux installation, and in most cases the version of gcc installed with a supported version of Linux will work correctly. 
> - Special attention on the GCC 5 is required for C++11 in CUDA libraries when CentOS 7 default GCC is 4.8.5. 
> - Decide to install GCC 9 based on 2 web links (因為其中的說明不清楚, 或是範例有問題, 如需要額外加 sudo)
>   - 主要參考 [How to install GCC/G++ 8 on CentOS](https://stackoverflow.com/questions/55345373/how-to-install-gcc-g-8-on-centos), 但是缺 sudo
>   - [How to Install GCC Compiler on CentOS 7](https://linuxize.com/post/how-to-install-gcc-compiler-on-centos-7/)

```
$ yum install centos-release-scl

# Then you can install GCC 9 and its C++ compiler:
$ yum install devtoolset-9-gcc devtoolset-9-gcc-c++

# To switch to a shell which defaults gcc and g++ to this GCC version, use:
# 每次 reboot 後都需要再執行以下指令, 要不然, reboot 後會回到 default 的 4.8.5
$ scl enable devtoolset-9 -- bash
$ gcc --version
gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

#### 2.4 - Verify the System has the Correct Kernel Headers and Development Packages Installed
> - Install the kernel headers and development packages for the currently running kernel. (結果是已經安裝好最新的版本)

```
$ sudo yum install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
# .........
Nothing to do
$
```
#### 2.5 - Choose an Installation Method
> - The CUDA Toolkit can be installed using either of two different installation mechanisms: 
>   - distribution-specific packages (RPM and Deb packages), or 
>   - a distribution-independent package (runfile packages). 
> - It is recommended to use the distribution-specific packages, where possible. So *first method distribution-specific package* is chosen.

#### 2.6 - Download the NVIDIA CUDA Toolkit
> - The NVIDIA CUDA Toolkit is available at https://developer.nvidia.com/cuda-downloads. 
> - 選擇最新版本 11.2, 選擇後, 也列出以下指令, 不過, 待會兒再執行

```
$ cd ~              # or cd ~/Downloads if you want to keep the file in the directory you prefer
$ wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-rhel7-11-2-local-11.2.0_460.27.04-1.x86_64.rpm
$ sudo rpm -i cuda-repo-rhel7-11-2-local-11.2.0_460.27.04-1.x86_64.rpm
$ sudo yum clean all
$ sudo yum -y install nvidia-driver-latest-dkms cuda
$ sudo yum -y install cuda-drivers
```

#### 2.7 Handle Conflicting Installation Methods
> - Skipped

### 3. Package Manager Installation
#### 3.1 Satisfy third-party package dependency
> - Satisfy DKMS dependency: The NVIDIA driver RPM packages depend on other external packages, such as DKMS and libvdpau. Those packages are only available on third-party repositories, such as EPEL. Any such third-party repositories must be added to the package manager repository database before installing the NVIDIA driver RPM packages, or missing dependencies will prevent the installation from proceeding.
> - To enable EPEL:

```
$ yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$
```
> - Enable optional repos:
>   - On RHEL 7 Linux only, no need for CentOS.

#### 3.2 Address custom xorg.conf, if applicable
> - The driver relies on an automatically generated xorg.conf file at /etc/X11/xorg.conf. If a custom-built xorg.conf file is present, this functionality will be disabled and the driver may not work. You can try removing the existing xorg.conf file, or adding the contents of /etc/X11/xorg.conf.d/00-nvidia.conf to the xorg.conf file. The xorg.conf file will most likely need manual tweaking for systems with a non-trivial GPU configuration.
> - 在 /etc/X11/ 目錄下找不到 xorg.conf, 所以不必做任何動作


#### 3.3 Install CUDA

```
# Assume download is completed at step 2.6, and go to the directory you have downloaded. Could be ~/. or ~/Downloads
# Install repository meta-data
$ sudo rpm -i cuda-repo-rhel7-11-2-local-11.2.0_460.27.04-1.x86_64.rpm

# Clean Yum repository cache
$ sudo yum clean expire-cache

#Install CUDA
$ sudo yum install nvidia-driver-latest-dkms
$ sudo yum install cuda
$ sudo yum install cuda-drivers
```

### 4. Post-installation Actions
#### 4.1 (Mandatory) Environment Setup
> - To add this path to the PATH variable (for 64 bit system):
>   - or add below instruction in \~/.bashrc

```
$ export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
$ export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```
> - To change the environment variables for 32-bit operating systems:

```
$ export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
$ export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

#### 4.2 (Optional) Installing , Compiling the Examples & Running the Binaries
> - Install Writable Samples
>   - In order to modify, compile, and run the samples, the samples must be installed with write permissions. A convenience installation script is provided:
> - The NVIDIA CUDA Toolkit includes sample programs in source form. You should compile them by changing to ~/NVIDIA_CUDA-11.2_Samples and typing make. The resulting binaries will be placed under ~/NVIDIA_CUDA-11.2_Samples/bin/.

```
# This script is installed with the cuda-samples-11-2 package. The cuda-samples-11-2 package installs only a read-only copy in /usr/local/cuda-11.2/samples.
$ cd ~ 
# example : cuda-install-samples-11.2.sh <dir>
$ cuda-install-samples-11.2.sh ~/Downloads

# The version of the CUDA Toolkit can be checked by running nvcc -V in a terminal window. The nvcc command runs the compiler driver that compiles CUDA programs. It calls the gcc compiler for C code and the NVIDIA PTX compiler for the CUDA code.
$ cd ~/Dowloads/NVIDIA_CUDA-11.2_Samples

# After compilation, find and run deviceQuery under ~/NVIDIA_CUDA-11.2_Samples. If the CUDA software is installed and configured correctly, the output for deviceQuery
$ ./Downloads/NVIDIA_CUDA-11.2_Samples/bin/x86_64/linux/release/deviceQuery

# Running the bandwidthTest program ensures that the system and the CUDA-capable device are able to communicate correctly.
$ ./Downloads/NVIDIA_CUDA-11.2_Samples/bin/x86_64/linux/release/bandwidthTest

```

