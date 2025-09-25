import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDatabase {
  static final HistoryDatabase instance = HistoryDatabase._init();
  static Database? _database;

  HistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = join(dbFolder.path, filePath);

    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      data_json TEXT NOT NULL,
      total REAL NOT NULL,
      timestamp TEXT NOT NULL
    )
    ''');
  }

  Future<int> saveHistory(String type, String dataJson, double total, String timestamp) async {
    final db = await database;
    return await db.insert('history', {
      'type': type,
      'data_json': dataJson,
      'total': total,
      'timestamp': timestamp,
    });
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }
}