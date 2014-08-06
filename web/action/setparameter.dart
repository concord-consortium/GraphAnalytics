part of space;

class SetParameter extends Action {

  String parameter;

  SetParameter(String type, String timestamp, String file, this.parameter) : super(type, timestamp, file);

  String toString() {
    return super.toString() + ",  $parameter";
  }

}
