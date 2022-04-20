import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  Future<Database> openDB(String path) async {
    Database db = await openDatabase(path);
    return db;
  }
}
