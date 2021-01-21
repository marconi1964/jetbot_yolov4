#!/bin/sh
# this file is similar to "darknet_on_colab.ipynb"
# prerequite was prepared in "darknet_setup.sh"
# execution in "darknet.sh"

# check README_CUDA_installation.md and README_training_on_server.md

cd darknet
cp cfg/coco.data cfg/coco_my.data
cp cfg/coco.names cfg/coco_my.names
cp cfg/yolov4-custom.cfg cfg/yolov4_my.cfg
echo $'superman\npenguin\nlion\ncone' > data/coco_my.names
# I used previously ~/sample as the directory and caused error. Modify to absolute directory /home/USERID/sample/ and works
echo $'classes=4\ntrain=/home/USERID/sample/train.txt\nvalid=/home/USERID/sample/test.txt\nnames=/home/USERID/darknet/data/coco_my.names\nbackup=/home/USERID/darknet/backup/\neval=coco' > data/coco_my.data

# settings for darknet traning
sed -i "s/max_batches = 500500/max_batches=8000/g" ~/darknet/cfg/yolov4_my.cfg
sed -i "s/steps=400000,450000/steps=6400,7200/g" ~/darknet/cfg/yolov4_my.cfg
sed -i "s/classes=80/classes=4/g" ~/darknet/cfg/yolov4_my.cfg
sed -i "s/filters=255/filters=27/g" ~/darknet/cfg/yolov4_my.cfg
sed -i "s/width=608/width=416/g" ~/darknet/cfg/yolov4_my.cfg
sed -i "s/height=608/height=416/g" ~/darknet/cfg/yolov4_my.cfg

# Download tag'ed image files from 
cd ~
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yf4clDi07G_DMF0Jfh9ZZVp-E7L3KFkJ' -O Object_11_20.rar
unar -o sample/ Object_11_20.rar
mkdir sample/train
mkdir sample/test

# do labelme2coco in Python3
cp jetbot_yolov4/darknet/darknet.py ~/
python3 darknet.py

sed -i "s/sample\/train\///g" ~/sample/train.json
sed -i "s/sample\/test\///g" ~/sample/test.json

cd convert2Yolo
python3 example.py --datasets COCO --img_path ~/sample/Object_11_20/ --label ~/sample/train.json --convert_output_path ~/sample/Object_11_20/ --img_type ".JPG" --manifest_path ./ --cls_list_file ~/darknet/data/coco_my.names
mv manifest.txt ~/sample/train.txt

python3 example.py --datasets COCO --img_path ~/sample/Object_11_20/ --label ~/sample/test.json --convert_output_path ~/sample/Object_11_20/ --img_type ".JPG" --manifest_path ./ --cls_list_file ~/darknet/data/coco_my.names
mv manifest.txt ~/sample/test.txt


cd ~/darknet
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137

./darknet detector train data/coco_my.data cfg/yolov4_my.cfg yolov4.conv.137 -dont_show -gpus 0    # remove -map to work, remove other for display on the screen
#./darknet detector train data/coco_my.data cfg/yolov4_my.cfg yolov4.conv.137 -dont_show -gpus 0 -map | tee -a trainRecord.txt > myprogram.out 2>&1

