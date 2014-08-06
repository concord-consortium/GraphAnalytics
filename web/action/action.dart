part of space;

abstract class Action {

  String type;
  String timestamp;
  String file;
  
  Action(this.type, this.timestamp, this.file);
  
  String toString() {
    return "$type:  $timestamp,  $file";
  }
  
}
