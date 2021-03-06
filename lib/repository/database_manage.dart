import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager _instance = new DatabaseManager.internal();
  factory DatabaseManager() => _instance;

  static const String cartTable = "Cart";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseManager.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onOpen: _onOpen);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    try {
      await db.execute('''
create table if not exists $cartTable (
  _id integer primary key autoincrement,
  id text,
  product text,
  variation text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists Config (
  _id integer primary key autoincrement,
  id integer,
  name text,
  description text,
  image text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists User (
  _id integer primary key autoincrement,
  id integer,
  user text
  )
''');
    } catch (e) {
      print(e);
    }
  }

  void _onOpen(Database db) async {
    try {
      await db.execute('''
create table if not exists User (
  _id integer primary key autoincrement,
  id integer,
  user text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists Config (
  _id integer primary key autoincrement,
  id integer,
  name text,
  description text,
  image text
  )
''');
    } catch (e) {
      print(e);
    }
  }
}
