import os
import json

paths = []

for root, subfolders, files in os.walk('images'):
    for fname in files:
        if fname[-4:] == '.png':
            paths.append(os.path.join(root, fname))

s = 'ALL_IMAGE_PATHS = ['
for i in range(len(paths)):
    s += '"{}"'.format(paths[i])

    if i < len(paths)-1:
        s += ','

s += ']'
out = open('lib/allImagePaths.js', 'w')
out.write(s)
