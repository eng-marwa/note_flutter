import 'package:flutter/material.dart';
import 'package:sqlite_task/db/curd.dart';
import 'package:sqlite_task/model/note.dart';
import 'package:sqlite_task/utils/date_time_manager.dart';
import 'data/colors_data.dart';
import 'utils/extensions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _editKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<Note> notes = [];

  @override
  void initState() {
    viewSavedNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Note Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Title is required' : null,
                ),
                TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Note Text'),
                    validator: (value) =>
                        value!.isEmpty ? 'Text is required' : null),
                SizedBox(height: 55,
                  child: ListView.builder(itemCount: colorsList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(onTap: (){

                    },
                      child: Container(
                        width: 55,
                        color: colorsList[index],
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        String title = _titleController.value.text;
                        String text = _textController.value.text;
                        Note n = Note(
                            noteTitle: title,
                            noteText: text,
                            noteDate: DateTimeManager.currentDateTime());
                        saveNote(n);
                      }
                    },
                    child: const Text('Add Note'))
              ],
            )),
        notes.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(notes[index].noteTitle,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notes[index].noteText,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                          Text('Created on ${notes[index].noteDate!}',
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 12))
                        ]),
                  ),
                  leading: InkWell(
                    child: Icon(Icons.circle,
                        color: notes[index].noteUpdateDate == null
                            ? Colors.blue
                            : Colors.green),
                    onTap: () {
                      if (notes[index].noteUpdateDate != null) {
                        widget.showSnackMessage(context,
                            "Update on ${notes[index].noteUpdateDate}");
                      }
                    },
                  ),
                  trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showEditDialog(context, notes[index]);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {
                                deleteNote(notes[index].noteId);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      )),
                ),
              )
            : Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height - 200,
                child: const Text('No Items Found'),
              )
      ])),
    );
  }

  void saveNote(Note n) {
    Curd.curd.saveNote(n).then((value) {
      print('Done');
      widget.showSnackMessage(context, 'note added');
    });
  }

  void viewSavedNotes() {
    Curd.curd.getNotes().then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  void deleteNote(int? noteId) {
    Curd.curd.deleteNote(noteId).then((value) {
      widget.showSnackMessage(context, 'note deleted');
      viewSavedNotes();
    });
  }

  void showEditDialog(BuildContext context, Note not) {
    TextEditingController _editTitleController =
        TextEditingController(text: not.noteTitle);
    TextEditingController _editTextController =
        TextEditingController(text: not.noteText);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                if (_editKey.currentState!.validate()) {
                  String title = _editTitleController.value.text;
                  String text = _editTextController.value.text;
                  not.noteTitle = title;
                  not.noteText = text;
                  not.noteUpdateDate = DateTimeManager.currentDateTime();
                  updateNote(not);
                }
                Navigator.pop(context);
              },
              child: const Text('Update')),
        ],
        content: Wrap(children: [
          Form(
              key: _editKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _editTitleController,
                    decoration: const InputDecoration(labelText: 'Note Title'),
                    validator: (value) =>
                        value!.isEmpty ? 'Title is required' : null,
                  ),
                  TextFormField(
                      controller: _editTextController,
                      decoration: const InputDecoration(labelText: 'Note Text'),
                      validator: (value) =>
                          value!.isEmpty ? 'Text is required' : null),
                ],
              ))
        ]),
      ),
    );
  }

  void updateNote(Note not) {
    Curd.curd.updateNote(not).then((value) {
      widget.showSnackMessage(context, 'note updated');
      viewSavedNotes();
    });
  }
}
