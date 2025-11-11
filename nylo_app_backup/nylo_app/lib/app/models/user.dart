import 'package:flutter_app/app/models/post.dart';
import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  final int id;
  String? name;
  String? username;
  String? email;
  String? address;

  User({
     required this.id,
     this.name,
     this.username,
     this.email,
     this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    final rawName = json['name']?.toString().trim();
    final rawUserName = json['username']?.toString().trim();
    final rawEmail = json['email']?.toString().trim();
    final rawAddress = json['address']?.toString().trim();

    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (rawName != null && rawName.isNotEmpty)
          ? rawName
          : '(Không có tên)',
      username: (rawUserName != null && rawUserName.isNotEmpty)
          ? rawUserName
          : '(Không có tên)',
      email: (rawEmail != null && rawEmail.isNotEmpty)
          ? rawEmail
          : '(Không có tên)',
      address: (rawAddress != null && rawAddress.isNotEmpty)
          ? rawAddress
          : '(Không có tên)',
    );

  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username":username,
    "email": email,
    "address": address,
  };

  @override
  String toString() {
    return 'User{id: $id, name: $name, userName: $username, email: $username, address: $address}';
  }


}
