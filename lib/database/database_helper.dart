import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shakti_employee_app/home/model/local_convence_model.dart';
import 'package:sqflite/sqflite.dart';

import '../webservice/constant.dart';

class DatabaseHelper {
  static final _databaseName = databaseName;
  static final _databaseVersion = 1;

  static final table = 'local_conveyance';
  static final waypointsTable = 'waypointsTable';
  static final columnId = 'column_id';
  static final userId = 'user_id';
  static final fromLatitude = 'from_latitude';
  static final fromLongitude = 'from_longitude';
  static final toLatitude = 'to_latitude';
  static final toLongitude = 'to_longitude';
  static final fromAddress = 'from_address';
  static final toAddress = 'to_address';
  static final createDate = 'create_date';
  static final createTime = 'create_time';
  static final endDate = 'end_date';
  static final endTime = 'end_time';
  static final latLng = 'lat_lng';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $userId TEXT NOT NULL,
            $fromLatitude TEXT NOT NULL,
            $fromLongitude TEXT NOT NULL,
            $toLatitude TEXT NOT NULL,
            $toLongitude TEXT NOT NULL,
            $fromAddress TEXT NOT NULL,
            $toAddress TEXT NOT NULL,
            $createDate TEXT NOT NULL,
            $createTime TEXT NOT NULL,
            $endDate TEXT NOT NULL,
            $endTime TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $waypointsTable (
            $columnId INTEGER PRIMARY KEY,
            $userId TEXT NOT NULL,
            $latLng TEXT NOT NULL,
            $createDate TEXT NOT NULL,
            $createTime TEXT NOT NULL,
            $endDate TEXT NOT NULL,
            $endTime TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertLocalConveyance(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> updateLocalConveyance(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String CreateDate = row[createDate];
    String CreateTime = row[createTime];
    return await db.update(table, row,  where: "${createDate} = ? AND ${createTime} = ?",
      whereArgs: [CreateDate, CreateTime],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllLocalConveyance() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.toList();
  }



  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }


  Future<int> deleteLocalConveyance(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String CreateDate = row[createDate];
    String CreateTime = row[createTime];
    return await db.delete(table,   where: "${createDate} = ? AND ${createTime} = ?",
    whereArgs: [CreateDate, CreateTime],);
  }

  /*-------------------------------------WayPoints Database----------------------------------------*/


  Future<int> insertWaypoints(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(waypointsTable, row);
  }

  Future<int> updateWaypoints(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String CreateDate = row[createDate];
    String CreateTime = row[createTime];
    return await db.update(waypointsTable, row,  where: "${createDate} = ? AND ${createTime} = ?",
      whereArgs: [CreateDate, CreateTime],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllWaypoints(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String CreateDate = row[createDate];
    String CreateTime = row[createTime];
    var result = await db.query(waypointsTable, where: "${createDate} = ? AND ${createTime} = ?",
      whereArgs: [CreateDate, CreateTime],);
    return result.toList();
  }

}
