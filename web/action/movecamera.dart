part of space;

class MoveCamera extends Action {
  
  Point3D position;
  Point3D direction;

  MoveCamera(String timestamp, String file, this.position, this.direction) : super("Move Camera", timestamp, file);

  String toString() {
    return super.toString() + ",  $position,  $direction";
  }

}
