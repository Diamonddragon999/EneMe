import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/DayCountModel.dart';

/// The Database Provider encloses all independent data updates
///
class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();

  late Database _database;

  /// If there is not yet a database, then create one
  Future<Database> get database async {
  if (!isDatabaseInitialized) {
    _database = await initDB();
  }
  return _database;
}

bool get isDatabaseInitialized => _database != null;


  /// Creates a new database, initialising it with empty DayCount table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE DayCount ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "date DATETIME"
              ")");
        }
      );
  }

  /// Adds a given DayCount record into the database
  insertDayCount(DayCount newDayCount) async {
  final db = await database;
  var raw = await db.insert(
    "DayCount",
    newDayCount.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return raw;
}


  /// Updates a given DayCount record in the database
  updateDayCount(DayCount newDayCount) async {
    final db = await database;
    var res = await db.update("DayCount", newDayCount.toMap(),
        where: "id = ?", whereArgs: [newDayCount.id]);
    return res;
  }

  /// Returns a given DayCount, specified by ID from the database
  getDayCount(int id) async {
    final db = await database;
    var res = await db.query("DayCount", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? DayCount.fromMap(res.first) : null;
  }

  /// Returns all DayCount records from the database
  Future<List<DayCount>> getAllDayCounts() async {
    final db = await database;
    var res = await db.query("DayCount");
    List<DayCount> list =
      res.isNotEmpty ? res.map((c) => DayCount.fromMap(c)).toList() : [];
    return list;
  }

  /// Deletes a given DayCount record from the database
  deleteDayCount(int id) async {
    final db = await database;
    return db.delete("DayCount", where: "id = ?", whereArgs: [id]);
  }

  /// Deletes ALL DayCount records from the database
  deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM DayCount");
  }

}
