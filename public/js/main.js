// Generated by CoffeeScript 1.3.3
(function() {
  var AnimateMaze, Maze, Node, load_maze, maze_select;

  Maze = (function() {

    function Maze(maze) {
      this.maze = maze;
      this.maze = this.maze.split("\n");
      this.start = null;
      this.end = null;
      this.to_process = [];
      this.processed = [];
      this.history = [];
      this.solution = [];
      this.finished = false;
    }

    Maze.prototype.solve = function() {
      this.find_start();
      return this.explorer();
    };

    Maze.prototype.find_start = function() {
      var col_index, position, row, row_index, _i, _len, _ref, _results;
      _ref = this.maze;
      _results = [];
      for (row_index = _i = 0, _len = _ref.length; _i < _len; row_index = ++_i) {
        row = _ref[row_index];
        _results.push((function() {
          var _j, _len1, _results1;
          _results1 = [];
          for (col_index = _j = 0, _len1 = row.length; _j < _len1; col_index = ++_j) {
            position = row[col_index];
            if (position === "A") {
              this.start = new Node(row_index, col_index, null, 0, "start");
              _results1.push(this.to_process.unshift(this.start));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Maze.prototype.explorer = function() {
      if (this.hasnt_found_end() && this.more_to_process()) {
        return this.eval_current_node(this.to_process.shift());
      } else {
        return this.find_shortest_path();
      }
    };

    Maze.prototype.hasnt_found_end = function() {
      return this.end === null;
    };

    Maze.prototype.more_to_process = function() {
      return this.to_process.length !== 0;
    };

    Maze.prototype.eval_current_node = function(node) {
      if (node.state !== "start") {
        node.state = "processed";
      }
      this.history.push(node);
      this.processed.push(node);
      if (this.maze[node.y + 1].charAt(node.x) !== '#' && this.not_processed(node.y + 1, node.x) && this.not_to_process(node.y + 1, node.x) && this.end === null) {
        this.enqueue_node(new Node(node.y + 1, node.x, node, node.steps + 1, "to_process"));
        this.is_end_node();
      }
      if (this.maze[node.y - 1].charAt(node.x) !== '#' && this.not_processed(node.y - 1, node.x) && this.not_to_process(node.y - 1, node.x) && this.end === null) {
        this.enqueue_node(new Node(node.y - 1, node.x, node, node.steps + 1, "to_process"));
        this.is_end_node();
      }
      if (this.maze[node.y].charAt(node.x + 1) !== '#' && this.not_processed(node.y, node.x + 1) && this.not_to_process(node.y, node.x + 1) && this.end === null) {
        this.enqueue_node(new Node(node.y, node.x + 1, node, node.steps + 1, "to_process"));
        this.is_end_node();
      }
      if (this.maze[node.y].charAt(node.x - 1) !== '#' && this.not_processed(node.y, node.x - 1) && this.not_to_process(node.y, node.x - 1) && this.end === null) {
        this.enqueue_node(new Node(node.y, node.x - 1, node, node.steps + 1, "to_process"));
        this.is_end_node();
      }
      return this.explorer();
    };

    Maze.prototype.not_to_process = function(y, x) {
      var node, not_found, _i, _len, _ref;
      not_found = true;
      _ref = this.to_process;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if (node.y === y && node.x === x) {
          not_found = false;
        }
      }
      return not_found;
    };

    Maze.prototype.not_processed = function(y, x) {
      var node, not_found, _i, _len, _ref;
      not_found = true;
      _ref = this.processed;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if (node.y === y && node.x === x) {
          not_found = false;
        }
      }
      return not_found;
    };

    Maze.prototype.enqueue_node = function(node) {
      this.history.push(node);
      return this.to_process.push(node);
    };

    Maze.prototype.is_end_node = function() {
      var last_index, last_node;
      last_index = this.to_process.length - 1;
      last_node = this.to_process[last_index];
      if (this.maze[last_node.y].charAt(last_node.x) === "B") {
        return this.end = last_node;
      }
    };

    Maze.prototype.find_shortest_path = function() {
      var node;
      if (node = this.end) {
        node.state = "end";
        while (node.parent !== null) {
          this.solution.push(node);
          node = node.parent;
        }
        return this.solution;
      } else {
        return null;
      }
    };

    return Maze;

  })();

  AnimateMaze = (function() {

    function AnimateMaze() {
      this.ctx = document.getElementById("maze_solution").getContext("2d");
      this.steps = 0;
    }

    AnimateMaze.prototype.draw = function(y, x, element) {
      switch (element) {
        case "border":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(215,129,6)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "space":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(255,255,255)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "to_process":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(100,100,100)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "processed":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(100,100,100)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "start":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(45,123,200)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "end":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(200,45,45)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
        case "solution":
          this.ctx.clearRect(x * 20, y * 20, 20, 20);
          this.ctx.fillStyle = "rgb(153,102,255)";
          return this.ctx.fillRect(x * 20, y * 20, 20, 20);
      }
    };

    AnimateMaze.prototype.draw_history = function(history, solution) {
      var node,
        _this = this;
      if (node = history.shift()) {
        this.draw(node.y, node.x, node.state);
        return window.setTimeout(function() {
          return _this.draw_history(history, solution);
        }, 16);
      } else {
        return this.draw_solution(solution);
      }
    };

    AnimateMaze.prototype.draw_solution = function(solution) {
      var node,
        _this = this;
      if (this.steps === 0) {
        this.steps = solution.length;
      }
      if (this.steps !== 0) {
        if (node = solution.pop()) {
          if (node.state !== "end") {
            node.state = "solution";
          }
          this.draw(node.y, node.x, node.state);
          return window.setTimeout(function() {
            return _this.draw_solution(solution);
          }, 16);
        } else {
          return $('#steps').html("The shortest path is " + this.steps + " steps.");
        }
      } else {
        return $('#steps').html("Sorry, no solution exists. :(");
      }
    };

    AnimateMaze.prototype.draw_maze = function(maze) {
      var col_index, position, row, row_index, _i, _len, _results;
      _results = [];
      for (row_index = _i = 0, _len = maze.length; _i < _len; row_index = ++_i) {
        row = maze[row_index];
        _results.push((function() {
          var _j, _len1, _results1;
          _results1 = [];
          for (col_index = _j = 0, _len1 = row.length; _j < _len1; col_index = ++_j) {
            position = row[col_index];
            switch (position) {
              case "#":
                _results1.push(this.draw(row_index, col_index, "border"));
                break;
              case " ":
                _results1.push(this.draw(row_index, col_index, "space"));
                break;
              case "A":
                _results1.push(this.draw(row_index, col_index, "start"));
                break;
              case "B":
                _results1.push(this.draw(row_index, col_index, "end"));
                break;
              default:
                _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return AnimateMaze;

  })();

  Node = (function() {

    function Node(y, x, parent, steps, state) {
      this.y = y;
      this.x = x;
      this.parent = parent;
      this.steps = steps;
      this.state = state;
      this.y = this.y;
      this.x = this.x;
      this.parent = this.parent;
      this.steps = this.steps;
      this.state = this.state;
    }

    return Node;

  })();

  $(document).ready(function() {
    $('.mazes').click(function() {
      var id, maze;
      id = parseInt($(this).attr("id"));
      $('.selected').removeClass("selected");
      $(this).addClass("selected");
      maze = maze_select(id);
      return $('textarea[id="selected"]').val(maze);
    });
    return $('#solve').click(function() {
      return load_maze();
    });
  });

  load_maze = function() {
    var animate_maze, maze, maze_string;
    $('#steps').html(" ");
    maze_string = $('textarea[id="selected"]').val();
    animate_maze = new AnimateMaze;
    maze = new Maze(maze_string);
    maze.solve();
    animate_maze.draw_maze(maze.maze);
    return animate_maze.draw_history(maze.history, maze.solution);
  };

  maze_select = function(id) {
    var maze;
    switch (id) {
      case 1:
        maze = "#####################################\n# #   #     #A        #     #       #\n# # # # # # ####### # ### # ####### #\n# # #   # #         #     # #       #\n# ##### # ################# # #######\n#     # #       #   #     # #   #   #\n##### ##### ### ### # ### # # # # # #\n#   #     #   # #   #  B# # # #   # #\n# # ##### ##### # # ### # # ####### #\n# #     # #   # # #   # # # #       #\n# ### ### # # # # ##### # # # ##### #\n#   #       #   #       #     #     #\n#####################################\n";
        break;
      case 2:
        maze = "#####################################\n# #       #             #     #     #\n# ### ### # ########### ### # ##### #\n# #   # #   #   #   #   #   #       #\n# # ###A##### # # # # ### ###########\n#   #   #     #   # # #   #         #\n####### # ### ####### # ### ####### #\n#       # #   #       # #       #   #\n# ####### # # # ####### # ##### # # #\n#       # # # #   #       #   # # # #\n# ##### # # ##### ######### # ### # #\n#     #   #                 #     #B#\n#####################################\n";
        break;
      case 3:
        maze = "#####################################\n# #   #           #                 #\n# ### # ####### # # # ############# #\n#   #   #     # #   # #     #     # #\n### ##### ### ####### # ##### ### # #\n# #       # #  A  #   #       #   # #\n# ######### ##### # ####### ### ### #\n#               ###       # # # #   #\n# ### ### ####### ####### # # # # ###\n# # # #   #     #B#   #   # # #   # #\n# # # ##### ### # # # # ### # ##### #\n#   #         #     #   #           #\n#####################################\n";
        break;
      case 4:
        maze = "#####################################\n#            A                      #\n#                                   #\n#                                   #\n#                                   #\n#                                   #\n#                                   #\n#                      B            #\n#                                   #\n#                                   #\n#                                   #\n#                                   #\n#####################################\n";
        break;
      case 5:
        maze = "#####################################\n# #       #             #     #  A  #\n# ### ### # ########### ### # # ### #\n# #   # #   #   #   #   #   #       #\n# # ### ## ## # # # # ### ###########\n#   #   #     #   # # #   #         #\n####### # ### ####### # ### ####### #\n#    A  # #   #       # #       #   #\n# ####### # # # ####### # ##### # # #\n#       # # # #   #       # B # # # #\n# ##### # # ##### ######### # ### # #\n#     #   #                 #     # #\n#####################################\n";
        break;
      case 6:
        maze = "#####################################\n# #   #           #                B#\n# ### # ####### # # # ### ######### #\n#   #   #     # #   # #     #     # #\n### ##### ### ####### # ##### ### # #\n# #       # #     #   #       #   # #\n# ######### ##### # ####### ### ### #\n#   A           ###       # # # #   #\n# ### ### ####### ####### # # # # ###\n# # # #   #     # #   #   # # #   # #\n# # # ##### ### # # # # ### # ##### #\n#   #         #     #   #           #\n#####################################\n";
        break;
      default:
        maze = "#####################################\n# #   #     #A        #     #       #\n# # # # # # ####### # ### # ####### #\n# # #   # #         #     # #       #\n# ##### # ################# # #######\n#     # #       #   #     # #   #   #\n##### ##### ### ### # ### # # # # # #\n#   #     #   # #   #  B# # # #   # #\n# # ##### ##### # # ### # # ####### #\n# #     # #   # # #   # # # #       #\n# ### ### # # # # ##### # # # ##### #\n#   #       #   #       #     #     #\n#####################################\n";
    }
    return maze;
  };

}).call(this);
