class Book {
  int? id;
  String name;
  DateTime createdDate;

  Book(this.name, this.createdDate);

  Book.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        createdDate = DateTime.fromMillisecondsSinceEpoch(map["createdDate"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "createdDate": createdDate.millisecondsSinceEpoch
    };
  }
}
