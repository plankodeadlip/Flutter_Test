import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  final bool success;
  final String message;
  final List<FieldError>? errors;

  ErrorResponse({required this.success, required this.message, this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

@JsonSerializable()
class FieldError {
  final String field;
  final String message;

  FieldError({required this.field, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);
  Map<String, dynamic> toJson() => _$FieldErrorToJson(this);
}