# This file describes how to install CUDA on a server

## 1. Prerequisite - prepare a server with GPU, and CentOS 7 installed (CentOS is chosen as it is open source version of RedHat)

### 1.1 - Add User to Sudoers in CentOS (necessary for installation)
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

### 1.2 - Installation RDP server for GUI remote acess 
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


### 1.3 - Python 3.6.8 is installed as default Python in CentOS 7 by checking with the following command

```
# install python3
$ sudo yum update
$ sudo yum install -y python3

$ python3 --version
Python 3.6.8
$
```

## 2. Pre-installation Actions

### 2.1 Install CUDA 11.2
> - 參考 NVidia 文章
> - [CUDA Quick Start Guide](https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#linux)
> - [CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
> - [CUDA Toolkit Download](https://developer.nvidia.com/cuda-downloads)
> - Q&A on Stackoverflow
>   - [Nvidia 官網 - CUDA compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/index.html)
>   - [NVIDIA 官網 - CUDA Toolkit Release Notes](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)
>   - [Different CUDA versions shown by nvcc and NVIDIA-smi](https://stackoverflow.com/questions/53422407/different-cuda-versions-shown-by-nvcc-and-nvidia-smi/53504578#53504578)
>   - [How do I select which GPU to run a job on?](https://stackoverflow.com/questions/39649102/how-do-i-select-which-gpu-to-run-a-job-on)
>   - CUDA has 2 primary APIs, the driver and the runtime API. Both have a corresponding version 
>     - The driver API (e.g. libcuda.so on linux, incl nvidia-smi) is installed by the GPU driver installer :
>     - The runtime API (e.g. libcudart.so on linux, and also nvcc) is installed by the CUDA toolkit installer (which may also have a GPU driver installer bundled in it).
>   - In any event, the (installed) driver API version may not always match the (installed) runtime API version, especially if you install a GPU driver independently from installing CUDA toolkit.
>     - In most cases, if nvidia-smi reports a CUDA version that is numerically equal to or higher than the one reported by nvcc -V, this is not a cause for concern. That is a defined compatibility path in CUDA (newer drivers/driver API support "older" CUDA toolkits/runtime API). For example if nvidia-smi reports CUDA 10.2, and nvcc -V reports CUDA 10.1, that is generally not cause for concern. It should just work, and it does not necessarily mean that you "actually installed CUDA 10.2 when you meant to install CUDA 10.1"
>   - 新舊版本的 CUDA toolkit 可以參考此篇文章, 雖然是不完整, 至少有跡可循[Older versions of Cuda](https://forums.developer.nvidia.com/t/older-versions-of-cuda/108163)
```
$ sudo apt-get install cuda-toolkit-10-0
```
>     - 我安裝了最新的 CUDA 11.2 配上 cuDNN 8.0.5, 出現以下錯誤, 嘗試重新安裝 CUDA 回 10.2 試試看, 還找不到 uninstall CUDA 的方法
```
cuDNN status Error in: file: ./src/convolutional_kernels.cu : () : line: 533 : build time: Jan 15 2021 - 09:27:55 
cuDNN Error: CUDNN_STATUS_BAD_PARAM
```

### 2.2 Install CUDA 10.1
> - 經過了幾次的嘗試, 覺得用 CUDA 10.1 的版本可能比較穩定 (目前 2021 年 1 月的 Colab 還是用 10.1), 決定安裝 CUDA 10.1 版本
> - NVidia 的官網, 並沒有描寫對舊版本的安裝的方法
> - 總算找一篇文章, 清楚說明 GPU driver 跟 CUDA 分別安裝的方法, 就依照此方法
> - [Install NVIDIA Graphic Driver - nvidia-smi](https://www.server-world.info/en/note?os=CentOS_7&p=nvidia)
>   - 需要用 CLI 模式 [If you are using Desktop Environment, change to CUI, refer to here](https://www.server-world.info/en/note?os=CentOS_7&p=runlevel)
> - [Install CUDA - gvcc & examples](https://www.server-world.info/en/note?os=CentOS_7&p=cuda&f=6)

### 2.3 Check system requirements (for both CUDA 10.1 and 11.2)
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
> - Personal remark : no need to upgrade gcc version for CUDA 10.1, just keep default gcc version to 4.8.5. Check [Stackoverflow - CUDA incompatible with my gcc version](https://stackoverflow.com/questions/6622454/cuda-incompatible-with-my-gcc-version)

> - Follow this document [CUDA installation on Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) and take following steps:

### 2.4 - Verify the system has a CUDA-capable GPU (for both CUDA 10.1 and 11.2)

```
$ lspci | grep -i NVIDIA
58:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
d8:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
$
```

### 2.5 - Verify the system is running a supported version of Linux (for both CUDA 10.1 and 11.2)

```
$ uname -m && cat /etc/*release | grep release
x86_64
CentOS Linux release 7.9.2009 (Core)
$ 
```

### 2.6 - Verify the System Has gcc Installed (for CUDA 11.2)
> - The gcc compiler is required for development using the CUDA Toolkit. It is not required for running CUDA applications. It is generally installed as part of the Linux installation, and in most cases the version of gcc installed with a supported version of Linux will work correctly. 
> - Special attention on the GCC 5 is required for C++11 in CUDA libraries when CentOS 7 default GCC is 4.8.5. 
> - Personal remark : no need to upgrade gcc version for CUDA 10.1, just keep default gcc version to 4.8.5. So below step can be skipped and go straight to 2.4.
> - For CUDA 11.2, decide to install GCC 9 based on 2 web links (因為其中的說明不清楚, 或是範例有問題, 如需要額外加 sudo)
>   - 主要參考 [How to install GCC/G++ 8 on CentOS](https://stackoverflow.com/questions/55345373/how-to-install-gcc-g-8-on-centos), 但是缺 sudo
>   - [How to Install GCC Compiler on CentOS 7](https://linuxize.com/post/how-to-install-gcc-compiler-on-centos-7/)

```
$ sudo yum install -y centos-release-scl

# Then you can install GCC 9 and its C++ compiler:
$ sudo yum install -y devtoolset-9-gcc devtoolset-9-gcc-c++

# To switch to a shell which defaults gcc and g++ to this GCC version, use:
# 每次 reboot 後都需要再執行以下指令, 要不然, reboot 後會回到 default 的 4.8.5
$ scl enable devtoolset-9 -- bash
$ gcc --version
gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### 2.7 - Verify the System has the Correct Kernel Headers and Development Packages Installed (for both CUDA 10.1 and 11.2)
> - Install the kernel headers and development packages for the currently running kernel. (結果是已經安裝好最新的版本)

```
$ sudo yum install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
# .........
Nothing to do
$
```

### 2.8 - Choose an Installation Method
> - The CUDA Toolkit can be installed using either of two different installation mechanisms: 
>   - distribution-specific packages (RPM and Deb packages), or 
>   - a distribution-independent package (runfile packages). 
> - It is recommended to use the distribution-specific packages, where possible. So *first method distribution-specific package* is chosen.

### 2.9 - Download the NVIDIA CUDA Toolkit
#### 2.9.1 for CUDA 10.1
> - NVIDIA driver download
>   - Go to web link [NVIDIA Driver Downloads](https://www.nvidia.com/Download/index.aspx?lang=en)
>     - Select Product Type : Data Center / Tesla
>     - Product Series : Telsa V100
>     - Operating System : Linux 64-bit
>     - CUDA Toolkit : 10.1
>     - Languages : English
>   - AGREE & DOWNLOAD
>   - Download file "NVIDIA-Linux-x86_64-418.165.02.run"
>   - will install at Step 3 (for both NVIDIA driver and CUDA)

#### 2.9.2 for CUDA 11.2
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


### 2.7 Handle Conflicting Installation Methods
> - Skipped

## 3.1 Package Manager Installation - for CUDA 10.1 (參考網路文章)
> - 此 3.1 章節參考網路文章, 而非 NVIDIA 官網, 建議參照此方法, 比較清楚
> - [Install NVIDIA Graphic Driver - nvidia-smi](https://www.server-world.info/en/note?os=CentOS_7&p=nvidia)
>   - 需要用 CLI 模式 [If you are using Desktop Environment, change to CUI, refer to here](https://www.server-world.info/en/note?os=CentOS_7&p=runlevel)
> - [Install CUDA - gvcc & examples](https://www.server-world.info/en/note?os=CentOS_7&p=cuda&f=6)
### 3.1.1 安裝 NVIDIA driver
> - 3.1.1.1 先改成 CLI 模式, 等安裝完後, 再改回 graphical 模式 (雖然不知道對 Server 安裝有何影響, 就照著做)

```
# 改成 CLI 模式
$ sudo systemctl set-default multi-user.target
$ sudo reboot now

# 改成 GUI 模式
$ sudo systemctl set-default graphical.target
$ sudo reboot now
```

> - 3.1.1.2 Disable nouveau driver which is loaded by default as general graphic driver. (一樣雖然不知道對 Server 安裝有何影響, 就照著做)

```
$ sudo lsmod | grep nouveau 
$ sudo vi /etc/modprobe.d/blacklist-nouveau.conf 

# add to the end (create new if it does not exist)

blacklist nouveau
options nouveau modeset=0

$ sudo dracut --force
$ sudo reboot now

```
> - 3.1.1.3 Install required kernel packages  

```
$ sudo yum -y install kernel-devel-$(uname -r) kernel-header-$(uname -r) gcc make 
Nothing to do
# 如果出現 nothing to do, 應該是正常的
```

> - 3.1.1.4  	Download Graphic Driver for your Computer from NVIDIA site.
> - [NVIDIA Driver download link](https://www.nvidia.com/Download/index.aspx?lang=en)

```
$ lspci | grep VGA 
# 不清楚用意為何, 待研究

# 到下載 NVIDIA driver 的目錄
$ sudo bash NVIDIA-Linux-x86_64-384.111.run
[Accept]

$ nvidia-smi
# 完成 NVIDIA driver 384 版及 nvidia-smi 安裝
```

> - 3.1.1.5 Install CUDA
>   -  	Download CUDA Repository RPM package from the site below and Install it. 

```
$ sudo yum -y install yum-utils       # nothing to do
# add repo for Centos 7
$ sudo yum-config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo 

# install CUDA 10.1 with enabling EPEL too
$ sudo yum --enablerepo=epel -y install cuda-10-1 

# update PATH environment
$ vi /etc/profile.d/cuda101.sh

# create new
export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} 

$ source /etc/profile.d/cuda101.sh

$ nvcc --version 

# 完成 CUDA 10.1 及 nvidia-smi 安裝
```


### 3.1.2 安裝 NVIDIA CUDA



## 3.2 Package Manager Installation - for CUDA 11.2 (參考 NVIDIA 官網)
### 3.2.1 Satisfy third-party package dependency
> - Satisfy DKMS dependency: The NVIDIA driver RPM packages depend on other external packages, such as DKMS and libvdpau. Those packages are only available on third-party repositories, such as EPEL. Any such third-party repositories must be added to the package manager repository database before installing the NVIDIA driver RPM packages, or missing dependencies will prevent the installation from proceeding.
> - To enable EPEL:

```
$ sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# 如果系統跑出 Error : Nothing to do, 可能是正常, 因為之前已經執行過 sudo yum install epel-release
# 參考 https://serverfault.com/questions/659513/error-nothing-to-do-trying-to-install-local-rpm
$
```
> - Enable optional repos:
>   - On RHEL 7 Linux only, no need for CentOS.

### 3.2.2 Address custom xorg.conf, if applicable
> - The driver relies on an automatically generated xorg.conf file at /etc/X11/xorg.conf. If a custom-built xorg.conf file is present, this functionality will be disabled and the driver may not work. You can try removing the existing xorg.conf file, or adding the contents of /etc/X11/xorg.conf.d/00-nvidia.conf to the xorg.conf file. The xorg.conf file will most likely need manual tweaking for systems with a non-trivial GPU configuration.
> - 在 /etc/X11/ 目錄下找不到 xorg.conf, 所以不必做任何動作


### 3.2.3 Install CUDA

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

如果不是要安裝最新版, 得改用以下指令集 (以安裝 10.2 版為例)

```
$ wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-rhel7-10-2-local-10.2.89-440.33.01-1.0-1.x86_64.rpm
$ sudo rpm -i cuda-repo-rhel7-10-2-local-10.2.89-440.33.01-1.0-1.x86_64.rpm

# Clean Yum repository cache
$ sudo yum clean expire-cache

#Install CUDA
$ sudo yum install cuda-10-2
$ sudo yum install nvidia-driver-10.2-dkms --skip-broken
$ sudo yum install cuda-drivers
# 出現 nothing to do, 有點奇怪

# 執行到目前為止, reboot 後, 可以執行 nvidia-smi 顯示 10.2 版, 只是, nvcc 還是 command not found (因為環境還沒設定)
```


## 4. Post-installation Actions
### 4.1 (Mandatory) Environment Setup
> - To add this path to the PATH variable (for 64 bit system):
>   - or add below instruction in \~/.bashrc

```
$ export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}
# or export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
$ export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# or export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```
> - To change the environment variables for 32-bit operating systems:

```
$ export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
$ export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

### 4.2 (Optional) Installing , Compiling the Examples & Running the Binaries
> - Install Writable Samples
>   - In order to modify, compile, and run the samples, the samples must be installed with write permissions. A convenience installation script is provided:
> - The NVIDIA CUDA Toolkit includes sample programs in source form. You should compile them by changing to ~/NVIDIA_CUDA-11.2_Samples and typing make. The resulting binaries will be placed under ~/NVIDIA_CUDA-11.2_Samples/bin/


```
# This script is installed with the cuda-samples-11-2 package. The cuda-samples-11-2 package installs only a read-only copy in /usr/local/cuda-11.2/samples.
# example : cuda-install-samples-11.2.sh <dir>
$ cd ~ 
$ cuda-install-samples-11.2.sh ~/Downloads

# The version of the CUDA Toolkit can be checked by running nvcc -V in a terminal window. The nvcc command runs the compiler driver that compiles CUDA programs. It calls the gcc compiler for C code and the NVIDIA PTX compiler for the CUDA code.
$ cd ~/Dowloads/NVIDIA_CUDA-11.2_Samples
$ make

# After compilation, find and run deviceQuery under ~/NVIDIA_CUDA-11.2_Samples. If the CUDA software is installed and configured correctly, the output for deviceQuery
$ ./Downloads/NVIDIA_CUDA-11.2_Samples/bin/x86_64/linux/release/deviceQuery

# Running the bandwidthTest program ensures that the system and the CUDA-capable device are able to communicate correctly.
$ ./Downloads/NVIDIA_CUDA-11.2_Samples/bin/x86_64/linux/release/bandwidthTest

```

> - 至於另一個 example : nbody, 就出現問題, 可能跟 GPU display 有關, 沒有再 follow up.

```
$ cd ~/Downloads/NVIDIA_CUDA-11.2_Samples/5_Simulations/nbody
$ make
$ ./nbody
# .....
CUDA error at bodysystemcuda_impl.h:184 code=999(cudaErrorUnknown) "cudaGraphicsGLRegisterBuffer(&m_pGRes[i], m_pbo[i], cudaGraphicsMapFlagsNone)" 

$ ./nbody -cpu      # 可以執行
```

## 5. Hello world - CUDA
> - [Hello World of CUDA](https://cuda-tutorial.readthedocs.io/en/latest/tutorials/tutorial01/)
>   - but with 2 bugs
>   - 1st, need to add #include <stdio.h>
>     - [Trouble compiling helloworld.cu](https://stackoverflow.com/questions/7301478/trouble-compiling-helloworld-cu)
>   - 2nd, need to add     cudaDeviceSynchronize();
>     - [Cuda Hello World printf not working](https://stackoverflow.com/questions/15669841/cuda-hello-world-printf-not-working-even-with-arch-sm-20)

``` 
// this "hello.cu" example is bugy
__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<1,1>>>(); 
    return 0;
}
```

```
// this "hello.cu" example works well
#include <stdio.h>

__global__ void cuda_hello() {
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}
```

## 6. Install cuDNN
> - Follow [NVidia cuNDD document](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#install-windows)

### 6.1 - Installing cuDNN On Linux
> - 6.1.1 - Installing NVIDIA Graphics Drivers
>   - 在 Server 上, 不需要裝 graphics driver
> - 6.1.2 - Installing The CUDA Toolkit For Linux
>   - already installed at Step 2
> - 6.1.3 - Downloading cuDNN For Linux
>    -    Go to: [NVIDIA cuDNN home page](https://developer.nvidia.com/cudnn) 
>         - log in with Google marconi.jiang
>    -    Click Download.
>    -    Complete the short survey and click Submit. 
>    -    Accept the Terms and Conditions. A list of available download versions of cuDNN displays.
>    -    Select the cuDNN version you want to install. A list of available resources displays.
>    - 下載 4 個檔案
>       - 在此目錄下 Library for Windows, Mac, Linux, Ubuntu and RedHat/Centos(x86_64architecture)
>           cuDNN Library for Linux
>       - 在此目錄下 Library for Red Hat (x86_64 & Power architecture)
>           cuDNN Runtime Library for RedHat/Centos 7.3 (RPM)
>           cuDNN Developer Library for RedHat/Centos 7.3 (RPM)
>           cuDNN Code Samples and User Guide for RedHat/Centos 7.3 (RPM)
> - 6.1.4 - Installing On Linux
> - 接下來的操作, 是以 CUDA 與 cuDNN 預設的目錄
>   - your CUDA directory path is referred to as /usr/local/cuda/          # 在 Step 2 已經設定完成
>   - your cuDNN download path is referred to as <cudnnpath>               # 我直接下載至 ~/
> - 6.1.4.1 - Tar File Installation
>   - Before issuing the following commands, you'll need to replace x.x and v8.x.x.x with your specific CUDA and cuDNN versions and package date.
>   - Procedure
>     - 1. Navigate to your <cudnnpath> directory containing the cuDNN tar file.
>     - 2. Unzip the cuDNN package.
```
    $ tar -xzvf cudnn-x.x-linux-x64-v8.x.x.x.tgz
    or
    $ tar -xzvf cudnn-x.x-linux-aarch64sbsa-v8.x.x.x.tgz
```
>     - 3. Copy the following files into the CUDA Toolkit directory.
```
    $ sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
    $ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
    $ sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
```

> - 6.1.4.2 - RPM Installation
>   - Procedure
>     - 1. Download the rpm package libcudnn*.rpm to the local path.
>     - 2. Install the rpm package from the local path. This will install the cuDNN libraries.

```
$ rpm -ivh libcudnn8-*.x86_64.rpm
$ rpm -ivh libcudnn8-devel-*.x86_64.rpm
$ rpm -ivh libcudnn8-samples-*.x86_64.rpm

# or

$ rpm -ivh libcudnn8-*.aarch64.rpm
$ rpm -ivh libcudnn8-devel-*.aarch64.rpm
$ rpm -ivh libcudnn8-samples-*.aarch64.rpm
```

> - 6.1.4.3. Package Manager Installation
>   - The Package Manager installation interfaces with your system's package manager.
>   - If the actual installation packages are available online, then the package manager will automatically download them and install them. Otherwise, the package manager installs a local repository containing the installation packages on the system.
>   - Whether the repository is available online or installed locally, the installation procedure is identical.
> - RHEL Network Installation
>   - These are the installation instructions for RHEL7 and RHEL8 users.
> - Procedure
>   - 1. Enable the repository:

```
$ sudo yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/cuda-${OS}.repo
$ sudo yum clean all

#    Where ${OS} is rhel7 or rhel8. 需要將 ${OS} 改成 rhel7
#    Install the cuDNN library:

$ sudo yum install libcudnn8=${cudnn_version}-1.${cuda_version}
$ sudo yum install libcudnn8-devel=${cudnn_version}-1.${cuda_version}

#  Where: 需要將版本號修改如下
#        ${cudnn_version} is 8.0.5.39
#        ${cuda_version} is cuda10.2, cuda10.1, cuda11.0 or cuda11.1
```

## 7. Verifying The Install On Linux
> -To verify that cuDNN is installed and is running properly, compile the mnistCUDNN sample located in the /usr/src/cudnn_samples_v8 directory in the Debian file.
> - Procedure

```
#   Copy the cuDNN samples to a writable path.
$ cp -r /usr/src/cudnn_samples_v8/ $HOME

#   Go to the writable path.
$ cd  $HOME/cudnn_samples_v8/mnistCUDNN

#   Compile the mnistCUDNN sample.
$make clean && make

#   Run the mnistCUDNN sample.
$ ./mnistCUDNN

#   If cuDNN is properly installed and running on your Linux system, you will see a message similar to the following:
#
#    Test passed!
```
