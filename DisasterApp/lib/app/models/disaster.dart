import 'package:nylo_framework/nylo_framework.dart';
import 'disaster_image.dart';

class Disaster extends Model {
  final int? id;
  final String name;
  final String description;
  final int typeId;
  final double lon;
  final double lat;
  final DateTime createdAt;
  final DateTime updatedAt;

  // JOIN ELEMENTS
  final String? typeName;
  final String? typeImage;

  // Danh sách ảnh (DisasterImage objects)
  final List<DisasterImage>? images;

  Disaster({
    this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.lon,
    required this.lat,
    required this.createdAt,
    required this.updatedAt,
    this.typeName,
    this.typeImage,
    this.images,
  });

  factory Disaster.fromMap(Map<String, dynamic> map) {
    return Disaster(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      typeId: map['type_id'] as int,
      lon: map['lon'] as double,
      lat: map['lat'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      typeName: map['type_name'] as String?,
      typeImage: map['type_image'] as String?,
      images: null, // Images được load riêng
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'type_id': typeId,
      'lon': lon,
      'lat': lat,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (typeName != null) 'type_name': typeName,
      if (typeImage != null) 'type_image': typeImage,
      if (images != null) 'images': images!.map((img) => img.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Disaster{id: $id, name: $name, type: $typeName, images: ${images?.length ?? 0}}';
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
    List<DisasterImage>? images,
  }) {
    return Disaster(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      typeId: typeId ?? this.typeId,
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      typeName: typeName ?? this.typeName,
      typeImage: typeImage ?? this.typeImage,
      images: images ?? this.images,
    );
  }

  static fromJson(data) {}
}