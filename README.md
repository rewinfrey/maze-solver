Maze Solver
===============

[Demo](http://maze-solver.rickwinfrey.com)

About
----------

Maze Solver is a visual representation of a breadth-first search strategy to solve a maze.

The following rules apply:
1. Determine if the maze is solvable
2. Determine the most efficient path

Maze-specific symbols:
1. A   = starting point
2. B   = ending point
3. '#' = boundary
4. ' ' = viable path

Any of the six mazes provided can be altered and run against the application, so long as the above mentioned symbols are used.

The application is a simple Rack-based app (Sinatra). Maze and animation logic can be found in /public/js/maze.coffee || /public/js/maze.js

License
---------

This code is MIT Licensed:

Copyright (c) 2012 Rick Winfrey

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.