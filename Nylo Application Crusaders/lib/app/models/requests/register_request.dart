import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest extends Model {
  final String email;
  final String username;
  final String password;
  String firstName;
  String lastName;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
