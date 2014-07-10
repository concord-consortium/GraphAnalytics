library timeseries;

import 'dart:convert';
import 'dart:html';

final RegExp whitespacePattern = new RegExp(r"(\s+)");

CanvasElement canvas = querySelector("#canvas1");
String dataFile = "framelog.txt";

List<double> time = new List<double>();
List<double> temperature = new List<double>();
List<double> pressure = new List<double>();
List<double> force = new List<double>();
List<double> volume = new List<double>();
List<int> na = new List<int>();
List<int> nb = new List<int>();
List<bool> running = new List<bool>();
List<bool> showEnergy = new List<bool>();
List<bool> showTrajectory = new List<bool>();
List<bool> showVelocity = new List<bool>();
List<bool> showImpact = new List<bool>();
List<bool> showAtom = new List<bool>();
List<bool> readData = new List<bool>();
List<String> atomType = new List<String>();
List<int> runCount = new List<int>();
List<int> resetCount = new List<int>();
List<int> switchCount = new List<int>();

void main() {
  
  HttpRequest.getString(dataFile).then(_onDataLoaded);

}

void _onDataLoaded(String responseText) {
  
  // read log
  List<String> lines = new LineSplitter().convert(responseText);
  for(String s in lines) {
    List<String> t = s.split(whitespacePattern);
    time.add(double.parse(t[0]));
    temperature.add(double.parse(t[1]));
    pressure.add(double.parse(t[2]));
    force.add(double.parse(t[3]));
    volume.add(double.parse(t[4]));
    na.add(int.parse(t[5]));
    nb.add(int.parse(t[6]));
    running.add(int.parse(t[7]) == 1);
    showEnergy.add(int.parse(t[8]) == 1);
    showTrajectory.add(int.parse(t[9]) == 1);
    showVelocity.add(int.parse(t[10]) == 1);
    showImpact.add(int.parse(t[11]) == 1);
    showAtom.add(int.parse(t[12]) == 1);
    readData.add(int.parse(t[13]) == 1);
    atomType.add(t[14]);
    runCount.add(int.parse(t[15]));
    resetCount.add(int.parse(t[16]));
    switchCount.add(int.parse(t[17]));
  }
  
  print("${switchCount.length} data points");

}
