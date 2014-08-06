part of space;

class EditElement extends Action {
  
  int buildingID;
  int elementID;
  List<Point3D> coordinates;

  EditElement(String type, String timestamp, String file, this.buildingID, this.elementID, this.coordinates) : super(type, timestamp, file);

  String toString() {
    return super.toString() + ",  $buildingID,  $elementID,  $coordinates";
  }

}
