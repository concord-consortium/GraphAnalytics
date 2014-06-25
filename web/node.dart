part of graph;

class Node {

  String name;
  int x;
  int y;
  int a;
  int b;

  Node(this.name);
  
  void set(int x, int y, int a, int b) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.b = b;
  }
  
  String fillStyle = "rgba(255, 0, 0, 0.5)";
  String strokeColor = "black";
  int lineWidth = 4;

}
