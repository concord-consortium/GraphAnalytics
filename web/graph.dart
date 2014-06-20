library graph;

import 'dart:html';
import 'dart:math' as Math;

part 'node.dart';

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final List<Node> nodes = new List<Node>();

void main() {
  nodes.add(new Node(20, 20, 20, 20));
  for(Node n in nodes){
    _drawNode(n);
  }
}

void _drawNode(Node n) {
  context..lineWidth = n.lineWidth
         ..fillStyle = n.fillStyle
         ..fillRect(n.boundBox.left, n.boundBox.top, n.boundBox.width, n.boundBox.height)
         ..strokeStyle = n.strokeColor
         ..strokeRect(n.boundBox.left, n.boundBox.top, n.boundBox.width, n.boundBox.height);  
}

