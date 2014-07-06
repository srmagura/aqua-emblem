import sys
import os
from collections import OrderedDict

def get_extension(fname):
    return fname.split('.')[-1]

ROOT = sys.path[0] + '/../'

languages = OrderedDict((
    ('coffee', 'CoffeeScript'), 
    ('css', 'CSS'),
    ('html', 'HTML'),
    ('py', 'Python'),
))

counts = {key: 0 for key in languages}

for root, subfolders, files in os.walk(ROOT):
    for fname in files:
        ext = get_extension(fname)

        if ext in languages:
            path = os.path.join(root, fname)
            contents = open(path).read()
            count = contents.count('\n')
            counts[ext] += count

counts['total'] = sum(counts.values()) 

for ext in languages:
    print('{}: {}'.format(languages[ext], counts[ext]))

print('\nTotal: {}'.format(counts['total']))
