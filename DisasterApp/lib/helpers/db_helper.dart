import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'disaster_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    // Tạo bảng disaster_types
    await db.execute('''
      CREATE TABLE disaster_types (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');

    // Tạo bảng disasters
    await db.execute('''
      CREATE TABLE disasters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        type_id INTEGER NOT NULL,
        lon REAL NOT NULL,
        lat REAL NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(type_id) REFERENCES disaster_types(id) ON DELETE CASCADE
      )
    ''');

    // Tạo bảng disaster_images
    await db.execute('''
      CREATE TABLE disaster_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disaster_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        FOREIGN KEY(disaster_id) REFERENCES disasters(id) ON DELETE CASCADE
      )
    ''');
  }

  // --- Helpers ---
  Future<bool> isDisasterTypesImported() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM disaster_types'));
    return (count ?? 0) > 0;
  }

  // ================== DISASTER_TYPES - ONLY IMPORT & READ ==================

  /// Import disaster types từ JSON string
  /// JSON format: [{"id": 1, "name_disaster": "Lũ", "image": "base64..."}, ...]
  Future<void> importDisasterTypesFromJson(String jsonString) async {
    try {
      final db = await database;
      List<dynamic> list = json.decode(jsonString);

      await db.transaction((txn) async {
        // Xóa dữ liệu cũ trước khi import (nếu cần)
        // await txn.delete('disaster_types');

        for (var item in list) {
          await txn.insert(
            'disaster_types',
            {
              'id': item['id'],
              'name': item['name_disaster'],
              'image': item['image'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      print('✅ Imported ${list.length} disaster types');
    } catch (e) {
      print('❌ Error importing disaster types: $e');
      rethrow;
    }
  }

  /// Lấy disaster type theo ID
  Future<Map<String, dynamic>?> getDisasterTypeById(int id) async {
    try {
      final db = await database;
      final results = await db.query(
        'disaster_types',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('❌ Error getting disaster type by id: $e');
      rethrow;
    }
  }

  // ================== CRUD disasters ==================

  /// Insert disaster mới
  Future<int> insertDisaster(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('disasters', row);
  }

  /// Lấy tất cả disasters
  Future<List<Map<String, dynamic>>> getDisasters() async {
    try {
      final db = await database;
      return await db.query('disasters', orderBy: 'created_at DESC');
    } catch (e) {
      print('❌ Error getting disasters: $e');
      rethrow;
    }
  }

  /// Lấy disasters kèm thông tin disaster type (JOIN)
  Future<List<Map<String, dynamic>>> getDisastersWithType() async {
    final db = await database;
    // JOIN để lấy tên loại thảm họa hiển thị lên list/map
    return await db.rawQuery('''
      SELECT d.*, dt.name as type_name 
      FROM disasters d
      LEFT JOIN disaster_types dt ON d.type_id = dt.id
      ORDER BY d.created_at DESC
    ''');
  }

  /// Lấy disaster theo ID
  Future<Map<String, dynamic>?> getDisasterById(int id) async {
    try {
      final db = await database;
      final results = await db.rawQuery('''
        SELECT 
          d.*,
          dt.name as type_name,
          dt.image as type_image
        FROM disasters d
        LEFT JOIN disaster_types dt ON d.type_id = dt.id
        WHERE d.id = ?
        LIMIT 1
      ''', [id]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('❌ Error getting disaster by id: $e');
      rethrow;
    }
  }

  /// Lấy disasters theo type_id
  Future<List<Map<String, dynamic>>> getDisastersByType(int typeId) async {
    try {
      final db = await database;
      return await db.query(
        'disasters',
        where: 'type_id = ?',
        whereArgs: [typeId],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('❌ Error getting disasters by type: $e');
      rethrow;
    }
  }

  /// Update disaster
  Future<int> updateDisaster(int id, Map<String, dynamic> row) async {
    try {
      final db = await database;
      return await db.update(
        'disasters',
        row,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Error updating disaster: $e');
      rethrow;
    }
  }

  /// Delete disaster (sẽ tự động xóa disaster_images nhờ ON DELETE CASCADE)
  Future<int> deleteDisaster(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'disasters',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Error deleting disaster: $e');
      rethrow;
    }
  }

  //=================== FILTER AND SORT ======================

  Future<List<Map<String, dynamic>>> getDisastersFilterd({
    int? typeId,
    String? searchName,
    String orderBy = 'updated_at',
    bool ascending = false,
  }) async {
    try{
      final db = await database;

      List<String> whereConditions = [];
      List<dynamic> whereArgs =[];

      if (typeId != null){
        whereConditions.add('d.type_id  = ? ');
        whereArgs.add(typeId);
      }

      if ( searchName != null && searchName.isNotEmpty) {
        whereConditions.add('LOWER(d.name) LIKE ?');
        whereArgs.add('%${searchName.toLowerCase()}%');
      }

      String whereClause = whereConditions.isNotEmpty
      ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      // Build ORDER BY clause
      String? validOrderBy = ['updated_at', 'created_at', 'name'].contains(orderBy)
          ? orderBy
          : 'updated_at';
      String sortDirection = ascending ? 'ASC' : 'DESC';

      final query = '''
        SELECT 
          d.*,
          dt.name as type_name,
          dt.image as type_image
        FROM disasters d
        LEFT JOIN disaster_types dt ON d.type_id = dt.id
        $whereClause
        ORDER BY d.$validOrderBy $sortDirection
      ''';
      
      return await db.rawQuery(query, whereArgs);
    }catch (e){
      print('❌ Error getting filtered disasters: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> searchDisastersByName(String searchQuery) async {
    try {
      final db = await database;
      return await db.rawQuery('''
        SELECT 
          d.*,
          dt.name as type_name,
          dt.image as type_image
        FROM disasters d
        LEFT JOIN disaster_types dt ON d.type_id = dt.id
        WHERE d.name LIKE ?
        ORDER BY d.updated_at DESC
      ''', ['%$searchQuery%']);
    } catch (e) {
      print('❌ Error searching disasters: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDisastersAdvanced({
    List<int>? typeIds, // Lọc nhiều loại
    String? searchName,
    DateTime? fromDate,
    DateTime? toDate,
    String orderBy = 'updated_at',
    bool ascending = false,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await database;

      List<String> whereConditions = [];
      List<dynamic> whereArgs = [];

      // Filter by multiple type IDs
      if (typeIds != null && typeIds.isNotEmpty) {
        String placeholders = typeIds.map((_) => '?').join(',');
        whereConditions.add('d.type_id IN ($placeholders)');
        whereArgs.addAll(typeIds);
      }

      // Search by name
      if (searchName != null && searchName.isNotEmpty) {
        whereConditions.add('(d.name LIKE ? OR d.description LIKE ?)');
        whereArgs.add('%$searchName%');
        whereArgs.add('%$searchName%');
      }

      // Date range filter
      if (fromDate != null) {
        whereConditions.add('d.updated_at >= ?');
        whereArgs.add(fromDate.toIso8601String());
      }

      if (toDate != null) {
        whereConditions.add('d.updated_at <= ?');
        whereArgs.add(toDate.toIso8601String());
      }

      String whereClause = whereConditions.isNotEmpty
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      String validOrderBy = ['updated_at', 'created_at', 'name'].contains(orderBy)
          ? orderBy
          : 'updated_at';
      String sortDirection = ascending ? 'ASC' : 'DESC';

      String limitClause = limit != null ? 'LIMIT $limit' : '';
      String offsetClause = offset != null ? 'OFFSET $offset' : '';

      final query = '''
        SELECT 
          d.*,
          dt.name as type_name,
          dt.image as type_image
        FROM disasters d
        LEFT JOIN disaster_types dt ON d.type_id = dt.id
        $whereClause
        ORDER BY d.$validOrderBy $sortDirection
        $limitClause $offsetClause
      ''';

      return await db.rawQuery(query, whereArgs);
    } catch (e) {
      print('❌ Error getting advanced filtered disasters: $e');
      rethrow;
    }
  }

  /// Đếm số lượng disasters với filter
  Future<int> countDisastersFiltered({
    int? typeId,
    String? searchName,
  }) async {
    try {
      final db = await database;

      List<String> whereConditions = [];
      List<dynamic> whereArgs = [];

      if (typeId != null) {
        whereConditions.add('type_id = ?');
        whereArgs.add(typeId);
      }

      if (searchName != null && searchName.isNotEmpty) {
        whereConditions.add('name LIKE ?');
        whereArgs.add('%$searchName%');
      }

      String whereClause = whereConditions.isNotEmpty
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM disasters $whereClause',
        whereArgs,
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('❌ Error counting filtered disasters: $e');
      return 0;
    }
  }


  // ================== CRUD disaster_images ==================

  /// Insert disaster image
  Future<int> insertDisasterImage(Map<String, dynamic> row) async {
    try {
      final db = await database;
      return await db.insert(
        'disaster_images',
        row,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      print('❌ Error inserting disaster image: $e');
      rethrow;
    }
  }

  /// Insert nhiều images cùng lúc
  Future<void> insertDisasterImages(int disasterId, List<String> imagePaths) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        for (var path in imagePaths) {
          await txn.insert('disaster_images', {
            'disaster_id': disasterId,
            'image_path': path,
          });
        }
      });
      print('✅ Inserted ${imagePaths.length} images for disaster $disasterId');
    } catch (e) {
      print('❌ Error inserting disaster images: $e');
      rethrow;
    }
  }

  /// Lấy images của một disaster
  Future<List<Map<String, dynamic>>> getDisasterImages(int disasterId) async {
    try {
      final db = await database;
      return await db.query(
        'disaster_images',
        where: 'disaster_id = ?',
        whereArgs: [disasterId],
        orderBy: 'id ASC',
      );
    } catch (e) {
      print('❌ Error getting disaster images: $e');
      rethrow;
    }
  }

  /// Delete một image cụ thể
  Future<int> deleteDisasterImage(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'disaster_images',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Error deleting disaster image: $e');
      rethrow;
    }
  }

  /// Delete tất cả images của một disaster
  Future<int> deleteDisasterImagesByDisasterId(int disasterId) async {
    try {
      final db = await database;
      return await db.delete(
        'disaster_images',
        where: 'disaster_id = ?',
        whereArgs: [disasterId],
      );
    } catch (e) {
      print('❌ Error deleting disaster images by disaster id: $e');
      rethrow;
    }
  }

  // ================== UTILITY METHODS ==================

  /// Đếm số lượng disasters theo type
  Future<Map<int, int>> countDisastersByType() async {
    try {
      final db = await database;
      final results = await db.rawQuery('''
        SELECT type_id, COUNT(*) as count
        FROM disasters
        GROUP BY type_id
      ''');

      Map<int, int> counts = {};
      for (var row in results) {
        // Safe casting
        if (row['type_id'] != null) {
          counts[row['type_id'] as int] = row['count'] as int;
        }
      }
      return counts;
    } catch (e) {
      print('❌ Error counting disasters by type: $e');
      return {};
    }
  }

  /// Xóa toàn bộ database (để test)
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('disaster_images');
        await txn.delete('disasters');
        await txn.delete('disaster_types');
      });
      print('✅ Cleared all data');
    } catch (e) {
      print('❌ Error clearing data: $e');
      rethrow;
    }
  }

  /// Đóng database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  List<Map<String, dynamic>>? _cachedDisasterTypes;

  /// Get disaster types with caching
  Future<List<Map<String, dynamic>>> getDisasterTypes() async {
    if (_cachedDisasterTypes != null) {
      print('📦 [DB] Using cached disaster types');
      return _cachedDisasterTypes!;
    }

    final db = await database;
    _cachedDisasterTypes = await db.query('disaster_types');
    print('💾 [DB] Cached ${_cachedDisasterTypes!.length} disaster types');
    return _cachedDisasterTypes!;
  }

  Future<void> clearCache() async {
    _cachedDisasterTypes = null;
    print('🗑️ [DB] Cache cleared');
  }
}