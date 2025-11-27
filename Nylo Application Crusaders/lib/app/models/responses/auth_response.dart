import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';
import '../user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends Model {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  User get user => data.user;

  String get token => data.accessToken;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// New Model for data object
@JsonSerializable()
  class AuthData extends Model {
  final User user;
  final String accessToken;
  final String? refreshToken;

  AuthData({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}