import 'package:notes/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "note.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL)");
  }

  Future<NoteModel> insert(NoteModel noteModel) async {
    var dbClient = await db;
    await dbClient.insert("notes", noteModel.toMap());
    return noteModel;
  }

  Future<List<NoteModel>> getNoteList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient.query("notes");
    return queryResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<int> edit(NoteModel noteModel) async {
    var dbClient = await db;
    return await dbClient.update("notes", noteModel.toMap(),
        where: "id = ? ", whereArgs: [noteModel.id]);
  }
}
