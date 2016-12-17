#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import argparse
import math
from jinja2 import Template
from jinja2 import Environment, FileSystemLoader
import shutil 
import os


# Capture our current directory
THIS_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    """
    Когда изменяеться файл, я получаю полный путь к нему, получаю папку в которой он находиться
    если папка совпадает с DESCRIPTORS тогда базовое имя беру как имя файла vrd без разширения
    если файл находиться в подпаке, тогда базовое имя считаю имя подпаки. 
    определяю путь относительно /var/www/ куда необходимо скопировать файл
    копирую файлы и рендерю из шаблона config файл и записываю его с имененм подпапки в /etc/apache-sites/enabled...
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--path',  type=str,  help="changed path")
    parser.add_argument('-r', '--render', type=str, help="base path to render")
    parser.add_argument('-o', '--output', type=str, help="output file name")
    parser.add_argument('-e', '--event', type=str, help="event type modified/created/deleted")
    parser.add_argument('-d', '--descriptors', type=str, help="descriptor catalog")
    
    args = parser.parse_args()
    
    print(args.__dict__)
    generate(**args.__dict__)
    try:
        generate(**args.__dict__)
    except IOError as ex:
        print(ex)
        exit(1)
        
def generate(path=None, event=None, output=None, render=None, descriptors=None):
    print(path)
    assert path, "Path is emty "+path
    assert output, "output is emty "+output
    output = os.path.abspath(output)
    render = os.path.abspath(render)
    if event == None: 
        evnet = "modified"
        
    basename = "";
    basepath = os.getenv("DESCRIPTORS", descriptors)
    print(basepath)
    if basepath == None:
        raise("Base path is empty")
    if basepath == os.path.dirname(path):
        basename = os.path.splitext(os.path.basename(path))[0]
    else:
        basename = os.path.basename(os.path.dirname(path))
    newdir = os.path.join(output, basename)
    vrdpath = os.path.join(newdir, "default.vrd")
      
    filename = os.path.basename(path)
    if os.path.exists(newdir):
        shutil.rmtree(newdir)
        os.makedirs(newdir)
        if event == "deleted":
            return
    else:
        os.makedirs(newdir)
    shutil.copyfile(path, vrdpath)
    newrender = os.path.join(render, "{}.conf".format(basename))
    
    j2_env = Environment(loader=FileSystemLoader(THIS_DIR),
                         trim_blocks=True)
    
    text = j2_env.get_template('site.conf.template').render(
        dir_path=newdir, vrd_path=vrdpath, id=basename
    )
    with open(newrender, "w") as f:
        f.write(text)
    print("Deployng '{}' to '{}' config is {}".format(path, vrdpath, newrender))
    
    
if __name__=="__main__":
    main()