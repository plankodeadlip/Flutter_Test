import 'package:nylo_framework/nylo_framework.dart';

class Disaster extends Model {
  final int? id;
  final String name;
  final String description;
  final typeId;
  final double lon;
  final double lat;
  final DateTime createAt;
  final DateTime updateAt;

  // JOIN ELEMENT
  final String? typeName;
  final String? typeImage;
  final List<String>? imagePaths;

  Disaster({
    this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.lon,
    required this.lat,
    required this.createAt,
    required this.updateAt,
    this.typeName,
    this.typeImage,
    this.imagePaths,
  });

  factory Disaster.fromMap(Map<String, dynamic> map) {
    return Disaster(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      typeId: map['type_id'] as int,
      lon: map['lon'] as double,
      lat: map['lat'] as double,
      createAt: DateTime.parse(map['created_at'] as String),
      updateAt: DateTime.parse(map['updated_at'] as String),
      // Thông tin từ JOIN query
      typeName: map['type_name'] as String?,
      typeImage: map['type_image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // Chỉ thêm id nếu đã tồn tại
      'name': name,
      'description': description,
      'type_id': typeId,
      'lon': lon,
      'lat': lat,
      'created_at': createAt.toIso8601String(),
      'updated_at': updateAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type_id': typeId,
      'lon': lon,
      'lat': lat,
      'created_at': createAt.toIso8601String(),
      'updated_at': updateAt.toIso8601String(),
      if (typeName != null) 'type_name': typeName,
      if (typeImage != null) 'type_image': typeImage,
      if (imagePaths != null) 'image_paths': imagePaths,
    };
  }

  @override
  String toString() {
    return 'Disaster{id: $id, name: $name, type: $typeName}';
  }

  Disaster copyWith({
    int? id,
    String? name,
    String? description,
    int? typeId,
    double? lon,
    double? lat,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? typeName,
    String? typeImage,
    List<String>? imagePaths,
  }) {
    return Disaster(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      typeId: typeId ?? this.typeId,
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
      createAt: createdAt ?? this.createAt,
      updateAt: updatedAt ?? this.updateAt,
      typeName: typeName ?? this.typeName,
      typeImage: typeImage ?? this.typeImage,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }

  static fromJson(data) {}


}
