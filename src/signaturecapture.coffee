class SignatureCapture
  constructor: (canvasID, options) ->
    Ti.API.log 'SignatureCapture init'
    @canvas = document.getElementById canvasID
    Ti.API.log "canvas width: #{@canvas.width}, height: #{@canvas.height}"
    @context = @canvas.getContext '2d'
    @context.strokeStyle = options?.strokeStyle or '#000000'
    @context.lineWidth = options?.lineWidth or 1
    @offset = options?.offset or left: 0, top: 0
    @lastMousePoint = x: 0, y: 0
    
    @canvas.addEventListener 'touchstart', @onCanvasTouchStart

  onCanvasTouchStart: (e) =>
    Ti.API.log 'SignatureCapture touchstart'
    document.addEventListener 'touchmove', @onCanvasTouchMove
    document.addEventListener 'touchend', @onCanvasTouchEnd

    @updateMousePosition e
    @updateCanvas e
  
  onCanvasTouchMove: (e) =>
    @updateCanvas e
    e.preventDefault()

  onCanvasTouchEnd: =>
    Ti.API.log 'SignatureCapture touchend'
    document.removeEventListener 'touchmove', @onCanvasTouchMove
    document.removeEventListener 'touchend', @onCanvasTouchEnd

  updateMousePosition: (e) ->
    target = e.touches[0]
    @lastMousePoint.x = target.pageX - @offset.left
    @lastMousePoint.y = target.pageY - @offset.top

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
    @context.clearRect 0, 0, parseInt(@canvas.width), parseInt(@canvas.height)


if this is window then this.SignatureCapture = SignatureCapture
else module?.exports = SignatureCapture
        