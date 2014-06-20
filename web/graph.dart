library graph;

import 'dart:html';
import 'dart:math' as Math;

part 'node.dart';

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final List<Node> nodes = new List<Node>();

void main() {

  nodes.add(new Node(200, 200, 40, 30));
  nodes.add(new Node(100, 150, 40, 30));

  for(Node n in nodes) {
    _drawNode(n);
    for(Node m in nodes) {
      if(m!=n) {
        _drawVector(m, n);
      }
    }
  }
  
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

