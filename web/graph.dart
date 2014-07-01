part of graph;

class Graph {

  final double COS = Math.cos(30*Math.PI/180);
  final double SIN = Math.sin(30*Math.PI/180);

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  int radius = 25;
  int arrowSize = 4;
  bool drawAttributes = true;
  String classID;
  String graphID;
  Node describedNode;
  Node selectedNode;

  final List<Edge> edges = new List<Edge>();
  final List<Edge> drawnEdges = new List<Edge>();
  
  bool _drag = false;
  num _dragStartPointX, _dragStartPointY;


  Graph(this.canvas, this.graphID, this.classID) {
    context = canvas.context2D;
    canvas.onMouseMove.listen(_onMouseMove);
    canvas.onMouseDown.listen(_onMouseDown);
    canvas.onMouseUp.listen(_onMouseUp);
    canvas.onMouseLeave.listen(_onMouseOut);
  }
  
  void setClassID(String classID) {
    this.classID = classID;
  }
  
  void _onMouseOut(MouseEvent e) {
    _drag=false;
    selectedNode = null;
  }
  
  void _onMouseDown(MouseEvent e) {
    e.preventDefault();
    for(Node n in nodes) {
      if(_withinNode(e, n)) {
        selectedNode = n;
        break;
      }
    }
    _drag = true;
    Math.Point p = _getRelativePoint(e.client);
    _dragStartPointX = p.x - selectedNode.x;
    _dragStartPointY = p.y - selectedNode.y;
    e.stopPropagation();
  }
  
  void _onMouseUp(MouseEvent e) {
    e.preventDefault();
    _drag = false;
    selectedNode = null;
    e.stopPropagation();
  }
  
  void _onMouseMove(MouseEvent e) {

    e.preventDefault();

    if(_drag) {

      if(selectedNode != null) {
        canvas.style.cursor = "pointer";
        Math.Point p1 = e.client;
        if (p1.x == 0 && p1.y == 0) return;
        Math.Point p2 = _getRelativePoint(p1);
        selectedNode.set(p2.x.toInt() - _dragStartPointX.toInt(), p2.y.toInt() - _dragStartPointY.toInt());
      }    
      
    } else {

      describedNode = null;
      for(Node n in nodes) {
        if(_withinNode(e, n)) {
          describedNode = n;
          break;
        }
      }

    }

    draw();
    e.stopPropagation();

  }
  
  Math.Point _getRelativePoint(Math.Point p) {
    Math.Rectangle boundRect = canvas.getBoundingClientRect();
    return new Math.Point(p.x - boundRect.left, p.y - boundRect.top);
  }

  bool _withinNode(MouseEvent e, Node n) {
    return n.distanceSq(e.offset.x, e.offset.y) <= radius * radius;
  }

  void draw() {
    
    context.clearRect(0, 0, canvas.width, canvas.height);
    edges.clear();
    drawnEdges.clear();
  
    // draw correct path for the selected graph
    for(Edge e in correctPaths[graphID]) _drawPath(e);
  
    // draw student data
    for(String key in maps.keys) {
      if(key.startsWith(classID) && key.endsWith(graphID)) {
        String x = key.substring(0, key.indexOf("_"));
        if(selectedStudents.contains(x))
          _createEdges(key);
      }
    }

    for(Edge e in edges) _drawEdge(e);

    _drawNodes(graphID == "Graph3" || graphID == "Graph4");
    
    _drawTitle();

  }
  
  String _getDescription(Node n) {
    if(n == null) return "Class " + classID + ": " + graphID;
    if(n.name == "Cause") {
      if(graphID == "Graph1") return "Increase number of molecules";      
      if(graphID == "Graph2") return "Increase number of molecules";      
      if(graphID == "Graph3") return "Increase volume";      
      if(graphID == "Graph4") return "Increase temperature";      
    }
    if(n.name == "Effect") {
      if(graphID == "Graph1") return "Volume";
      if(graphID == "Graph2") return "Pressure";      
      if(graphID == "Graph3") return "Pressure";      
      if(graphID == "Graph4") return "Pressure";      
    }
    return n.description;     
  }

  void _drawTitle() {
    context..font = "10px Arial Bold"
           ..fillStyle = "rgb(0, 0, 0)"
           ..fillText(_getDescription(describedNode), 0, 10);
  }

  void _drawNodes(bool drawG) {
    for(Node n in nodes) {
      if(n.name.length > 1) 
        _drawEndPoint(n);
      else {
        if(n.name=="G") {
          if(drawG) _drawNode(n);
        } else {
          _drawNode(n);
        }
      }
    }
  }

