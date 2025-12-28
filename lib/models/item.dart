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

  Map<String, dynamic> toMap() => {
    'name': name,
    'desc': desc,
    'num': num,
    'isFound': isFound,
  };

  factory Item.fromMap(Map<String, dynamic> map) => Item(
    name: map['name'],
    desc: map['desc'],
    num: map['num'],
    isFound: map['isFound'],
  );
}
