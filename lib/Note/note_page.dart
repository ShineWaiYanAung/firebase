
import 'package:flutter/material.dart';

import '../firebase_service.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  ///FireStore

  final FireStoreService fireStoreService = FireStoreService();

  ///textController

  final TextEditingController textEditingController = TextEditingController();


  //open a dialog box to add a note

  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {

              fireStoreService.addNote(textEditingController.text);
              textEditingController.clear();
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteBox();
        },
        child: Text('Add'),
      ),
    );
  }
}
