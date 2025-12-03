import 'package:nylo_framework/nylo_framework.dart';

class DisasterType extends Model {

  final int id;
  final String name;
  final String image;

  DisasterType({
    required this.id,
    required this.name,
    required this.image
  });

  factory DisasterType.fromMap(Map<String, dynamic> map) {
    return DisasterType(
        id: map['id'] as int,
        name: map['name'] as String,
        image: map['image'] as String,
    );
  }

  factory DisasterType.fromJson(Map<String, dynamic> json) {
    return DisasterType(
      id: json['id'] as int,
      name: json['name_disaster'] as String, // Khác tên trong JSON
      image: json['image'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_disaster': name,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'DisasterType{id: $id, name: $name}';
  }

  // Copy with method để tạo bản sao với giá trị mới
  DisasterType copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return DisasterType(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
