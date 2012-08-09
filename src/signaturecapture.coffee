class SignatureCapture
  constructor: (canvasID, options) ->
    @canvas = document.getElementById canvasID
    @context = @canvas.getContext("2d") 
    @context.strokeStyle = options?.strokeStyle or "#000000"
    @context.lineWidth = options?.lineWidth or 1
    @lastMousePoint = x: 0, y: 0
    
    @canvas.width = @canvas.parent().innerWidth()
    @canvas.addEventListener touchstart, @onCanvasTouchStart

  onCanvasTouchStart: (e) =>
    document.addEventListener touchmove, @onCanvasTouchMove
    document.addEventListener touchend, @onCanvasTouchEnd

    @updateMousePosition e
    @updateCanvas e
  
  onCanvasTouchMove: (e) =>
    @updateCanvas e
    e.preventDefault()
    return false

  onCanvasTouchEnd: (e) =>
    document.removeEventListener touchmove, @onCanvasTouchMove
    document.removeEventListener touchend, @onCanvasTouchEnd

    @mouseMoveHandler = null
    @mouseUpHandler = null

  updateMousePosition: (e) ->
    target = e.touches[0]
    offset = @canvas.offset()
    @lastMousePoint.x = target.pageX - offset.left
    @lastMousePoint.y = target.pageY - offset.top

  updateCanvas: (e) ->
    @context.beginPath()
    @context.moveTo @lastMousePoint.x, @lastMousePoint.y
    @updateMousePosition e
    @context.lineTo @lastMousePoint.x, @lastMousePoint.y
    @context.stroke()

  toString: ->
    dataString = @canvas.toDataURL 'image/png'
    index = dataString.indexOf(',') + 1
    dataString.substring index

  clear: ->
    @context.clearRect 0, 0, @canvas.width, @canvas.height
        