import 'package:nylo_framework/nylo_framework.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Model {
  final String id;
  String email;
  String username;
  String firstName;
  String lastName;
  final DateTime createdAt;
  DateTime? updatedAt;
  DateTime? lastLoginAt;
  bool isActive;

  User({
    String? id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    this.isActive= false,
  }) : id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
