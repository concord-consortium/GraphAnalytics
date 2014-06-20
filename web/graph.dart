library graph;

import 'dart:html';
import 'dart:math' as Math;

part 'node.dart';

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final List<Node> nodes = new List<Node>();

void main() {
  nodes.add(new Node(200, 200, 40));
  nodes.add(new Node(100, 150, 40));
  for(Node n in nodes){
    _drawNode(n);
  }
}

void _drawNode(Node n) {
  context..beginPath()
         ..lineWidth = n.lineWidth 
         ..fillStyle = n.fillStyle
         ..arc(n.x, n.y, n.radius, 0, 2 * Math.PI, false)
         ..fill()
         ..strokeStyle = n.strokeColor
         ..stroke();  
}

