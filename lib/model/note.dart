import 'package:sqlite_task/db/constants.dart';

class Note {
  int? noteId;
  String noteTitle = '';
  String noteText = '';
  String? noteDate = '';
  String? noteUpdateDate = '';
  String? noteColor='';

  Note(
      {this.noteId,
      required this.noteTitle,
      required this.noteText,
      this.noteDate,
      this.noteUpdateDate,
      this.noteColor});

  //convert from object to map
  Map<String, dynamic> toMap() => {
        colId: noteId,
        colTitle: noteTitle,
        colText: noteText,
        colDate: noteDate,
        colUpdateDate: noteUpdateDate,
        colColor :noteColor
      };

  //convert from map to note object
  Note.fromMap(Map<String, dynamic> map) {
    noteId = map[colId];
    noteTitle = map[colTitle];
    noteText = map[colText];
    noteDate = map[colDate];
    noteUpdateDate = map[colUpdateDate];
    noteColor = map[colColor];
  }
}
