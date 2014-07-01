library graph;

import 'dart:convert';
import 'dart:html';
import 'dart:math' as Math;

part 'edge.dart';
part 'graph.dart';
part 'node.dart';

// global variables

final SelectElement classMenu = querySelector("#classID");
final SelectElement studentMenu = querySelector("#studentID");
final CanvasElement canvas1 = querySelector("#canvas1");
final CanvasElement canvas2 = querySelector("#canvas2");
final CanvasElement canvas3 = querySelector("#canvas3");
final CanvasElement canvas4 = querySelector("#canvas4");
final List<Node> nodes = new List<Node>();
final Map<String, List<String>> maps = new Map<String, List<String>>();
final Map<String, List<Edge>> correctPaths = new Map<String, List<Edge>>();

Graph graph1;
Graph graph2;
Graph graph3;
Graph graph4;

String dataFile = "causality.txt";
int radius = 30;
bool drawAttributes = true;

void main() {
  
  int w = canvas1.width;
  int h = canvas1.height;
  int dx = w~/8;
  int dy = h~/8;
  radius = Math.max(dx, dy).toInt()~/2;
  nodes.add(new Node("Cause", w~/2, dy, ""));
  nodes.add(new Node("A", w~/2-dx*2, dy*2, "Average kinetic energy of molecules"));
  nodes.add(new Node("B", w~/2-dx*3, dy*4, "Frequency of molecule-piston collisions"));
  nodes.add(new Node("C", w~/2-dx*2, dy*6, "Average speed of molecules"));
  nodes.add(new Node("D", w~/2+dx*2, dy*2, "Mass of molecules"));
  nodes.add(new Node("E", w~/2+dx*3, dy*4, "Total impact of molecules on piston"));
  nodes.add(new Node("F", w~/2+dx*2, dy*6, "Average impact of a single molecule on piston"));
  nodes.add(new Node("G", w~/2, dy*4, "Number of molecules"));
  nodes.add(new Node("Effect", w~/2, h-dy, ""));
  
  List<Edge> list = new List<Edge>();
  list.add(new Edge(getNode("Cause"), getNode("B"), 2));
  list.add(new Edge(getNode("B"), getNode("E"), 2));
  list.add(new Edge(getNode("E"), getNode("Effect"), 2));
  correctPaths["Graph1"] = list;
  
  list = new List<Edge>();
  list.add(new Edge(getNode("Cause"), getNode("B"), 2));
  list.add(new Edge(getNode("B"), getNode("E"), 2));
  list.add(new Edge(getNode("E"), getNode("Effect"), 2));
  correctPaths["Graph2"] = list;
  
  list = new List<Edge>();
  list.add(new Edge(getNode("Cause"), getNode("B"), 0));
  list.add(new Edge(getNode("B"), getNode("E"), 0));
  list.add(new Edge(getNode("E"), getNode("Effect"), 0));
  correctPaths["Graph3"] = list;
  
  list = new List<Edge>();
  list.add(new Edge(getNode("Cause"), getNode("A"), 2));
  list.add(new Edge(getNode("A"), getNode("C"), 2));
  list.add(new Edge(getNode("C"), getNode("B"), 2));
  list.add(new Edge(getNode("C"), getNode("F"), 2));
  list.add(new Edge(getNode("B"), getNode("E"), 2));
  list.add(new Edge(getNode("F"), getNode("E"), 2));
  list.add(new Edge(getNode("E"), getNode("Effect"), 2));
  correctPaths["Graph4"] = list;
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

  _addClass("B");
  _addClass("D");
  _addClass("E");

  classMenu.onChange.listen((e) {
    String classID = classMenu.value;
    graph1.setClassID(classID);
    graph2.setClassID(classID);
    graph3.setClassID(classID);
    graph4.setClassID(classID);
    _populateStudentMenu(classID);
  });

}

void _addClass(String id) {
  OptionElement oe = new OptionElement();
  oe.text = "Class " + id;
  oe.value =id;
  classMenu.append(oe); 
}


void _addStudent(String id, bool selected) {
  for(OptionElement e in studentMenu.childNodes) {
    if(e.value == id) return;    
  }
  OptionElement oe = new OptionElement();
  oe.text = "Student " + id;
  oe.value = id;
  oe.selected = selected;
  studentMenu.append(oe); 
}

void _populateStudentMenu(String classID) {
  studentMenu.nodes.clear();
  List keys = maps.keys.toList()..sort((x, y) {
    int i  = x.indexOf("_");
    int j  = y.indexOf("_");
    i = int.parse(x.substring(1, i - 1));
    j = int.parse(y.substring(1, j - 1));
    return i.compareTo(j);
  });
  for(String key in keys) {
    if(key.startsWith(classID)) {
      int i  = key.indexOf("_");
      _addStudent(key.substring(0, i), true);
    }
  }
}

Node getNode(String name) {
  for(Node n in nodes) {
    if(n.name == name) return n;
  }
  return null;
}

void _onDataLoaded(String responseText) {
  
  // read student data
  List<String> lines = new LineSplitter().convert(responseText);
  String name = null;
  List<String> data = new List<String>();
  for(String s in lines) {
    if(s.indexOf("_Graph") != -1) {
      if(name != null) {
        List<String> data2 = new List<String>();
        data2.addAll(data);
        maps[name] = data2;
      }
      name = s.trim();
      // print(name);
      data.clear();
    } else {
      data.add(s.trim());
    }
  }
  
  String classID = classMenu.value;
  _populateStudentMenu(classID);
  
  graph1 = new Graph(canvas1, "Graph1", classID);
  graph2 = new Graph(canvas2, "Graph2", classID);
  graph3 = new Graph(canvas3, "Graph3", classID);
  graph4 = new Graph(canvas4, "Graph4", classID);
  
  graph1.draw();
  graph2.draw();
  graph3.draw();
  graph4.draw();
  
}