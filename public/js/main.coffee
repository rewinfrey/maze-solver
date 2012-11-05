# unshift = adds element to front of array and returns the length of the array
# shift = removes first element from array and returns that element
class Maze  
  constructor: (@maze) ->
    this.maze       = @maze.split("\n")
    this.start      = null
    this.end        = null
    this.to_process = []
    this.processed  = []
    this.history    = []
    this.solution   = []
    this.finished   = false

  solve: ->
    this.find_start()
    this.explorer()

  find_start: () ->
    for row, row_index in this.maze
      for position, col_index in row
        if position == "A"
            this.start = new Node(row_index, col_index, null, 0, "start")
            this.to_process.unshift(this.start)
  
  explorer: ->
    if this.hasnt_found_end() && this.more_to_process()
      this.eval_current_node(this.to_process.shift())
    else
      this.find_shortest_path()

  hasnt_found_end: ->
    this.end == null

  more_to_process: ->
    this.to_process.length != 0
  
  eval_current_node: (node) ->
    node.state = "processed" if node.state != "start"
    this.history.push(node)
    this.processed.push(node)
    
    #check down from current node
    if this.maze[node.y + 1].charAt(node.x) != '#' && this.not_processed(node.y + 1, node.x) && this.not_to_process(node.y + 1, node.x) && this.end == null
      this.enqueue_node( new Node(node.y + 1, node.x, node, node.steps + 1, "to_process") )
      this.is_end_node()

    #check up from current node
    if this.maze[node.y - 1].charAt(node.x) != '#' && this.not_processed(node.y - 1, node.x) && this.not_to_process(node.y - 1, node.x) && this.end == null
      this.enqueue_node( new Node(node.y - 1, node.x, node, node.steps + 1, "to_process") )
      this.is_end_node()

    #check right from current node
    if this.maze[node.y].charAt(node.x + 1) != '#' && this.not_processed(node.y, node.x + 1) && this.not_to_process(node.y, node.x + 1) && this.end == null
      this.enqueue_node( new Node(node.y, node.x + 1, node, node.steps + 1, "to_process") )
      this.is_end_node()

    #check left from current node
    if this.maze[node.y].charAt(node.x - 1) != '#' && this.not_processed(node.y, node.x - 1) && this.not_to_process(node.y, node.x - 1) && this.end == null
      this.enqueue_node( new Node(node.y, node.x - 1, node, node.steps + 1, "to_process") )
      this.is_end_node()
    
    this.explorer()

  not_to_process: (y, x) ->
    not_found = true
    for node in this.to_process
      not_found = false if node.y == y && node.x == x
    return not_found

  not_processed: (y, x) ->
    not_found = true
    for node in this.processed
      not_found = false if node.y == y && node.x == x
    return not_found

  enqueue_node: (node) ->
    this.history.push(node)
    this.to_process.push(node)

  is_end_node: ->
    last_index = this.to_process.length - 1
    last_node  = this.to_process[last_index]
    if this.maze[last_node.y].charAt(last_node.x) == "B"
      this.end = last_node

  find_shortest_path: ->
    if node = this.end
      node.state = "end"
      while node.parent != null
        this.solution.push(node)
        node = node.parent
      return this.solution
    else
      return null

class AnimateMaze
  constructor: ->
    this.ctx      = document.getElementById("maze_solution").getContext("2d")
    this.steps    = 0
  
  draw: (y, x, element) ->
    switch element
      when "border"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)
        this.ctx.fillStyle = "rgb(215,129,6)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when " "
        this.ctx.clearRect(x * 20, y * 20, 20, 20)
        this.ctx.fillStyle = "rgb(1,1,1)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when "to_process"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)      
        this.ctx.fillStyle = "rgb(100,100,100)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when "processed"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)      
        this.ctx.fillStyle = "rgb(100,100,100)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when "start"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)
        this.ctx.fillStyle = "rgb(45,123,200)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when "end"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)
        this.ctx.fillStyle = "rgb(200,45,45)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
      when "solution"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)
        this.ctx.fillStyle = "rgb(153,102,255)"
        this.ctx.fillRect(x * 20, y * 20, 20, 20)
  
  # I don't have a good understanding of animation frames yet, so to keep the animation timing correct, 
  # draw_history sends the request to draw_solution when it has completed animating the search paths >.<
  draw_history: (history, solution) ->
    if node = history.shift()
      this.draw(node.y, node.x, node.state)
      window.setTimeout(
        () =>
          this.draw_history(history, solution)
        ,
          16
      )
    else
      this.draw_solution(solution)

  draw_solution: (solution) ->
    this.steps = solution.length if this.steps == 0
    if this.steps != 0
      if node = solution.pop()
        node.state = "solution" if node.state != "end"
        this.draw(node.y, node.x, node.state)
        window.setTimeout(
          () =>
            this.draw_solution(solution)
        ,
          16
        )
      else
        $('#steps').html("The shortest path is #{this.steps} steps.")
    else
      $('#steps').html("Sorry, no solution exists. :(")

  draw_maze: (maze) ->
    for row, row_index in maze
      for position, col_index in row
        switch position
          when "#"
            this.draw(row_index, col_index, "border")
          when " "
            this.draw(row_index, col_index, "space")
          when "A"
            this.draw(row_index, col_index, "start")
          when "B"
            this.draw(row_index, col_index, "end")

class Node
  constructor: (@y, @x, @parent, @steps, @state) ->
    this.y      = @y
    this.x      = @x
    this.parent = @parent
    this.steps  = @steps
    this.state  = @state

$(document).ready () ->
  $('button').click () ->
    id = $(this).attr("id")
    document.getElementById("maze_solution").getContext("2d").clearRect(0, 0, 800, 800)
    $('#steps').html(" ")
    load_maze(parseInt(id))
    

load_maze = (num) ->
  animate_maze = new AnimateMaze
  maze = new Maze $('textarea[maze='+num+']').val()
  maze.solve()
  animate_maze.draw_maze(maze.maze)
  animate_maze.draw_history(maze.history, maze.solution)