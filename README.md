# Aqua Emblem
A web-based battle strategy game created by Sam Magura.

**Playable demo:** http://srmagura.github.io/aqua-emblem/

Aqua Emblem is written in CoffeeScript and uses jQuery. CoffeeScript compiles one-to-one into equivalent JavaScript, but has a cleaner syntax and improved object-oriented features. The game graphics are rendered in an HTML 5 canvas and the game's user interface is built with HTML and CSS.

This project demonstrates my ability to create web frontends that are functional, easy-to-use, and aesthetically-pleasing.

## Design decisions
This section discusses some problems I encountered when developing the game, and how I fixed them.

**Problem:** The main HTML file was becoming unmanageably large because of the game's many UI elements.   
**Solution:** I split up the one large file into many smaller files. `template.html` defines the overall layout of the page, and each part of the UI has its own personal HTML file. A short Python script assembles everything together into a single webpage.

**Problem:** For unit movement to work, we need to calculate the shortest path from point A to point B.   
**Solution:** This problem is equivalent to the shortest path problem for graphs, which can be solved efficiently by Dijkstra's algorithm. To see the connection, we view each tile on the map as a node in the graph, with connections between the nodes corresponding to adjacent tiles.
