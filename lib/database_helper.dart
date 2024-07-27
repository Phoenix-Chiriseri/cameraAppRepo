import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('patients.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT,
        date_of_birth TEXT
      )
    ''');
  }

  Future<void> createPatient(String id, String dateOfBirth) async {
    final db = await database;

    await db.insert(
      'patients',
      {
        'patient_id': id,
        'date_of_birth': dateOfBirth,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> searchPatientsById(String id) async {
    final db = await database;
    return await db.query(
      'patients',
      where: 'patient_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    final db = await database;

    return await db.query('patients');
  }

  Future<void> updatePatient(int id, String newId, String newDateOfBirth) async {
    final db = await database;

    await db.update(
      'patients',
      {
        'patient_id': newId,
        'date_of_birth': newDateOfBirth,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePatient(int id) async {
    final db = await database;

    await db.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
