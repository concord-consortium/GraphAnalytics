part of space;

class Action {

  static final int CAMERA = 0;
  static final int ADD_WALL = 1;
  static final int EDIT_WALL = 2;
  static final int ADD_HIP_ROOF = 3;

  static final int WALL_U_FACTOR = 11;
  static final int WINDOW_U_FACTOR = 12;
  static final int ROOF_U_FACTOR = 13;
  static final int DOOR_U_FACTOR = 14;

  int type;
  String timestamp;
  String file;
  String info;

  Action(this.type, this.timestamp, this.file, this.info);
  
  String toString() {
    return "$type,  $timestamp,  $file,  $info";
  }
  
}
