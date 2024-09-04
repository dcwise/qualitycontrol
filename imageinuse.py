import os
import shutil
from xml.etree import ElementTree as ET
from tkinter import Tk
from tkinter.filedialog import askopenfilename

# 弹出文件选择对话框，选择 .ditamap 文件
root = Tk()
root.withdraw()  # 隐藏主窗口
ditamap_file = askopenfilename(title="选择一个 .ditamap 文件", filetypes=[("DITA Map Files", "*.ditamap")])

if not ditamap_file:
    print("没有选择任何文件，程序退出。")
    exit(1)

# 定义文件和文件夹路径
dita_output_folder = 'dita_files'
image_output_folder = 'images_files'
images_folder = os.path.join(os.getcwd(), 'images')

# 创建输出文件夹，如果不存在则创建
if not os.path.exists(dita_output_folder):
    os.makedirs(dita_output_folder)

if not os.path.exists(image_output_folder):
    os.makedirs(image_output_folder)

# 解析 .ditamap 文件
try:
    tree = ET.parse(ditamap_file)
    root = tree.getroot()
except ET.ParseError as e:
    print(f"解析 .ditamap 文件时出错: {e}")
    exit(1)

# 提取所有 .dita 文件名称（不考虑命名空间）
dita_files = []
for elem in root.iter('topicref'):
    href = elem.get('href')
    if href and href.endswith('.dita'):
        dita_files.append(href)

# 复制 .dita 文件到新的文件夹中
for dita_file in dita_files:
    if os.path.exists(dita_file):
        shutil.copy(dita_file, dita_output_folder)
    else:
        print(f"文件 {dita_file} 不存在，跳过。")

print(f"提取了 {len(dita_files)} 个 .dita 文件到 '{dita_output_folder}' 文件夹中。")

# 用于存储所有提取到的图片文件名（不含扩展名）
image_files = set()

# 遍历所有提取的 .dita 文件，提取图片文件名
for dita_file in dita_files:
    dita_file_path = os.path.join(dita_output_folder, dita_file)
    try:
        tree = ET.parse(dita_file_path)
        root = tree.getroot()
        
        for elem in root.iter('image'):
            href = elem.get('href')
            if href and href.startswith('images/'):
                image_name = os.path.splitext(os.path.basename(href))[0]  # 获取文件名（无扩展名）
                image_files.add(image_name)
    except ET.ParseError as e:
        print(f"解析文件 {dita_file} 时出错: {e}")

# 复制所有相关的图片文件到新的文件夹中
for image_file in image_files:
    jpg_file = os.path.join(images_folder, f"{image_file}.jpg")
    eps_file = os.path.join(images_folder, f"{image_file}.ep
