part of graph;

class Node {

  String name;
  int x = 0;
  int y = 0;
  String description;

  Node(this.name, this.x, this.y, this.description);
  
  void set(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  int distanceSq(int x1, int y1) {
    return (x - x1) * (x - x1) + (y - y1) * (y - y1);
  }
  
  String toString() {
    return "(" + name + ": " + x.toString() + ", " + y.toString() + ")";
  }

}
