class Item {
  String name;
  String desc;
  String num;
  String? imagePath;
  bool isFound;

  Item({
    required this.name,
    required this.desc,
    required this.num,
    this.imagePath,
    this.isFound = false,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'desc': desc,
    'num': num,
    'imagePath': imagePath,
    'isFound': isFound,
  };

  factory Item.fromMap(Map<String, dynamic> map) => Item(
    name: map['name'],
    desc: map['desc'],
    num: map['num'],
    imagePath: map['imagePath'],
    isFound: map['isFound'],
  );
}
