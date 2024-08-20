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
      version: 2, // Incremented version for migration
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
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

    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount INTEGER,
        type TEXT,
        time TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE medications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          amount INTEGER,
          type TEXT,
          time TEXT
        )
      ''');
    }
  }

  // Patient methods
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

  // Medication methods
  Future<void> createMedication(String name, int amount, String type, String time) async {
    final db = await database;
    await db.insert(
      'medications',
      {
        'name': name,
        'amount': amount,
        'type': type,
        'time': time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMedications() async {
    final db = await database;
    return await db.query('medications');
  }

  Future<void> updateMedication(int id, String name, int amount, String type, String time) async {
    final db = await database;

    await db.update(
      'medications',
      {
        'name': name,
        'amount': amount,
        'type': type,
        'time': time,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMedication(int id) async {
    final db = await database;
    await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
