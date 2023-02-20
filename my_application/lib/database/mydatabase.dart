import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/prayer_model.dart';

class PrayerTimeDatabase {
  static final PrayerTimeDatabase instance = PrayerTimeDatabase._init();

  static Database? _database;

  PrayerTimeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mydatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 7, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE my_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Fajr TEXT,
    Sunrise TEXT,
    Dhuhr TEXT,
    Asr TEXT,
    Sunset TEXT,
    Maghrib TEXT,
    Isha TEXT,
    Imsak TEXT,
    Midnight TEXT,
    Firstthird TEXT,
    Lastthird TEXT
)
''');
  }
  Future<List<TimingModel>> create(List<TimingModel> prayerTimes) async {
    print("Insert method is called");
    final db = await instance.database;
    List<int> ids = [];
    for (var prayerTime in prayerTimes) {
      final id = await db.insert('my_table', prayerTime.toJson());
      ids.add(id);
    }
    print("Data is inserted");
    return prayerTimes;
  }

  Future<TimingModel> insert(TimingModel? prayerTime) async {
    print("Insert method is called");
    final db = await instance.database;
    final id = await db.insert('my_table', prayerTime!.toJson());
    print("Data is inserted");
    return prayerTime;
  }

  Future<TimingModel?> getPrayerTime() async {
    TimingModel timingModel;
    print("GetMethod is called");
    final db = await instance.database;
    final maps = await db.query('my_table', orderBy: "id");
    if (maps.isNotEmpty) {
      print(maps.length);
      return TimingModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

}
