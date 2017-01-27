"""
Assemble all of the compiled JS files, CSS files, and HTML snippets
into a single webpage.
"""
import sys
import os

# Root of the project directory
ROOT = sys.path[0] + '/../'

def read_file(path):
    """
    Read a text file, given its path relative to the project root.
    """
    return open(ROOT + path).read()

def read_html(name):
    """
    Read an HTML file in the html directory, given the file name (without
    the extension.)
    """
    path = 'html/{}.html'.format(name)
    return read_file(path)

def walk(path, filter=None):
    """
    Search through a directory and its children, building a list of filenames.

    Wrapper around os.walk(). Optionally specify a function filter(), that,
    given the filename, returns True or False.
    """
    path = ROOT + path
    result = []

    for root, subfolders, files in os.walk(path):
        for fname in files:
            if filter is None or filter(fname):
                root = root.replace(ROOT, '')
                result.append(os.path.join(root, fname))

    return result

def get_css_tags():
    """
    Returns a string containing <link> tags to each of the CSS files
    in the game_css directory.
    """
    result = ''
    tag = '<link rel="stylesheet" type="text/css" href="{}"/>\n'

    for path in walk('game_css'):
        result += tag.format(path)

    return result

def get_js_tags():
    """
    Returns a string containing <script> tags to each of the JS files
    listed in html/js_paths.dat.
    """
    result = ''
    tag = '<script src="{}"></script>\n'
    paths = read_file('html/js_paths.dat').split('\n')

    for path in paths:
        if len(path.strip()) != 0:
            result += tag.format(path)

    return result

def get_img_tags():
    """
    Returns a string containing <img> tags to each of the PNG images
    in the images directory.

    All images are included in the body of the page so that they are
    preloaded. Otherwise there will be a pause in the game when a new
    image is appears.
    """

    # When searching through the image directories, only want .png files,
    # not GIMP sources (.xcf).
    def filter(fname):
        return fname[-4:] == '.png'

    result = ''
    tag = '<img src="{}" />\n'

    for path in walk('images', filter):
        result += tag.format(path)

    return result


# Dictionary of tags to be put into the page
data = {
    'css': get_css_tags(),
    'js': get_js_tags(),
    'images': get_img_tags(),
}

# List of all HTML files
html_files = (
    'game_info', 'terrain_box', 'skills_tab',
    'level_up_window', 'unit_info_window',
    'battle_stats_panel', 'skills_box',
    'unit_info_box', 'item_info_box',
    'sidebar_menus'
)

# Read the HTML files into the `data` dictionary
for name in html_files:
    data[name] = read_html(name)

# Load the overall template
template = read_file('html/template.html')

# Format the template with `data`, treating the template as a Python
# format string
compiled = template.format(**data)

outfile = open('{}/../index.html'.format(sys.path[0]), 'w')
outfile.write(compiled)
