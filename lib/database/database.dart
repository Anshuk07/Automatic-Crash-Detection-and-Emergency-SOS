import 'dart:async';
import 'package:path/path.dart';
import 'package:sos/models/person_model.dart';
import 'package:sos/models/user_info_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; // Import your Person model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'sos_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phoneNumber TEXT
      )
      ''');

    await db.execute('''
    CREATE TABLE UserInfos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      address TEXT,
      bloodGroup TEXT,
      licenseNumber TEXT,
      vehicleNumber TEXT
    )
    ''');
  }

  Future<int> insertPerson(Person person) async {
    print("insert person called");
    final db = await database;
    return await db!.insert('Persons', person.toJson());
  }

  Future<List<Person>> getPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Persons');
    return List.generate(maps.length, (i) {
      return Person(
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
      );
    });
  }

  Future<int> insertUserInfo(UserInfo userInfo) async {
    final db = await database;
    return await db!.insert('UserInfos', userInfo.toJson());
  }

  Future<UserInfo?> getUserInfo() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('UserInfos');
    if (maps.isEmpty) return null;
    return UserInfo.fromJson(maps.first);
  }

  Future<int> updateUserInfo(UserInfo userInfo) async {
    final db = await database;
    return await db!.update(
      'UserInfos',
      userInfo.toJson(),
      where: 'id = ?',
      whereArgs: [1], // Assuming UserInfo has an 'id' field
    );
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db!.delete(
      'Persons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatePerson(Person person) async {
    final db = await database;
    return await db!.update(
      'Persons',
      person.toJson(),
      where: 'id = ?',
      whereArgs: [1], // Assuming Person has an 'id' field
    );
  }
}
