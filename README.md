# <span style="color:green"> AIA Edge AI 技術班 專案</span>

## <span style="color:blue">專案準備資料</span>
> - [NVIDIA® Jetson Nano™ JETBOT AI ROBOT KIT](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetbot-ai-robot-kit/)
>   - [Jetbot github](https://github.com/NVIDIA-AI-IOT/jetbot) : 部份內容沒更新到最新版本, 如 https://github.com/NVIDIA-AI-IOT/jetbot/wiki/software-setup 的 image 下載版本已經到 JetPack 4.4.1, 此文還停留在 JetPack 4.3.
> - [Jetbot.org](https://jetbot.org/master/getting_started.html)
>   - [WaveShare JetBot AI Kit 安裝說明](https://www.waveshare.com/wiki/JetBot_AI_Kit)
> - [ROS (Robot OS)](https://wiki.ros.org)
>   - [ROS 模擬](http://gazebosim.org)
>   - [NVIDIA JetBot Gazebo Simulation 說明](https://discourse.ros.org/t/nvidia-jetbot-gazebo-simulation/16576)


## <span style="color:blue">Jetbot 開機設定</span>

參考此篇文章 https://jetbot.org/master/index.html 執行以下指令 
> <span style="color:green">1. 下載及燒錄 image  </span>
>   - 我用的是 4GB 的版本
>   - 簡單判斷 2GB 或 4GB 的方式：看充電的接頭是 micro USB 的是 for Jetson Nano (4GB), 或是 USB-C (for Jetson Nano 2GB) 

|Platform   |JetPack Version    |JetBot Version |Download|
|:------------- |:-------------|:-----|:-----|
|Jetson Nano (4GB)  |4.4.1  |0.4.2  |[jetbot-042_nano-4gb-jp441.zip](https://drive.google.com/file/d/1MAX1ibJvcLulKQeMtxbjMhsrOevBfUJd/view)|

> <span style="color:green">2. login 的 id 跟 password 都是 jetbot  </span>

> <span style="color:green">3. 如果開機時進入的是 command line 模式, 可以參考以下指令, 進入 GUI 模式   </span>https://imadelhanafi.com/posts/jetson_nano_setup/
因為, 待會兒的 examples 程式之一 teleoperation 需要用到遊戲手把 🎮 控制器, 我在 Mac 上操作 notebook 時有問題, 只有在 Jetbot 上直接執行時才 okay.

```
# disable GUI on boot
# After applying this command, the next time you reboot it will be on terminal mode
$ sudo systemctl set-default multi-user.target

# To enable GUI again
$ sudo systemctl set-default graphical.target

```

> <span style="color:green">4. 設定 wifi 的 command line 指令, 要記得 reboot 才能生效  </span>

```
$ sudo nmcli device wifi connect <SSID> password <PASSWORD>
Device 'wlan0' successfully activate with '27xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'.
$
```

> <span style="color:green">5. 安裝 VNC - 參考 Jetson Nano 開機畫面上的 L4T-README 目錄下的 README-vnc.txt  </span>
>   - <span style="color:red">要注意的是, vnc 需要 log in 後才能執行, 需要到系統設定內去設定 automatic log in.</span>
>   - 執行下列 script 來安裝 vino （vnc 程式）及相關設定
>     - 將 'thepassword' 改成你設定的密碼, 如 'jetbot'


```
$ sudo apt update
$ sudo apt install vino

# Enable the VNC server to start each time you log in
$ mkdir -p ~/.config/autostart
$ cp /usr/share/applications/vino-server.desktop ~/.config/autostart

# Configure the VNC server
$ gsettings set org.gnome.Vino prompt-enabled false
$ gsettings set org.gnome.Vino require-encryption false

# Set a password to access the VNC server
# Replace thepassword with your desired password
$ gsettings set org.gnome.Vino authentication-methods "['vnc']"
$ gsettings set org.gnome.Vino vnc-password $(echo -n 'thepassword'|base64)
$

```

> <span style="color:green">6. 修改 /etc/X11/xorg.conf, 將下列設定加於檔案最後  </span>
>    - 解析度的 1280 800 是最佳設定, 調整成其它解析度後, 無法在 Mac 上看到完整螢幕, 需要上下調整, 反而不方便

```
Section "Screen"
   Identifier   "Default Screen"
   Monitor      "Configured Monitor"
   Device       "Tegra0"
   SubSection "Display"
       depth    24
       virtual 1280 800
   EndSubSection
EndSection
```

> <span style="color:green">7. GPIO (40 PIN expansion header) 設定  </span>
>   - 根據官網 [Configuring the 40-pin Expansion Header](https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3231/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/hw_setup_jetson_io.html), 執行以下指令來設定硬體
>   - 參考中文說明 [第一次用Jetson nano 就上手 - 使用40 pin GPIO](https://www.rs-online.com/designspark/jetson-nano-40-pin-gpio-cn)
>   - 選擇 Configure 40-pin Expansion Header, 設定相關的腳位（若沒把握, 就全選）, 再選擇 Save and reboot to reconfigure pins. 重新開機後.

```
$ sudo /opt/nvidia/jetson-io/jetson-io.py
$
```
> <span style="color:green">8. 安裝 jtop  </span>
> 在 Jetson 中有一個非常好用的工具就是 jtop，可以同時查看 CPU 資源與 GPU 資源，另外也可以看目前 CPU 與 GPU 的溫度與功耗，另外他還有貼心的服務，就是將你目前的 library show 出來。

```
$ sudo apt-get install python-pip python-dev build-essential 
$ sudo -H pip install jetson-stats
$ sudo jtop
$
```

> <span style="color:green">9. 重新開機後, 先到 Jetbot 的 LED 上查看 wlan 的 IP 位址, 我查到的是 192.168.1.16   </span>

> <span style="color:green">10. 到 PC 或 Mac 的 browers, 打開 http://jetbot_ip_address:8888 (我的例子就是 http://192.169.1.16:8888). 或者是直接在 Jetbot 上執行, 需要進入 jetbot 的 GUI 模式, 打開 browser, 輸入 http://localhost:8888  </span>  



> <span style="color:green">11. Create Linux OS disk SWAP, refer to [the link](https://chtseng.wordpress.com/2019/05/01/nvida-jetson-nano-%E5%88%9D%E9%AB%94%E9%A9%97%EF%BC%9A%E5%AE%89%E8%A3%9D%E8%88%87%E6%B8%AC%E8%A9%A6/) 執行以下指令  </span>

```
# 理想的SWAP size應是RAM的二倍，但由於SD空間不是很充裕，先設定 4G 或 8G SWAP。
$ sudo fallocate -l 8G /swapfile
$ sudo chmod 600 /swapfile
$ ls -lh /swapfile

# 建立並啟用SWAP
$ sudo mkswap /swapfile
$ sudo swapon /swapfile
$ sudo swapon –show

# 輸入free -h確認已經有 4G 或 8G SWAP空間了
free –h

# 由於重開機後SWAP設定便會跑掉，因此，把SWAP加到fstab設定檔中。
$ sudo cp /etc/fstab /etc/fstab.bak
$ echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

```

## <span style="color:blue">專案啟動</span>

#### <span style="color:red">從 JetPack 4.4.1 （Jetbot 0.4.2) 得支援 2GB 版本, 因此 remove 不少套件, 而且從 command line 開機, 因此, 即使我們用的是 4GB 版本, 還是得安裝許多套件 </span>   

> <span style="color:green">1. Install Jetbot </span>

```
$ sudo apt update
$ sudo apt install libffi-dev python3-pip
$ sudo pip3 install ipywidgets
$ sudo pip3 install traitlets  # package already satified
$ cd ~/jetbot
$ sudo python3 setup.py install

```

> <span style="color:green">2. Install Pytorch in order to run jetbot module, the instrution can be refer to https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048. for latest version </span>  

```
$ sudo apt-get install libopenblas-base libopenmpi-dev 
$ pip3 install Cython
$ wget https://nvidia.box.com/shared/static/9eptse6jyly1ggt9axbja2yrmj6pbarc.whl -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl
$ pip3 install numpy torch-1.7.0-cp36-cp36m-linux_aarch64.whl

```

> <span style="color:green">3. CUDA 環境設定, 參考[JKJung JetPack-4.4 for Jetson Nano](https://jkjung-avt.github.io/jetpack-4.4/) 建議的 Basic set-up 的  ./install_basics.sh  </span>

```
$ git clone https://github.com/jkjung-avt/jetson_nano.git
$ cd jetson_nano
$ ./install_basics.sh
$ source ${HOME}/.bashrc
$
```

> 或是自行設定 

```
# If you used the Jetson Nano SD card image, then yes, it already has the CUDA Toolkit installed. Check under /usr/local/cuda to verify that it’s there.

# Check that your ~/.bashrc file has these lines at the end, and if not, add them and restart your terminal:

export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

```
> <span style="color:green">4. Making sure python3 “cv2” is working</span>

```
# Install dependencies for python3 "cv2"
$ sudo apt-get update
$ sudo apt-get install -y build-essential make cmake cmake-curses-gui \
                          git g++ pkg-config curl libfreetype6-dev \
                          libcanberra-gtk-module libcanberra-gtk3-module
$ sudo apt-get install -y python3-dev python3-testresources python3-pip
$ sudo pip3 install -U pip Cython
$ git clone https://github.com/jkjung-avt/jetson_nano.git
$ cd ${HOME}/jetson_nano
$ ./install_protobuf-3.8.0.sh    # will take hours to complete the installation
$ sudo apt-get install protobuf-compiler libprotoc-dev
$ sudo pip3 install numpy matplotlib==3.2.2


# 測試 Then I tested my tegra-cam.py script with a USB webcam, and made sure the python3 “cv2” module could capture and display images properly.
# Test tegra-cam.py (using a USB webcam)
$ cd ~
$ wget https://gist.githubusercontent.com/jkjung-avt/86b60a7723b97da19f7bfa3cb7d2690e/raw/3dd82662f6b4584c58ba81ecba93dd6f52c3366c/tegra-cam.py
# 如果是用 CSI camera
$ python3 tegra-cam.py --vid 0
# 如果是用 USB camera
$ python3 tegra-cam.py --usb --vid 0

```

> <span style="color:green">5. Installing tensorflow-1.15.2  </span> NVIDIA has provided pip wheel files for both tensorflow-1.15.2 and tensorflow-2.2.0 (link). I used 1.15.2 since my TensorRT Demo #3: SSD only works for tensorflow-1.x.

```
$ sudo apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
$ sudo pip3 install -U pip testresources setuptools
$ sudo pip3 install -U numpy==1.16.1 future mock h5py==2.10.0 keras_preprocessing keras_applications gast==0.2.2 futures pybind11
$ sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==1.15.2
```



## <span style="color:blue">Car Deploying
參考 https://github.com/jkjung-avt/tensorrt_demos Demo #5: YOLOv4 步驟執行以下指令  </span>

```
# Clone tennsorrt_demo
$ cd ~
$ git clone https://github.com/jkjung-avt/tensorrt_demos

# 1.1 Install "pycuda". Note that the installation script resides in the "ssd" folder.
$ cd ${HOME}/tensorrt_demos/ssd
$ ./install_pycuda.sh

# 1.2 Install version "1.4.1" (not the latest version) of python3 "onnx" module. Note that the "onnx" module would depend on "protobuf" as stated in the Prerequisite section. Reference: information provided by NVIDIA.
$ sudo apt-get install protobuf-compiler libprotoc-dev # already the newest version
$ sudo pip3 install onnx==1.4.1

# 1.3 Go to the "plugins/" subdirectory and build the "yolo_layer" plugin. When done, a "libyolo_layer.so" would be generated.

$ cd ${HOME}/tensorrt_demos/plugins
$ make
```


## <span style="color:blue">model training 訓練模型及模型轉換  </span>
> 參考 [JK Jung 的 github ](https://github.com/jkjung-avt/yolov4_crowdhuman) 的 training on Google Colab, 及注意事項 blog [TensorRT YOLOv3 For Custom Trained Models](https://jkjung-avt.github.io/trt-yolov3-custom/)
>    - 注意檔案命名, 檔案名稱需要包含 yolov4-416 字樣, 如 yolov4-my-416.weights 跟 yolov4-my-416.cfg 或 yolov4-416.weights 跟 yolov4-416.cfg

> - 1-1. 在 Google Colab 執行 'darknet_on_colab.ipynb' 
>   - 上傳 github <span style="color:green">[darknet_on_colab.ipynb](https://github.com/marconi1964/jetbot_yolov4/blob/master/darknet_on_colab.ipynb) </span> 到 colab
>    - remember to change runtime type to 'GPU'
>    - 儲存模型 yolov4_my_final.weights (darknet 儲存於 /content/darknet/backup/) 跟 yolov4_my.cfg (darknet 儲存於 /content/darknet/cfg/) 到 Jetson Nano 的 ${HOME}/tensorrt_demos/yolo 下, 並改名為 yolov4-416.weights 跟 yolov4-416.cfg

> - 1-2. 如果是在 Server 上執行, 參考 [README_CUDA_installation.md](https://github.com/marconi1964/jetbot_yolov4/blob/master/README_CUDA_installation.md) 跟 [README_training_on_server.md](https://github.com/marconi1964/jetbot_yolov4/blob/master/README_training_on_server.md)
>   - 執行以下指令

```
$ git clone https://github.com/marconi1964/jetbot_yolov4.git
$ cd jetbot_yolov4
$ ./server_darknet_setup.sh        # don't use $ sudo ./server_darknet_setup.sh 應為這樣會安裝 darknet 在 /root 下
$ ./server_darknet.sh
```
> 2. <span style="color:green">Model translation from to onnx to tensorrt </span>

```
$ cd ${HOME}/tensorrt_demos/yolo
# 將訓練模型的結果下載到此目錄下 
$ python3 yolo_to_onnx.py -c 4 -m yolov4-416           # 我們的 catergory 有 4 個, 需要設定 -c 4 
$ python3 onnx_to_tensorrt.py -v -c 4 -m yolov4-416    # 此轉檔需要一段時間, 打開 -v 可以看到進度

```

## <span style="color:blue">開跑  </span>
> 1. 下載 [github - jetbot_yolov4](https://github.com/marconi1964/jetbot_yolov4)
> 2. 將 main.py copy 到 tensorrt_demos
> 3. 執行 python3 jetbot_main.py

```
$ cd ~
$ git clone https://github.com/marconi1964/jetbot_yolov4.git
$ cp ${HOME}/jetbot_yolov4/main.py ${HOME}/tensorrt_demos
$ cd ${HOME}/tensorrt_demos
$ python3 jetbot_main.py
```



------------------
## Reference
- JK Jung / Inventec
    - [PPT - Applications of Real-time Object Detection on NVIDIA Jetson TX2](https://on-demand.gputechconf.com/gtc-taiwan/2018/pdf/1-7_General%20Speaker_Inventec_PDF%20For%20Sharing.pdf)
    - Github : https://github.com/jkjung-avt/
    - Github : [Training a DarkNet YOLOv4 model for custimized dataset](https://github.com/jkjung-avt/yolov4_crowdhuman)
    - Blog : https://jkjung-avt.github.io/
    - Blog : [TensorRT YOLOv3 For Custom Trained Models](https://jkjung-avt.github.io/trt-yolov3-custom/)
- [Darknet - AlexeyAB](https://github.com/AlexeyAB/darknet)
- [Darknet - Pjreddie](https://pjreddie.com/darknet/yolov2/)
- 參考 [Derek 同學的 github](https://github.com/derekhsu/jetbot_yolov4)
- 寫完後, 不小心發現一篇美女寫的文章, [YOLOv4訓練教學](https://medium.com/ching-i/yolo-c49f70241aa7). 她這一篇絕對比我寫的有吸引力.
- 還有一篇類似的, 以 video 為範例的 [Implementing YOLOv4 to detect custom objects using Google Colab](https://medium.com/analytics-vidhya/implementing-yolov4-to-detect-custom-objects-using-google-colab-6691c98b15ff)
- [YOLOv4 - Ten Tactics to Build a Better Model](https://blog.roboflow.com/yolov4-tactics/)
- [How to train YOLOv4 for custom objects detection in Google Colab](https://medium.com/ai-world/how-to-train-yolov4-for-custom-objects-detection-in-google-colab-1e934b8ef685)