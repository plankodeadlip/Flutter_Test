
import 'package:flutter/services.dart';
import 'dart:convert';
import 'helpers/db_helper.dart';

class DataImportService {
  static final DataImportService _instance = DataImportService._internal();
  factory DataImportService() => _instance;
  DataImportService._internal();

  /// Import disaster types từ JSON vào database
  Future<bool> importDisasterTypes() async {
    try {
      print('📥 Starting import disaster types...');

      // 1. Check nếu đã import rồi thì skip
      bool alreadyImported = await DBHelper().isDisasterTypesImported();
      if (alreadyImported) {
        print('✅ Disaster types already imported, skipping...');
        return true;
      }

      // 2. Load JSON file từ assets
      String jsonString = await rootBundle.loadString('assets/data/disasters_type.json');
      print('📄 Loaded JSON file');
      List<dynamic> jsonData = json.decode(jsonString);

      // 3. Import vào database
      await DBHelper().importDisasterTypesFromJson(jsonString);
      print('✅ Successfully imported disaster types');

      int count = await _getCount();

      return true;
    } catch (e) {
      print('❌ Error importing disaster types: $e');
      return false;
    }
  }

  /// Force re-import (xóa dữ liệu cũ và import lại)
  Future<bool> forceReimportDisasterTypes() async {
    try {
      print('🔄 Force re-importing disaster types...');

      // 1. Clear old data
      final db = await DBHelper().database;
      int deleted = await db.delete('disaster_types');
      print('🗑️ [REIMPORT] Deleted $deleted old records');

      // 2. Load and import
      String jsonString = await rootBundle.loadString('assets/data/disasters_type.json');
      await DBHelper().importDisasterTypesFromJson(jsonString);

      int count = await _getCount();
      print('✅ [REIMPORT] Successfully re-imported $count disaster types');
      return true;
    } catch (e) {
      print('❌ Error re-importing: $e');
      return false;
    }
  }

  /// Verify imported data
  Future<void> verifyImportedData() async {
    try {
      List<Map<String, dynamic>> types = await DBHelper().getDisasterTypes();
      print('📊 Imported ${types.length} disaster types:');
      for (var type in types) {
        String imagePreview = type['image'].toString().substring(0, 30) + '...';
        print('  ➤ ID: ${type['id']} | Name: ${type['name']} | Image: $imagePreview');      }
    } catch (e) {
      print('❌ Error verifying data: $e');
    }
  }

  Future<int> _getCount() async {
    try {
      List<Map<String, dynamic>> types = await DBHelper().getDisasterTypes();
      return types.length;
    } catch (e) {
      return 0;
    }
  }

  /// Kiểm tra xem disaster types đã được import chưa
  Future<bool> isImported() async {
    return await DBHelper().isDisasterTypesImported();
  }

  Future<List<Map<String, dynamic>>> getDisasterTypes() async {
    return await DBHelper().getDisasterTypes();
  }
}