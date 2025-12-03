import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '../../data_import_service.dart';
import '../../helpers/db_helper.dart';
import '/app/controllers/controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/app/models/disaster_type.dart';
import 'package:flutter_app/app/models/disaster.dart';

class MapController extends Controller {
  LatLng? selectedPoint;
  List<DisasterType> disasterTypes = [];
  List<Disaster> disasters = [];
  bool isLoading = false;

  construct(BuildContext context) async {
    super.construct(context);
    await initialize(); // Gọi hàm logic khởi tạo
  }

  Future<void> initialize() async {
    isLoading = true;
    updateState('map_loading');

    await _ensureDataImported();
    await loadDisasterTypes();
    await loadDisasters();

    isLoading = false;
    updateState('map_loading');
  }

  Future<void> _ensureDataImported() async {
    bool imported = await DBHelper().isDisasterTypesImported();
    if (!imported) {
      print('⚠️ [MAP] Importing disaster types...');
      await DataImportService().importDisasterTypes();
    }
  }

  Future<void> loadDisasterTypes() async {
    try {
      final data = await DBHelper().getDisasterTypes();
      disasterTypes = data.map((map) => DisasterType.fromMap(map)).toList();
      print('✅ Loaded ${disasterTypes.length} disaster types');
    } catch (e) {
      print('❌ Error loading disaster types: $e');
    }
  }

  Future<void> loadDisasters() async {
    try {
      final data = await DBHelper().getDisastersWithType();
      disasters = data.map((map) => Disaster.fromMap(map)).toList();
      print('✅ [MAP] Loaded ${disasters.length} disasters');
    } catch (e) {
      print('Error loading disasters: $e');
    }
  }

  void selectLocation(LatLng point) {
    selectedPoint = point;
    updateState('map_point_selected');
  }

  void clearSelection() {
    selectedPoint = null;
    updateState('map_point_cleared');
  }

  // --- CRUD METHODS ---

  Future<bool> createDisaster({
    required String name,
    required String description,
    required int typeId,
    List<String>? imagePaths,
  })  async {
    if (selectedPoint == null) {
      print('❌ [MAP] No location selected');
      return false;
    }

    try {
      final now = DateTime.now();

      final disasterId = await DBHelper().insertDisaster({
        'name': name,
        'description': description,
        'type_id': typeId,
        'lat': selectedPoint!.latitude,
        'lon': selectedPoint!.longitude,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });

      // Insert images if provided
      if (imagePaths != null && imagePaths.isNotEmpty) {
        await DBHelper().insertDisasterImages(disasterId, imagePaths);
      }

      // Reload disasters list
      await loadDisasters();
      clearSelection();

      print('✅ [MAP] Created disaster: $name');
      return true;
    } catch (e) {
      print('❌ [MAP] Error creating disaster: $e');
      return false;
    }
  }

  Future<bool> updateDisaster({
    required int id,
    required String name,
    required String description,
    required int typeId,
  }) async {
    try {
      await DBHelper().updateDisaster(id, {
        'name': name,
        'description': description,
        'type_id': typeId,
        'updated_at': DateTime.now().toIso8601String(),
      });
      await loadDisasters();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDisaster(int id) async {
    try {
      await DBHelper().deleteDisaster(id);
      await loadDisasters();
      return true;
    } catch (e) {
      return false;
    }
  }

  String getDisasterTypeName(int typeId) {
    try {
      final type = disasterTypes.firstWhere((t) => t.id == typeId);
      return type.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get disaster type by ID
  DisasterType? getDisasterType(int typeId) {
    try {
      return disasterTypes.firstWhere((t) => t.id == typeId);
    } catch (e) {
      return null;
    }
  }

  // Getters for easy access
  bool get hasSelectedPoint => selectedPoint != null;
  bool get hasDisasters => disasters.isNotEmpty;
  bool get hasDisasterTypes => disasterTypes.isNotEmpty;
}

