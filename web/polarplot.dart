part of space;

class PolarPlot {

  final double COS = Math.cos(30 * Math.PI / 180);
  final double SIN = Math.sin(30 * Math.PI / 180);

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  int dimension = 10;
  List<Action> actions;

  int _innerCircleRadius = 20;
  int _arrowHeadSize = 10;
  bool _drag = false;
  num _dragStartPointX, _dragStartPointY;


  PolarPlot(this.canvas, this.actions) {
    context = canvas.context2D;
    canvas.onMouseMove.listen(_onMouseMove);
    canvas.onMouseDown.listen(_onMouseDown);
    canvas.onMouseUp.listen(_onMouseUp);
    canvas.onMouseLeave.listen(_onMouseOut);
  }
  
  void _onMouseOut(MouseEvent e) {
    _drag=false;
  }
  
  void _onMouseDown(MouseEvent e) {
    e.preventDefault();
    _drag = true;
    e.stopPropagation();
  }
  
  void _onMouseUp(MouseEvent e) {
    e.preventDefault();
    _drag = false;
    e.stopPropagation();
  }
  
  void _onMouseMove(MouseEvent e) {

    e.preventDefault();

    if(_drag) {

    } else {

      canvas.style.cursor = "default";

    }

    draw();
    e.stopPropagation();

  }
  
  void draw() {
    
    context.clearRect(0, 0, canvas.width, canvas.height);
    
    double xc = canvas.width / 2;
    double yc = canvas.height / 2;
    _drawCircle(xc, yc, _innerCircleRadius, 1, "black");

    double axisLength = canvas.width / 2 - 10;
    double delta = 2 * Math.PI / dimension;
    for(int i = 0; i < dimension; i++){
      _drawLineWithArrowHead(xc, yc, xc + axisLength * Math.cos(delta * i), yc + axisLength * Math.sin(delta * i), 1, "black");
    }
  
    _drawTitle();

  }
  
  void _drawTitle() {
    context..font = "12px Arial Bold"
           ..fillStyle = "rgb(0, 0, 0)"
           ..fillText("$dimension-dimension", 0, 10);
  }
  
  void _drawCircle(num x, num y, num r, int weight, String color) {
    context..beginPath()
           ..lineWidth = weight
           ..strokeStyle = color
           ..arc(x, y, r, 0, 2 * Math.PI, false)
           ..stroke()
           ..closePath();    
  }

  void _drawLine(num x1, num y1, num x2, num y2, int weight, String color) {
    context..beginPath()
           ..lineWidth = weight
           ..strokeStyle = color
           ..moveTo(x1, y1)
           ..lineTo(x2, y2)
           ..stroke()
           ..closePath();
  }

  void _drawLineWithArrowHead(num x1, num y1, num x2, num y2, int weight, String color) {
    _drawLine(x1, y1, x2, y2, weight, color);
    num dx = x2 - x1;
    num dy = y2 - y1;
    double r = 1 / Math.sqrt(dx * dx + dy * dy);
    double arrowx = dx * r;
    double arrowy = dy * r;
    double wingx = _arrowHeadSize * (arrowx * COS + arrowy * SIN);
    double wingy = _arrowHeadSize * (arrowy * COS - arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, weight, color);
    wingx = _arrowHeadSize * (arrowx * COS - arrowy * SIN);
    wingy = _arrowHeadSize * (arrowy * COS + arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, weight, color);
  }

}