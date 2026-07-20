import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/need_model.dart';

class OfflineStorageService {
  static Database? _database;
  static const String _tableName = 'offline_needs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('needs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      category TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      urgency TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      reporterId TEXT NOT NULL
    )
    ''');
  }

  Future<void> saveNeed(NeedModel need) async {
    final db = await database;

    final String tempId = 'offline_${DateTime.now().millisecondsSinceEpoch}';

    final map = {
      'id': tempId,
      'title': need.title,
      'description': need.description,
      'category': need.category,
      'latitude': need.latitude,
      'longitude': need.longitude,
      'urgency': need.urgency,
      'createdAt': need.createdAt.toIso8601String(),
      'reporterId': need.reporterId,
    };

    await db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NeedModel>> getPendingNeeds() async {
    final db = await database;

    final result = await db.query(_tableName);

    return result.map((map) {
      return NeedModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        latitude: map['latitude'] as double,
        longitude: map['longitude'] as double,
        urgency: map['urgency'] as String,
        createdAt: DateTime.parse(
          map['createdAt'] as String,
        ), // Metni tekrar tarihe çeviriyoruz
        reporterId: map['reporterId'] as String,
      );
    }).toList();
  }

  Future<void> clearPendingNeeds() async {
    final db = await database;
    await db.delete(_tableName);
  }
}

final offlineStorageProvider = Provider<OfflineStorageService>((ref) {
  return OfflineStorageService();
});
