from sys import argv
import shutil
import json
import os
from zipfile import ZipFile

print(os.getcwd())
print("CURRENT DIR", os.listdir())
print("TEST", os.listdir('test'))

bundle_root = argv[1]
proj_root = argv[2]

manifest = json.loads(open(f'{bundle_root}/manifest.json', 'r').read())

for entry in manifest:
    src_dir = entry['src']
    dest_dir = entry['dest']
    shutil.copytree(f'{bundle_root}/{src_dir}', 
                    f'{proj_root}/{dest_dir}')