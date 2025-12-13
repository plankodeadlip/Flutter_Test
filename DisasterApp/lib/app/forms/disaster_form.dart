import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '/resources/widgets/buttons/buttons.dart';

/* Disaster Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class DisasterForm extends NyFormData {
  final String? initialName;
  final String? initialDescription;

  DisasterForm({
    String? name,
    this.initialName,
    this.initialDescription,
  }) : super(name ?? "disaster");

  @override
  get init => () {
    return {
      "name": initialName ?? "",
      "description": initialDescription ?? "",
    };
  };

  @override
  fields() => [
     Field.text("name",
        validate: FormValidator(message:"Tên thảm hạo không được để trống và không ít hơn 3 kí tự")
         .notEmpty()
         .minLength(3)
         .maxLength(20),
        style: "compact",
     ),
    Field.textArea(
      "description",
      validate: FormValidator(
          message: "Mô tả không được quá dài"
      ).maxLength(500),
      style: "compact",
    ),

  ];
  
  // @override
  // Widget? get submitButton => Button.primary(text: "Submit", submitForm: (this, (data) {
  //   print(['data', data]);
  // }));
}
