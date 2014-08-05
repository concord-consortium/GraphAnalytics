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
final HtmlElement classStudentNumberElement = querySelector("#class_students");
final HtmlElement selectedStudentNumberElement = querySelector("#selected_students");
final RadioButtonInputElement edgeCountRadioButton = querySelector("#count");
final RadioButtonInputElement edgeVerbRadioButton = querySelector("#verb");
final RadioButtonInputElement edgeNoneRadioButton = querySelector("#none");

final List<Node> _nodes = new List<Node>();
final Map<String, List<String>> maps = new Map<String, List<String>>();

final List<CanvasElement> canvases = new List<CanvasElement>();
final List<Graph> graphes = new List<Graph>();
final List<String> selectedStudents = new List<String>();

String dataFile = "causality.txt";
int radius = 30;
int drawAttributes = 0;

void main() {

  for(int i = 0; i < 4; i++)
    canvases.add(querySelector("#canvas" + (i+1).toString()));

  int w = canvases[0].width;
  int h = canvases[0].height;
  int dx = w~/8;
  int dy = h~/8;
  radius = Math.max(dx, dy).toInt()~/2;
  _nodes.add(new Node("Cause", w~/2, dy, ""));
  _nodes.add(new Node("A", w~/2-dx*2, dy*2, "Average kinetic energy of molecules"));
  _nodes.add(new Node("B", w~/2-dx*3, dy*4, "Frequency of molecule-piston collisions"));
  _nodes.add(new Node("C", w~/2-dx*2, dy*6, "Average speed of molecules"));
  _nodes.add(new Node("D", w~/2+dx*2, dy*2, "Mass of molecules"));
  _nodes.add(new Node("E", w~/2+dx*3, dy*4, "Total impact of molecules on piston"));
  _nodes.add(new Node("F", w~/2+dx*2, dy*6, "Average impact of a single molecule on piston"));
  _nodes.add(new Node("G", w~/2, dy*4, "Number of molecules"));
  _nodes.add(new Node("Effect", w~/2, h-dy, ""));
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

  _addClass("B");
  _addClass("D");
  _addClass("E");

  classMenu.onChange.listen((e) {
    selectedStudents.clear();
    for(Graph g in graphes) 
       g.setClassID(classMenu.value);
    _populateStudentMenu(classMenu.value);
    _redrawAllGraphs();
  });

  studentMenu.onChange.listen((e) {
    selectedStudents.clear();
    for(OptionElement o in studentMenu.selectedOptions)
      selectedStudents.add(o.value);
    selectedStudentNumberElement.innerHtml = selectedStudents.length.toString() + " selected";
    _redrawAllGraphs();
  });
  
  edgeCountRadioButton.onClick.listen((e) {
    drawAttributes = int.parse(edgeCountRadioButton.value);
    _redrawAllGraphs();
  });

  edgeVerbRadioButton.onClick.listen((e) {
    drawAttributes = int.parse(edgeVerbRadioButton.value);
    _redrawAllGraphs();
  });

  edgeNoneRadioButton.onClick.listen((e) {
    drawAttributes = int.parse(edgeNoneRadioButton.value);
    _redrawAllGraphs();
  });

}

void _addClass(String id) {
  OptionElement oe = new OptionElement();
  oe.text = "Class " + id;
  oe.value =id;
  classMenu.append(oe); 
}


bool _addStudent(String id, bool selected) {
  for(OptionElement e in studentMenu.childNodes) {
    if(e.value == id) return false;    
  }
  OptionElement oe = new OptionElement();
  oe.text = "Student " + id;
  oe.value = id;
  oe.selected = selected;
  studentMenu.append(oe);
  selectedStudents.add(id);
  return true;
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
  int studentCount = 0;
  for(String key in keys) {
    if(key.startsWith(classID)) {
      int i  = key.indexOf("_");
      if(_addStudent(key.substring(0, i), true)) studentCount++;
    }
  }
  classStudentNumberElement.innerHtml = studentCount.toString() + " students";
  selectedStudentNumberElement.innerHtml = selectedStudents.length.toString() + " selected";
}

void _redrawAllGraphs() {
  for(Graph g in graphes)
    g.draw();
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

  for(int i = 0; i < 4; i++) {
    Graph g = new Graph(canvases[i], "Graph" + (i+1).toString(), classID);
    g.copyNodes(_nodes);
    g.draw();
    graphes.add(g);
  }
  
}