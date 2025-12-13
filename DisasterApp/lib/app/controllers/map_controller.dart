import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '../../data_import_service.dart';
import '../../helpers/db_helper.dart';
import '../models/disaster_image.dart';
import '/app/controllers/controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/app/models/disaster_type.dart';
import 'package:flutter_app/app/models/disaster.dart';

class MapController extends Controller {
  LatLng? selectedPoint;
  List<DisasterType> disasterTypes = [];
  List<Disaster> disasters = [];
  bool isLoading = false;
  Disaster? selectedDisaster;

  int? filterTypeId;
  String? searchQuery;

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
    await filterDisasters(typeId: filterTypeId, search: searchQuery);
  }

// Phương thức cập nhật bộ lọc và tải lại dữ liệu
  Future<void> filterDisasters({int? typeId, String? search}) async {
    isLoading = true;
    updateState('map_loading');

    filterTypeId = typeId;
    searchQuery = search;

    try {
      final data = await DBHelper().getDisastersFilterd(
        typeId: filterTypeId,
        searchName: searchQuery,
        orderBy: 'updated_at',
        ascending: false,
      );
      disasters = data.map((map) => Disaster.fromMap(map)).toList();
      print('✅ [MAP] Loaded ${disasters.length} filtered disasters');
    } catch (e) {
      print('❌ Error filtering disasters: $e');
    }

    isLoading = false;
    updateState('map_loading');
  }

  // ================== LOCATION SELECTION ==================

  void selectLocation(LatLng point) {
    selectedPoint = point;
    updateState('map_point_selected');
  }

  void clearSelection() {
    selectedPoint = null;
    updateState('map_point_cleared');
  }

  // ================== CRUD METHODS ==================

  Future<bool> createDisaster({
    required String name,
    required String description,
    required int typeId,
    List<String>? imagePaths,
  }) async {
    if (selectedPoint == null) {
      print('❌ [MAP] No location selected');
      return false;
    }

    try {
      final now = DateTime.now();

      final disasterData = {
        'name': name,
        'description': description,
        'typeId': typeId,
        'lat': selectedPoint!.latitude,
        'lon': selectedPoint!.longitude,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      // ✅ Sử dụng transaction từ DB Helper
      await DBHelper().createDisasterTransaction(
        disasterRow: disasterData,
        imagePaths: imagePaths ?? [],
      );

      clearSelection();
      await loadDisasters();

      print('✅ [MAP] Created disaster: $name');
      return true;
    } catch (e) {
      print('❌ [MAP] Error creating disaster: $e');
      return false;
    }
  }

  // Bổ sung các tham số liên quan đến ảnh
  Future<bool> updateDisaster({
    required int id,
    required String name,
    required String description,
    required int typeId,
    List<String>? newImagePaths,
    List<int>? imageIdsToRemove,
  }) async {
    try {
      final disasterData = {
        'name': name,
        'description': description,
        'typeId': typeId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // ✅ Sử dụng transaction từ DB Helper (đã tích hợp xóa ảnh)
      final success = await DBHelper().updateDisasterTransaction(
        disasterId: id,
        disasterRow: disasterData,
        newImagePaths: newImagePaths ?? [],
        imageIdsToRemove: imageIdsToRemove ?? [],
      );

      if (success) {
        await loadDisasters();
        print('✅ [MAP] Updated disaster: $name');
      }

      return success;
    } catch (e) {
      print('❌ [MAP] Error updating disaster: $e');
      return false;
    }
  }

  Future<bool> deleteDisaster(int id) async {
    try {
      await DBHelper().deleteDisaster(id);
      print('✅ [MAP] Deleted disaster ID: $id');
      await loadDisasters();
      return true;
    } catch (e) {
      print('❌ [MAP] Error deleting disaster: $e');
      return false;
    }
  }

  // ================== HELPER METHODS ==================

  DisasterType? getDisasterType(int typeId) {
    try {
      return disasterTypes.firstWhere((t) => t.id == typeId);
    } catch (e) {
      return null;
    }
  }

  // Bổ sung phương thức để lấy chi tiết một thảm họa
  Future<Disaster?> loadDisasterDetails(int id) async { // Đổi tên phương thức để rõ ràng hơn
    try {
      final Map<String, dynamic>? result = await DBHelper().getDisasterById(id);

      selectedDisaster = null; // Reset trước khi load

      if (result != null) {
        final disaster = Disaster.fromMap(result);

        // Lấy danh sách ảnh
        final List<DisasterImage> images = await DBHelper().getDisasterImagesModel(id);

        // Gán ảnh vào model
        final disasterWithImages = disaster.copyWith(images: images);

        // ⭐️ CẬP NHẬT TRẠNG THÁI:
        selectedDisaster = disasterWithImages;

        print('✅ [MAP] Loaded disaster details: ${disaster.name} with ${images.length} images');

        // Cập nhật state nếu cần thiết
        updateState('disaster_details_loaded');

        return disasterWithImages;
      }

      updateState('disaster_details_loaded'); // Cập nhật state ngay cả khi null
      return null;
    } catch (e) {
      print('❌ [MAP] Error getting disaster details: $e');
      updateState('disaster_details_loaded');
      return null;
    }
  }
  // ================== GETTERS ==================
  bool get hasSelectedPoint => selectedPoint != null;
  bool get hasDisasters => disasters.isNotEmpty;
  bool get hasDisasterTypes => disasterTypes.isNotEmpty;
}

