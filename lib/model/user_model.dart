class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;

  UserModel({this.id, this.name, this.email,  this.password,this.role});

  // تحويل كائن User إلى خريطة بيانات (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // إنشاء كائن User من خريطة بيانات
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
