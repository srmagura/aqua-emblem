import sys
import os

ROOT = sys.path[0] + '/../'

def read_file(path):
    return open(ROOT + path).read()

def walk(path):
    path = ROOT + path
    result = []

    for root, subfolders, files in os.walk(path):
        for fname in files:
            root = root.replace(ROOT, '')
            result.append(os.path.join(root, fname))

    return result

def get_data_css():
    result = ''
    tag = '<link rel="stylesheet" type="text/css" href="{}"/>'

    for path in walk('css'):
        result += tag.format(path)

    return result

def get_data_js():
    result = ''
    tag = '<script src="{}"></script>'
    paths = read_file('html/js_paths.dat').split('\n')

    for path in paths:
        result += tag.format(path)

    return result

data = {
    'game_info': read_file('html/game_info.html'),
    'css': get_data_css(),
    'js': get_data_js()
}

template = read_file('html/template.html')
compiled = template.format(**data)

outfile = open('{}/../index.html'.format(sys.path[0]), 'w')
outfile.write(compiled)
