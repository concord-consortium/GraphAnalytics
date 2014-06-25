library graph;

import 'dart:convert';
import 'dart:html';
import 'dart:math' as Math;

part 'edge.dart';
part 'node.dart';

final double COS = Math.cos(30*Math.PI/180);
final double SIN = Math.sin(30*Math.PI/180);
final int radius = 30;

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final List<Node> nodes = new List<Node>();
final List<Edge> edges = new List<Edge>();
final Map<String, List<String>> maps = new Map<String, List<String>>();

void main() {

  String url = "http://127.0.0.1:3030/GraphAnalytics/web/causality.txt";
  var request = HttpRequest.getString(url).then(_onDataLoaded);

  nodes.add(new Node("Cause",canvas.width~/2, 100));
  nodes.add(new Node("A",canvas.width~/2-200, 200));
  nodes.add(new Node("B",canvas.width~/2-200, 300));
  nodes.add(new Node("C",canvas.width~/2-200, 400));
  nodes.add(new Node("D",canvas.width~/2+200, 200));
  nodes.add(new Node("E",canvas.width~/2+200, 300));
  nodes.add(new Node("F",canvas.width~/2+200, 400));
  nodes.add(new Node("G",canvas.width~/2, 300));
  nodes.add(new Node("Effect",canvas.width~/2, 500));
  
}

void _onDataLoaded(String responseText) {
  List<String> lines = new LineSplitter().convert(responseText);
  String name = null;
  List<String> data = new List<String>();
  for(String s in lines) {
    if(s.indexOf("_Graph") != -1) {
      if(name != null) {
        List<String> data2 = new List<String>();
        data2.addAll(data);
        maps.putIfAbsent(name, () => data2);
      }
      name = s.trim();
      print(name);
      data.clear();
    } else {
      data.add(s.trim());
    }
  }
  _drawNodes();
  _draw("B5b_Graph4");
}

void _drawNodes() {
  for(Node n in nodes) {
    if(n.name.length > 1) 
      _drawEndPoint(n);
    else 
      _drawNode(n);
  }
}

void _draw(String key) {
  
  List<String> data = maps[key];
  
  for(String s in data) {
    List<String> list = s.split(' ');
    if(list[0].trim() == "N") continue;
    if(list[1].trim() == "N") continue;
    Node a = getNode(list[0].trim());
    Node b = getNode(list[1].trim());
    if(a == null || b == null) throw new Exception("non-existent node");
    edges.add(new Edge(a, b));
  }

  for(Edge e in edges)
    _drawEdge(e);

}

Node getNode(String name) {
  for(Node n in nodes) {
    if(n.name == name) return n;
  }
  return null;
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
  int dx = e.b.x - e.a.x;
  int dy = e.b.y - e.a.y;
  double r = 1 / Math.sqrt(dx * dx + dy * dy);
  double arrowx = dx * r;
  double arrowy = dy * r;
  double x1 = e.a.x + radius * arrowx;
  double y1 = e.a.y + radius * arrowy;
  double x2 = e.b.x - radius * arrowx ;
  double y2 = e.b.y - radius * arrowy;
  _drawLine(x1, y1, x2, y2);
  r = 10.0;
  double wingx = r * (arrowx * COS + arrowy * SIN);
  double wingy = r * (arrowy * COS - arrowx * SIN);
  _drawLine(x2, y2, x2 - wingx, y2 - wingy);
  wingx = r * (arrowx * COS - arrowy * SIN);
  wingy = r * (arrowy * COS + arrowx * SIN);
  _drawLine(x2, y2, x2 - wingx, y2 - wingy);
}

void _drawLine(num x1, num y1, num x2, num y2) {
  context..beginPath()
         ..moveTo(x1, y1)
         ..lineTo(x2, y2)
         ..stroke()
         ..closePath();  
}