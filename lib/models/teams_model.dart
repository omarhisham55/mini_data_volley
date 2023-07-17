class TeamModel {
  late String id;
  late String name;
  late String image;
  late String color;
  late String level;

  TeamModel({
    required this.id,
    required this.color,
    required this.name,
    required this.image,
    required this.level,
  });

  TeamModel.fromJSON(Map<String, dynamic> json, {String? id}) {
    this.id = id.toString();
    name = json['name'];
    image = json['image'];
    color = json['color'];
    level = json['level'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'color': color,
      'level': level,
    };
  }
}
