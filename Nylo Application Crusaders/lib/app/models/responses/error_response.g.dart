// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errors': instance.errors,
    };

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) => FieldError(
  field: json['field'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$FieldErrorToJson(FieldError instance) =>
    <String, dynamic>{'field': instance.field, 'message': instance.message};
