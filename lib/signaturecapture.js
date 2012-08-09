(function() {
  var SignatureCapture,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SignatureCapture = (function() {

    function SignatureCapture(canvasID, options) {
      this.onCanvasTouchEnd = __bind(this.onCanvasTouchEnd, this);
      this.onCanvasTouchMove = __bind(this.onCanvasTouchMove, this);
      this.onCanvasTouchStart = __bind(this.onCanvasTouchStart, this);      this.canvas = document.getElementById(canvasID);
      this.context = this.canvas.getContext("2d");
      this.context.strokeStyle = (options != null ? options.strokeStyle : void 0) || "#000000";
      this.context.lineWidth = (options != null ? options.lineWidth : void 0) || 1;
      this.lastMousePoint = {
        x: 0,
        y: 0
      };
      this.canvas.width = this.canvas.parent().innerWidth();
      this.canvas.addEventListener(touchstart, this.onCanvasTouchStart);
    }

    SignatureCapture.prototype.onCanvasTouchStart = function(e) {
      document.addEventListener(touchmove, this.onCanvasTouchMove);
      document.addEventListener(touchend, this.onCanvasTouchEnd);
      this.updateMousePosition(e);
      return this.updateCanvas(e);
    };

    SignatureCapture.prototype.onCanvasTouchMove = function(e) {
      this.updateCanvas(e);
      e.preventDefault();
      return false;
    };

    SignatureCapture.prototype.onCanvasTouchEnd = function(e) {
      document.removeEventListener(touchmove, this.onCanvasTouchMove);
      document.removeEventListener(touchend, this.onCanvasTouchEnd);
      this.mouseMoveHandler = null;
      return this.mouseUpHandler = null;
    };

    SignatureCapture.prototype.updateMousePosition = function(e) {
      var offset, target;
      target = e.touches[0];
      offset = this.canvas.offset();
      this.lastMousePoint.x = target.pageX - offset.left;
      return this.lastMousePoint.y = target.pageY - offset.top;
    };

    SignatureCapture.prototype.updateCanvas = function(e) {
      this.context.beginPath();
      this.context.moveTo(this.lastMousePoint.x, this.lastMousePoint.y);
      this.updateMousePosition(e);
      this.context.lineTo(this.lastMousePoint.x, this.lastMousePoint.y);
      return this.context.stroke();
    };

    SignatureCapture.prototype.toString = function() {
      var dataString, index;
      dataString = this.canvas.toDataURL('image/png');
      index = dataString.indexOf(',') + 1;
      return dataString.substring(index);
    };

    SignatureCapture.prototype.clear = function() {
      return this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
    };

    return SignatureCapture;

  })();

}).call(this);
