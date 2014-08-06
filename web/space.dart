library space;

import 'dart:convert';
import 'dart:html';

part 'action/action.dart';
part 'action/movecamera.dart';
part 'action/editelement.dart';
part 'action/point3d.dart';
part 'action/setparameter.dart';

final RegExp whitespacePattern = new RegExp(r"(\s+)");

CanvasElement canvas = querySelector("#canvas1");
String dataFile = "energy3d.json";
List<Action> actions = new List<Action>();

final List<String> elementActions =  
["Add Wall", "Edit Wall", "Remove Wall",
 "Add Window", "Edit Window", "Remove Window",
 "Add Door", "Edit Door", "Remove Door",
 "Add PyramidRoof", "Edit PyramidRoof", "Remove PyramidRoof",
 "Add HipRoof", "Edit HipRoof", "Remove HipRoof",
 "Add CustomRoof", "Edit CustomRoof", "Remove CustomRoof",
 "Convert to Gable", 
 "Add SolarPanel", "Edit SolarPanel", "Remove SolarPanel", 
 "Add Sensor", "Edit Sensor", "Remove Sensor", 
 "Add Maple", "Edit Maple", "Remove Maple", 
 "Add Dogwood", "Edit Dogwood", "Remove Dogwood", 
 "Add Oak", "Edit Oak", "Remove Oak", 
 "Add Pine", "Edit Pine", "Remove Pine"];

final List<String> parameterActions =  ["Time", "WallUFactor", "WindowUFactor", "DoorUFactor", "RoofUFactor", "SolarPanelYield", "SHGC"];

void main() {
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

}

void _addEditElementAction(Map activity, String type) {
  if(activity.containsKey(type)) {
    Map info = activity[type];
    int buildingID = info["Building"];
    int wallID = info["ID"];
    List coordinates = info["Coordinates"];
    List<Point3D> points = new List<Point3D>();
    for(var v in coordinates) {
      points.add(new Point3D(v["x"], v["y"], v["z"]));
    }
    Action a = new EditElement(type, activity["Timestamp"], activity["File"], buildingID, wallID, points);
    actions.add(a);
    print(a.toString());
  }
}

void _addMoveCameraAction(Map activity) {
  if(activity.containsKey("Camera")) {
    Map info = activity["Camera"];
    Map pos = info["Position"];
    Point3D position = new Point3D(pos["x"], pos["y"], pos["z"]);
    Map dir = info["Direction"];
    Point3D direction = new Point3D(dir["x"], dir["y"], dir["z"]);
    Action a = new MoveCamera(activity["Timestamp"], activity["File"], position, direction);
    actions.add(a);
    print(a.toString());
  }
}

void _addSetParameterAction(Map activity, String type) {
  if(activity.containsKey(type)) {
    Action a = new SetParameter(type, activity["Timestamp"], activity["File"], activity["Time"]);
    actions.add(a);
    print(a.toString());
  }
}

void _scanActions(Map activity) {
  _addMoveCameraAction(activity);
  for(String s in elementActions) _addEditElementAction(activity, s);
  for(String s in parameterActions) _addSetParameterAction(activity, s);
}

void _doubleCheck() {
   int count = 0;
   for(Action a in actions) {
     if(a.type == "Set Time") count++;
   }
   print(count);
}

void _onDataLoaded(String responseText) {
  
  Map map = JSON.decode(responseText);

  int n = map["Activities"].length;

  for(int i = 0; i < n; i++) {
    Map activity = map["Activities"][i];
    _scanActions(activity);
  }
  
  _doubleCheck();
  
}
