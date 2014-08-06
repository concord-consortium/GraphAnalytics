library space;

import 'dart:convert';
import 'dart:html';

part 'action.dart';

final RegExp whitespacePattern = new RegExp(r"(\s+)");

CanvasElement canvas = querySelector("#canvas1");
String dataFile = "energy3d.json";
List<Action> actions = new List<Action>();

void main() {
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

}

void _onDataLoaded(String responseText) {
  
  Map map = JSON.decode(responseText);

  int n = map["Activities"].length;

  for(int i = 0; i < n; i++) {
    Map x = map["Activities"][i];
    if(x.containsKey("Add Wall")) {
      Action a = new Action(Action.ADD_WALL, x["Timestamp"], x["File"], x["Add Wall"].toString());
      print(a.toString());
    }
  }
  
  
}
