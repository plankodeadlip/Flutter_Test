import 'package:json_annotation/json_annotation.dart';

part 'success_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SuccessResponse<T> {
  final bool success;
  final String message;
  final T? data;

  SuccessResponse({required this.success, required this.message, this.data});

  factory SuccessResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      SuccessResponse<T>(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? fromJsonT(json['data']) : null,
      );

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
    'success': success,
    'message': message,
    'data': data != null ? toJsonT(data!) : null,
  };
}
