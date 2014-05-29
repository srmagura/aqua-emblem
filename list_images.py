import os
import json

paths = []

for root, subfolders, files in os.walk('images'):
    for fname in files:
        if fname[-4:] == '.png':
            paths.append(os.path.join(root, fname))

for path in paths:
    print('<img src="{}"/>'.format(path))
