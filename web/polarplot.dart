part of space;

class PolarPlot {

  final double COS = Math.cos(30 * Math.PI / 180);
  final double SIN = Math.sin(30 * Math.PI / 180);

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  int dimension = 10;
  List<Action> actions;

  double _symbolSize = 2.0;
  int _innerCircleRadius = 30;
  int _arrowHeadSize = 10;
  bool _drag = false;
  num _dragStartPointX, _dragStartPointY;
  Map<String, int> _actionMap;


  PolarPlot(this.canvas, this.actions) {
    _analyzeActions();
    context = canvas.context2D;
    canvas.onMouseMove.listen(_onMouseMove);
    canvas.onMouseDown.listen(_onMouseDown);
    canvas.onMouseUp.listen(_onMouseUp);
    canvas.onMouseLeave.listen(_onMouseOut);
  }
  
  void _analyzeActions() {
    _actionMap = new Map<String, int>();
    for(Action a in actions) {
      if(_actionMap.containsKey(a.type)) {
        _actionMap[a.type] ++;        
      } else {
        _actionMap.putIfAbsent(a.type, ()=>1);
      }
    }
    dimension = _actionMap.length;
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
    double angle;
    for(int i = 0; i < dimension; i++) {
      angle = i * delta;
      _drawLineWithArrowHead(xc, yc, xc + axisLength * Math.cos(angle), yc + axisLength * Math.sin(angle), 1, "black", i);
    }

    context.translate(xc, yc);
    for(int i = 0; i < dimension; i++) {
      angle = i * delta;
      context..save()
             ..rotate(angle)
             ..font = "8pt Arial"
             ..textAlign = "left"
             ..fillText(_actionMap.keys.elementAt(i), _innerCircleRadius + 100, -4)
             ..restore();
    }
    context.translate(-xc, -yc);

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

  void _drawLineWithArrowHead(num x1, num y1, num x2, num y2, int weight, String color, int index) {

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
    
    int n = _actionMap.values.elementAt(index);
    double p = 2 * _symbolSize + 1;
    for(int i = 0; i < n; i++) {
      double q = _innerCircleRadius + (i + 1) * p;
      _drawCircle(x1 + q * arrowx, y1 + q * arrowy, _symbolSize, 1, "black");
    }
    
  }

}