# unshift = adds element to front of array and returns the length of the array
# shift = removes first element from array and returns that element
class Maze  
  constructor: (@maze) ->
    this.maze     = @maze.split("\n")
    this.start    = null
    this.end      = null
    this.height   = this.maze.length
    this.width    = this.maze[0].length
    this.queue    = new Queue
    this.animate  = new AnimateMaze

  solve: ->
    this.find_start()
    this.explorer()

  find_start: () ->
    for row, row_index in this.maze
      for position, col_index in row
        switch position
          when "#"
            this.animate.draw(row_index, col_index, "border")
          when " "
            this.animate.draw(row_index, col_index, "space")
          when "A"
            this.start = new Node(row_index, col_index, null, 0, "start")
            this.queue.process.unshift(this.start)
            this.animate.draw(row_index, col_index, "start")
          when "B"
            this.animate.draw(row_index, col_index, "end")
  
  explorer: ->
    #  has_found_end() && more_to_process()
    if this.has_found_end?() && this.more_to_process?()
      this.eval_current_node(this.queue.process.shift())
    else
      if this.end != null
        this.animate.draw(this.end.y, this.end.x, "end")
        this.shortest_path()
        $('#steps').html("The shortest path is #{this.end.steps} steps.")
      else
        $('#steps').html("Sorry, no solution exists. :(")
      this.animate.draw_paths()
  
  has_found_end?: ->
    this.end == null

  more_to_process?: ->
    this.queue.process.length != 0
  
  eval_current_node: (node) ->
    this.animate.history.push(new Node(node.y, node.x, node.steps, "processed"))
    #this.animate.draw_processed(node.y, node.x) if this.start != node

    #check down from current node
    if this.maze[node.y + 1].charAt(node.x) != '#' && this.not_processed(node.y + 1, node.x) && this.end == null
      this.enqueue_node( new Node(node.y + 1, node.x, node, node.steps + 1, "process") )
      this.is_end_node()

    #check up from current node
    if this.maze[node.y - 1].charAt(node.x) != '#' && this.not_processed(node.y - 1, node.x) && this.end == null
      this.enqueue_node( new Node(node.y - 1, node.x, node, node.steps + 1, "process") )
      this.is_end_node()

    #check right from current node
    if this.maze[node.y].charAt(node.x + 1) != '#' && this.not_processed(node.y, node.x + 1) && this.end == null
      this.enqueue_node( new Node(node.y, node.x + 1, node, node.steps + 1, "process") )
      this.is_end_node()

    #check left from current node
    if this.maze[node.y].charAt(node.x - 1) != '#' && this.not_processed(node.y, node.x - 1) && this.end == null
      this.enqueue_node( new Node(node.y, node.x - 1, node, node.steps + 1, "process") )
      this.is_end_node()

    this.queue.processed.push(node)
    this.explorer()

  not_processed: (y, x) ->
    not_found = true
    for node in this.queue.processed
      not_found = false if node.y == y && node.x == x
    return not_found

  enqueue_node: (node) ->
    this.animate.history.push(node)
    #this.animate.draw_process(node.y, node.x)
    this.queue.process.push(node)

  is_end_node: ->
    last_index = this.queue.process.length - 1
    last_node  = this.queue.process[last_index]
    if this.maze[last_node.y].charAt(last_node.x) == "B"
      this.end   = last_node
      this.animate.history.push(new Node(last_node.y, last_node.x, last_node.parent, last_node.steps, "end"))

  shortest_path: ->
    node = this.end
    node.state = "end"
    while node.parent != null
      this.animate.solution.push(node) # law of demeter violation
      node = node.parent

class AnimateMaze
  constructor: ->
    this.ctx      = document.getElementById("maze_solution").getContext("2d")
    this.history  = []
    this.solution = []
  
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
      when "process"
        this.ctx.clearRect(x * 20, y * 20, 20, 20)      
        this.ctx.fillStyle = "rgb(50,50,50)"
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
    
  draw_paths: ->
    if node = this.history.shift()
      this.draw(node.y, node.x, node.state)
      window.setTimeout(
        () =>
          this.draw_paths()
        ,
          25
      )
    else if node = this.solution.pop()
      if node.state != "end"
        state = "solution"
      else
        state = "end"
      this.draw(node.y, node.x, state)
      window.setTimeout(
        () =>
          this.draw_paths()
      ,
        25
      )

class Queue
  constructor: ->
    this.process    = []
    this.processed  = []

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
    load_maze(parseInt(id))
    

load_maze = (num) ->
  maze = new Maze $('textarea[maze='+num+']').val()
  maze.solve()