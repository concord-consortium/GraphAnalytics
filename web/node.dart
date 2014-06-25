part of graph;

class Node {

  String name;
  int x = 0;
  int y = 0;

  Node(this.name, this.x, this.y);
  
  void set(int x, int y) {
    this.x = x;
    this.y = y;
  }

}
