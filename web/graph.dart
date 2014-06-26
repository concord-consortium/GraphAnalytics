part of graph;

class Graph {

  final double COS = Math.cos(30*Math.PI/180);
  final double SIN = Math.sin(30*Math.PI/180);

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  int radius = 30;
  bool drawAttributes = true;
  String sectionID;
  String graphID;

  final List<Edge> edges = new List<Edge>();
  final List<Edge> drawnEdges = new List<Edge>();


  Graph(this.canvas, this.graphID, this.sectionID) {
    context = canvas.context2D;
  }

  void draw() {
  
    // draw correct path for the selected graph
    for(Edge e in correctPaths[graphID]) _drawPath(e);
  
    // draw student data
    for(String key in maps.keys) {
      if(key.startsWith(sectionID) && key.endsWith(graphID)) _createEdges(key);      
    }

    for(Edge e in edges) _drawEdge(e);

    _drawNodes(graphID == "Graph3" || graphID == "Graph4");

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
      if((x.a == e.a && x.b == e.b) || (x.a == e.b && x.b == e.a)) count++;
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
      if((x.a == e.a && x.b == e.b) || (x.a == e.b && x.b == e.a)) return;
    }
    drawnEdges.add(e);
    int dx = e.b.x - e.a.x;
    int dy = e.b.y - e.a.y;
    double r = 1 / Math.sqrt(dx * dx + dy * dy);
    double arrowx = dx * r;
    double arrowy = dy * r;
    double x1 = e.a.x + radius * arrowx;
    double y1 = e.a.y + radius * arrowy;
    double x2 = e.b.x - radius * arrowx ;
    double y2 = e.b.y - radius * arrowy;
    int count = _countEdge(e);
    String color = "black";
    _drawLine(x1, y1, x2, y2, count, color);
    if(drawAttributes)
      context..font = "10px Arial"
             ..fillStyle = "rgb(0, 0, 0)"
             ..fillText(count.toString(), x2 - arrowx * 20 - (count + 8) * arrowy, y2 - arrowy * 20 + (count + 8) * arrowx);
    r = 10.0 + count * 1.5;
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