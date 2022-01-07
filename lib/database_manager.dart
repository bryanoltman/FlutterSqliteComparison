import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sql_timing/models.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

abstract class DatabaseManager {
  Future<void> setUpDatabase();
  Future<void> insertEmployee(Employee employee);
  Future<void> insertJob(Job job);
  Future<Object?> allEmployees();
  Future<Object?> allJobs();
}

class SqfliteDatabaseManager implements DatabaseManager {
  sqflite.Database? database;

  @override
  Future<void> setUpDatabase() async {
    final databasesPath = await sqflite.getDatabasesPath();
    String path = databasesPath + 'demo.db';

    await sqflite.deleteDatabase(path);

    database = await sqflite.openDatabase(path, version: 1,
        onCreate: (sqflite.Database db, int version) async {
      await db.execute(Job.createTableStatement);
      await db.execute(Employee.createTableStatement);
    });
  }

  @override
  Future<List<Map<String, Object?>>> allEmployees() async {
    return await database!.query(Employee.tableName);
  }

  @override
  Future<void> insertEmployee(Employee employee) async {
    await database!.rawInsert(employee.insertStatement);
  }

  @override
  Future<void> insertJob(Job job) async {
    await database!.rawInsert(job.insertStatement);
  }

  @override
  Future<Object?> allJobs() async {
    return await database!.query(Job.tableName);
  }
}

class Sqlite3DatabaseManager implements DatabaseManager {
  sqlite3.Database? database;

  @override
  Future<void> setUpDatabase() async {
    final dbPath = (await getApplicationDocumentsDirectory()).path + 'demo.db';
    final dbFile = File(dbPath);
    if (dbFile.existsSync()) {
      File(dbPath).deleteSync();
    }
    database = sqlite3.sqlite3.open(dbPath);
    database!.execute(Job.createTableStatement);
    database!.execute(Employee.createTableStatement);
  }

  @override
  Future<sqlite3.ResultSet> allEmployees() async {
    return database!.select('SELECT * FROM ${Employee.tableName};');
  }

  @override
  Future<void> insertEmployee(Employee employee) async {
    database!.execute(employee.insertStatement);
  }

  @override
  Future<sqlite3.ResultSet> allJobs() async {
    return database!.select('SELECT * FROM ${Job.tableName};');
  }

  @override
  Future<sqlite3.ResultSet> insertJob(Job job) async {
    final dbStatement = database!.prepare(job.insertStatement);
    dbStatement.execute();
    final lastInsertRowId = database!.lastInsertRowId;
    final row = database!
        .select('SELECT * FROM ${Job.tableName} WHERE id = $lastInsertRowId;');
    return row;
  }
}
