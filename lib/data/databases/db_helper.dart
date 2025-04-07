import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Getter database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }

  // Inisialisasi database
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'habit_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE habits(
            id TEXT PRIMARY KEY,
            title TEXT,
            time TEXT,
            targetDays INTEGER,
            durationMinutes INTEGER,
            progress TEXT,
            progressValue REAL,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  // Menyimpan habit baru ke database
  Future<int> insertHabit(HabitModel habit) async {
    final db = await database;
    return await db.insert(
      'habits',
      habit.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mendapatkan semua habit
  Future<List<HabitModel>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');

    return List.generate(maps.length, (i) {
      return HabitModel.fromJson(maps[i]);
    });
  }

  // Mendapatkan habit berdasarkan ID
  Future<HabitModel> getHabitById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HabitModel.fromJson(maps.first);
    } else {
      throw Exception('Habit with id $id not found');
    }
  }

  // Menghapus habit berdasarkan ID
  Future<int> deleteHabit(String id) async {
    final db = await database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update habit
  Future<int> updateHabit(HabitModel habit) async {
    final db = await database;
    return await db.update(
      'habits',
      habit.toJson(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }
}