  void _createEdges(String key) {
    List<String> data = maps[key];
    for(String s in data) {
      if(s=="") continue;
      List<String> list = s.split(' ');
      if(list[0].trim() == "N") continue;
      if(list[1].trim() == "N") continue;
      Node a = getNode(list[0].trim());
      Node b = getNode(list[1].trim());
      if(a == null || b == null) throw new Exception("non-existent node");
      edges.add(new Edge(a, b, list.last));
    }
  }

  int _countEdge(Edge e) {
    int count = 0;
    for(Edge x in edges) {
      if(x.a == e.a && x.b == e.b) count++;
    }
    return count;
  }

  int _countReverseEdge(Edge e) {
    int count = 0;
    for(Edge x in edges) {
      if(x.a == e.b && x.b == e.a) count++;
    }
    return count;
  }

  void _drawPath(Edge e) {
    int dx = e.b.x - e.a.x;
    int dy = e.b.y - e.a.y;
    double r = 1 / Math.sqrt(dx * dx + dy * dy);
    double arrowx = dx * r;
    double arrowy = dy * r;
    double x1 = e.a.x + radius * arrowx;
    double y1 = e.a.y + radius * arrowy;
    double x2 = e.b.x - radius * arrowx ;
    double y2 = e.b.y - radius * arrowy;
    int thickness = 20;
    String color = "rgba(200, 200, 200, 1)";
    _drawLine(x1, y1, x2, y2, thickness, color);
    r = 10.0 + thickness * 1.5;
    double wingx = r * (arrowx * COS + arrowy * SIN);
    double wingy = r * (arrowy * COS - arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, thickness~/4, color);
    wingx = r * (arrowx * COS - arrowy * SIN);
    wingy = r * (arrowy * COS + arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, thickness~/4, color);
  }

  void _drawNode(Node n) {
    context.font = "12px Arial";
    context..beginPath()
           ..lineWidth = 2 
           ..fillStyle = "red"
           ..arc(n.x, n.y, radius, 0, 2 * Math.PI)
           ..fill()
           ..strokeStyle = "black"
           ..stroke()
           ..closePath();
    double textWidth = context.measureText(n.name).width;
    context..fillStyle = "white"
           ..fillText(n.name, n.x - textWidth / 2, n.y + 6);
  }

  void _drawEndPoint(Node n) {
    context.font = "12px Arial";
    context..beginPath()
           ..lineWidth = 2 
           ..fillStyle = "yellow"
           ..arc(n.x, n.y, radius, 0, 2 * Math.PI)
           ..fill()
           ..strokeStyle = "black"
           ..stroke()
           ..closePath();
    double textWidth = context.measureText(n.name).width;
    context..fillStyle = "black"
           ..fillText(n.name, n.x - textWidth / 2, n.y + 6);
  }

  void _drawEdge(Edge e) {
    for(Edge x in drawnEdges) {
      if(x.a == e.a && x.b == e.b) return;
    }
    drawnEdges.add(e);
    int count = _countEdge(e);
    int countReverse = _countReverseEdge(e);
    int dx = e.b.x - e.a.x;
    int dy = e.b.y - e.a.y;
    double r = 1 / Math.sqrt(dx * dx + dy * dy);
    double arrowx = dx * r;
    double arrowy = dy * r;
    double x1 = e.a.x + radius * arrowx + countReverse * arrowy;
    double y1 = e.a.y + radius * arrowy - countReverse * arrowx;
    double x2 = e.b.x - radius * arrowx + countReverse * arrowy ;
    double y2 = e.b.y - radius * arrowy - countReverse * arrowx;
    String color = "black";
    _drawLine(x1, y1, x2, y2, count, color);
    if(drawAttributes) {
      context..font = "10px Arial"
             ..fillStyle = "rgb(0, 0, 0)"
             ..fillText(count.toString(), x2 - arrowx * 20 - (count + 8) * arrowy, y2 - arrowy * 20 + (count + 8) * arrowx);
    }
    r = arrowSize + count * 1.5;
    double wingx = r * (arrowx * COS + arrowy * SIN);
    double wingy = r * (arrowy * COS - arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, 1, color);
    wingx = r * (arrowx * COS - arrowy * SIN);
    wingy = r * (arrowy * COS + arrowx * SIN);
    _drawLine(x2, y2, x2 - wingx, y2 - wingy, 1, color);
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

}