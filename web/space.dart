library space;

import 'dart:convert';
import 'dart:html';

part 'action/action.dart';
part 'action/editelement.dart';
part 'action/point3d.dart';

final RegExp whitespacePattern = new RegExp(r"(\s+)");

CanvasElement canvas = querySelector("#canvas1");
String dataFile = "energy3d.json";
List<Action> actions = new List<Action>();

void main() {
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

}

void _addEditElementAction(Map activity, String type) {
  if(activity.containsKey(type)) {
    Map info = activity[type];
    int buildingID = info["Building"];
    int wallID = info["ID"];
    List coordinates = info["Coordinates"];
    List points = new List();
    for(var v in coordinates) {
      points.add(new Point3D(v["x"], v["y"], v["z"]));
    }
    Action a = new EditElement(type, activity["Timestamp"], activity["File"], buildingID, wallID, points);
    actions.add(a);
    print(a.toString());
  }
}

void _scanAllEditElementActions(Map activity) {
  _addEditElementAction(activity, "Add Wall");
  _addEditElementAction(activity, "Edit Wall");
  _addEditElementAction(activity, "Add Window");
  _addEditElementAction(activity, "Edit Window");
  _addEditElementAction(activity, "Add Door");
  _addEditElementAction(activity, "Edit Door");
  _addEditElementAction(activity, "Add HipRoof");
  _addEditElementAction(activity, "Edit HipRoof");
  _addEditElementAction(activity, "Convert to Gable");
  _addEditElementAction(activity, "Add SolarPanel");
  _addEditElementAction(activity, "Edit SolarPanel");
}

void _doubleCheck() {
   int count = 0;
   for(Action a in actions) {
     if(a.type == "Edit Wall") count++;
   }
   print(count);
}

void _onDataLoaded(String responseText) {
  
  Map map = JSON.decode(responseText);

  int n = map["Activities"].length;

  for(int i = 0; i < n; i++) {
    Map activity = map["Activities"][i];
    _scanAllEditElementActions(activity);
  }
  
}
