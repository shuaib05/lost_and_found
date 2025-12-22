class Item {
  String name;
  String desc;
  String num;
  bool isFound;
  Item({
    required this.name,
    required this.desc,
    required this.num,
    this.isFound = false,
  });
}
