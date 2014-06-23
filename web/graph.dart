library graph;

import 'dart:convert';
import 'dart:html';
import 'dart:math' as Math;

part 'node.dart';

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final List<Node> nodes = new List<Node>();
final Map<String, List<String>> maps = new Map<String, List<String>>();

void main() {

  _loadData();
  
  nodes.add(new Node(200, 200, 40, 30));
  nodes.add(new Node(100, 150, 40, 30));

  for(Node n in nodes) {
    _drawNode(n);
    for(Node m in nodes) {
      if(m != n) {
        _drawVector(m, n);
      }
    }
  }
  
}

void _loadData() {
  String url = "http://127.0.0.1:3030/GraphAnalytics/web/causality.txt";
  var request = HttpRequest.getString(url).then(_onDataLoaded);
}

// print the raw json response text from the server
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
  print(maps);
}

void _drawVector(Node m, Node n) {
  
}

void _drawNode(Node n) {
  context..beginPath()
         ..lineWidth = n.lineWidth 
         ..fillStyle = n.fillStyle
         ..ellipse(n.x, n.y, n.a, n.b, 0, 0, 2 * Math.PI, false)
         ..fill()
         ..strokeStyle = n.strokeColor
         ..stroke();  
}

