import 'package:sqflite/sqflite.dart';
import 'package:sqlite_task/db/constants.dart';

import '../model/note.dart';
import 'db_helper.dart';

class Curd{
  //singleton
  Curd._();
  static final Curd curd = Curd._();


  Future<int> saveNote(Note note) async {
   Database db = await  DbHelper.helper.openOrCreateDb();
   return await db.insert(tableName, note.toMap());
  }

  Future<List<Note>> getNotes() async {
    Database db = await  DbHelper.helper.openOrCreateDb();
   List<Map<String,dynamic>> results = await  db.query(tableName,orderBy: '$colDate desc');
   List<Note> notes = results.map((e) => Note.fromMap(e)).toList();
   return notes;
  }

  Future<int> deleteNote(int? noteId) async {
    Database db = await  DbHelper.helper.openOrCreateDb();
   return await db.delete(tableName,where: '$colId=?',whereArgs: [noteId]);

  }

  Future<int> updateNote(Note not) async {
    Database db = await  DbHelper.helper.openOrCreateDb();
    return await db.update(tableName, not.toMap(),where: '$colId=?',whereArgs: [not.noteId]);
  }
}
