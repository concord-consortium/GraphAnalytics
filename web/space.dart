library space;

import 'dart:convert';
import 'dart:html';

final RegExp whitespacePattern = new RegExp(r"(\s+)");

CanvasElement canvas = querySelector("#canvas1");
String dataFile = "energy3d.json";

void main() {
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

}

void _onDataLoaded(String responseText) {
  
  Map map = JSON.decode(responseText);

  int n = map["Activities"].length;
  
  print(n);
  
  
}
