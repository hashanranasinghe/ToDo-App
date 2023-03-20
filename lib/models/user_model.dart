class UserModel {
  String? id;
  String name;
  String email;

  UserModel({this.id, required this.name, required this.email});

  factory UserModel.fromMap(map) =>
      UserModel(id: map['id'], name: map['name'], email: map['email']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email};
}
