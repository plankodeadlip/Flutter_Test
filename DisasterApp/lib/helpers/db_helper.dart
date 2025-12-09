import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../app/models/disaster_image.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  List<Map<String, dynamic>>? _cachedDisasterTypes;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'disaster_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onConfigure: (db) async {
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

    // Tạo FTS table
    await _createSearchIndexes(db);

    Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        // Xóa các trigger và table FTS5 cũ nếu có
        await db.execute('DROP TRIGGER IF EXISTS disasters_fts_insert');
        await db.execute('DROP TRIGGER IF EXISTS disasters_fts_update');
        await db.execute('DROP TRIGGER IF EXISTS disasters_fts_delete');
        await db.execute('DROP TABLE IF EXISTS disasters_fts');

        // Tạo indexes mới
        await _createSearchIndexes(db);
        print('✅ Migrated from FTS5 to regular search');
      }
    }
  }

  // ================== DISASTER_TYPES ==================

  Future<bool> isDisasterTypesImported() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM disaster_types')
    );
    return (count ?? 0) > 0;
  }

  /// Import disaster types từ JSON
  Future<void> importDisasterTypesFromJson(String jsonString) async {
    try {
      final db = await database;
      List<dynamic> list = json.decode(jsonString);

      await db.transaction((txn) async {
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

      // Clear cache sau khi import
      _cachedDisasterTypes = null;
      print('✅ Imported ${list.length} disaster types');
    } catch (e) {
      print('❌ Error importing disaster types: $e');
      rethrow;
    }
  }

  /// Get disaster types with caching
  Future<List<Map<String, dynamic>>> getDisasterTypes() async {
    if (_cachedDisasterTypes != null) {
      return _cachedDisasterTypes!;
    }

    final db = await database;
    _cachedDisasterTypes = await db.query('disaster_types');
    return _cachedDisasterTypes!;
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

  // ================== CRUD DISASTERS ==================

  /// Create disaster with images (transaction)
  Future<int> createDisasterTransaction({
    required Map<String, dynamic> disasterRow,
    required List<String> imagePaths,
  }) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Insert disaster
      final disasterId = await txn.insert('disasters', disasterRow);

      // Copy và insert images
      if (imagePaths.isNotEmpty) {
        for (var sourcePath in imagePaths) {
          try {
            final destPath = await copyImageToAppDirectory(sourcePath);
            await txn.insert('disaster_images', {
              'disaster_id': disasterId,
              'image_path': destPath,
            });
          } catch (e) {
            print('❌ Error processing image $sourcePath: $e');
          }
        }
      }

      return disasterId;
    });
  }

  /// Update disaster with images (transaction)
  Future<bool> updateDisasterTransaction({
    required int disasterId,
    required Map<String, dynamic> disasterRow,
    required List<String> newImagePaths,
    List<int> imageIdsToRemove = const [],
  }) async {
    final db = await database;

    try {
      await db.transaction((txn) async {
        // Update disaster info
        await txn.update(
          'disasters',
          disasterRow,
          where: 'id = ?',
          whereArgs: [disasterId],
        );

        // Xóa các ảnh được đánh dấu
        for (var imageId in imageIdsToRemove) {
          final images = await txn.query(
            'disaster_images',
            where: 'id = ?',
            whereArgs: [imageId],
          );

          if (images.isNotEmpty) {
            final imagePath = images.first['image_path'] as String;
            await _deleteImageFile(imagePath);
          }

          await txn.delete(
            'disaster_images',
            where: 'id = ?',
            whereArgs: [imageId],
          );
        }

        // Insert ảnh mới
        if (newImagePaths.isNotEmpty) {
          for (var sourcePath in newImagePaths) {
            try {
              final destPath = await copyImageToAppDirectory(sourcePath);
              await txn.insert('disaster_images', {
                'disaster_id': disasterId,
                'image_path': destPath,
              });
            } catch (e) {
              print('❌ Error processing image $sourcePath: $e');
            }
          }
        }
      });
      return true;
    } catch (e) {
      print('❌ Error in updateDisasterTransaction: $e');
      return false;
    }
  }

  /// Get disaster by ID
  Future<Map<String, dynamic>?> getDisasterById(int id) async {
    final db = await database;
    final results = await db.query(
      'disasters',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Delete disaster (cascade xóa images)
  Future<int> deleteDisaster(int id) async {
    final db = await database;
    return await db.delete(
      'disasters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> cleanupDisasterFiles(int id) async {
    final db = await database;
    final images = await db.query(
      'disaster_images',
      columns: ['image_path'],
      where: 'disaster_id = ?',
      whereArgs: [id],
    );

    for (var image in images) {
      await _deleteImageFile(image['image_path'] as String);
    }
  }

  // ================== FILTER AND SEARCH ==================

  /// Filter disasters với nhiều điều kiện
  Future<List<Map<String, dynamic>>> getDisastersFilterd({
    int? typeId,
    String? searchName,
    String orderBy = 'updated_at',
    bool ascending = false,
  }) async {
    final db = await database;

    List<String> whereConditions = [];
    List<dynamic> whereArgs = [];

    if (typeId != null) {
      whereConditions.add('d.type_id = ?');
      whereArgs.add(typeId);
    }

    if (searchName != null && searchName.isNotEmpty) {
      whereConditions.add('(d.name LIKE ? OR d.description LIKE ?)');
      whereArgs.add('%$searchName%');
      whereArgs.add('%$searchName%');
    }

    final String whereClause = whereConditions.isEmpty
        ? ''
        : 'WHERE ${whereConditions.join(' AND ')}';

    final String query = '''
    SELECT 
      d.id,
      d.name,
      d.description,
      d.type_id,
      d.lat,
      d.lon,
      d.created_at,
      d.updated_at,
      dt.name as type_name,
      dt.image as type_image
    FROM disasters d
    LEFT JOIN disaster_types dt ON d.type_id = dt.id
    $whereClause
    ORDER BY d.$orderBy ${ascending ? 'ASC' : 'DESC'}
    ''';

    try {
      return await db.rawQuery(query, whereArgs);
    } catch (e) {
      print('❌ Error in getDisastersFilterd: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> searchDisastersFTS({
    required String searchQuery,
    int? typeId,
    String orderBy = 'updated_at',
    bool ascending = false,
  }) async {
    // Chỉ cần gọi getDisastersFilterd với searchName
    return getDisastersFilterd(
      typeId: typeId,
      searchName: searchQuery,
      orderBy: orderBy,
      ascending: ascending,
    );
  }

  // ================== DISASTER IMAGES ==================

  /// Lấy images của disaster
  Future<List<Map<String, dynamic>>> getDisasterImages(int disasterId) async {
    final db = await database;
    return await db.query(
      'disaster_images',
      where: 'disaster_id = ?',
      whereArgs: [disasterId],
      orderBy: 'id ASC',
    );
  }

  /// Lấy images dưới dạng model
  Future<List<DisasterImage>> getDisasterImagesModel(int disasterId) async {
    final data = await getDisasterImages(disasterId);
    return data.map((map) => DisasterImage.fromMap(map)).toList();
  }

    // ================== FTS (FULL-TEXT SEARCH) ==================

  Future<void> _createSearchIndexes(Database db) async {
    // Index cho name
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_disasters_name 
      ON disasters(name COLLATE NOCASE)
    ''');

    // Index cho description
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_disasters_description 
      ON disasters(description COLLATE NOCASE)
    ''');

    // Index cho type_id (để filter theo loại)
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_disasters_type_id 
      ON disasters(type_id)
    ''');

    // Index cho updated_at (để sort)
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_disasters_updated_at 
      ON disasters(updated_at DESC)
    ''');

    print('✅ Search indexes created');
  }

  /// ✅ Không cần rebuild FTS index nữa
  Future<void> rebuildFTSIndex() async {
    print('ℹ️ FTS5 not used, no index rebuild needed');
  }

  // ================== STATISTICS ==================

  /// Đếm số disasters theo type
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

  // ================== UTILITY METHODS ==================

  Future<String> copyImageToAppDirectory(String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/disaster_images');

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(sourcePath);
      final fileName = 'disaster_${timestamp}$extension';
      final destPath = '${imagesDir.path}/$fileName';

      final sourceFile = File(sourcePath);
      await sourceFile.copy(destPath);

      return destPath;
    } catch (e) {
      print('❌ Error copying image: $e');
      rethrow;
    }
  }

  Future<void> _deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('❌ Error deleting image file: $e');
    }
  }

  void clearCache() {
    _cachedDisasterTypes = null;
  }

  /// Xóa toàn bộ database (testing)
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('disaster_images');
        await txn.delete('disasters');
        await txn.delete('disaster_types');
      });
      clearCache();
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
    clearCache();
  }


}