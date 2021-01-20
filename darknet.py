import numpy as np
from sklearn.model_selection import train_test_split
import os

path = "sample/Object_11_20"
sample_images = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) and os.path.splitext(f)[1] == '.JPG']
sample = np.array(sample_images)
print(sample.shape)
train_sample, test_sample = train_test_split(sample, random_state=42)
print(train_sample.shape)
print(test_sample.shape)

from shutil import copyfile

for f in train_sample:
  imgname = os.path.splitext(f)[0]
  if imgname != 'IMG_1579':
    copyfile(os.path.join(path, imgname + ".JPG"), os.path.join('sample/train', imgname+".JPG"))
    copyfile(os.path.join(path, imgname + ".json"), os.path.join('sample/train', imgname+".json"))

for f in test_sample:
  imgname = os.path.splitext(f)[0]
  if imgname != 'IMG_1579':
    copyfile(os.path.join(path, imgname + ".JPG"), os.path.join('sample/test', imgname+".JPG"))
    copyfile(os.path.join(path, imgname + ".json"), os.path.join('sample/test', imgname+".json"))

# from labelme to coco
# import package
import labelme2coco

# set directory that contains labelme annotations and image files
labelme_folder = "sample/train"

# set path for coco json to be saved
save_json_path = "sample/train.json"

# convert labelme annotations to coco
labelme2coco.convert(labelme_folder, save_json_path)

# set directory that contains labelme annotations and image files
labelme_folder = "sample/test"

# set path for coco json to be saved
save_json_path = "sample/test.json"

# convert labelme annotations to coco
labelme2coco.convert(labelme_folder, save_json_path)


!sed -i "s/sample\/train\///g" ~/sample/train.json
!sed -i "s/sample\/test\///g" ~/sample/test.json