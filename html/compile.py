import sys
import os

ROOT = sys.path[0] + '/../'

def read_file(path):
    return open(ROOT + path).read()

def read_html(name):
    path = 'html/{}.html'.format(name)
    return read_file(path)

def walk(path, filter=None):
    path = ROOT + path
    result = []

    for root, subfolders, files in os.walk(path):
        for fname in files:
            if filter is None or filter(fname):
                root = root.replace(ROOT, '')
                result.append(os.path.join(root, fname))

    return result

def get_data_css():
    result = ''
    tag = '<link rel="stylesheet" type="text/css" href="{}"/>\n'

    for path in walk('game_css'):
        result += tag.format(path)

    return result

def get_data_js():
    result = ''
    tag = '<script src="{}"></script>\n'
    paths = read_file('html/js_paths.dat').split('\n')

    for path in paths:
        if len(path.strip()) != 0:
            result += tag.format(path)

    return result

def get_data_images():
    def filter(fname):
        return fname[-4:] == '.png'

    result = ''
    tag = '<img src="{}" />\n'

    for path in walk('images', filter):
        result += tag.format(path)

    return result

data = {
    'css': get_data_css(),
    'js': get_data_js(),
    'images': get_data_images(),
}

html_files = (
    'game_info', 'terrain_box', 'skills_tab',
    'level_up_window', 'unit_info_window',
    'battle_stats_panel', 'skills_box',
    'unit_info_box', 'vn', 'item_info_box',
    'sidebar_menus'
)

for name in html_files:
    data[name] = read_html(name)

template = read_file('html/template.html')
compiled = template.format(**data)

outfile = open('{}/../index.html'.format(sys.path[0]), 'w')
outfile.write(compiled)
