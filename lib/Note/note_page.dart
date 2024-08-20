import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_service.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  /// FireStore service
  final FireStoreService fireStoreService = FireStoreService();

  /// Text Controller
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    textEditingController.dispose();
    super.dispose();
  }

  /// Open a dialog box to add or edit a note
  void openNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(hintText: 'Enter your note'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId != null) {
                fireStoreService.updateNote(docId, textEditingController.text);
              } else {
                fireStoreService.addNote(textEditingController.text);
              }
              textEditingController.clear();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(docId != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  /// Delete a note
  void deleteNote(String docId) {
    fireStoreService.deleteNote(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStoreService.getNoteStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Notes'));
                } else {
                  List<DocumentSnapshot> notesList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = notesList[index];
                      String docId = documentSnapshot.id;
                      Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                      String noteText = data['note'];

                      return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                textEditingController.text = noteText;
                                openNoteBox(docId: docId);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteNote(docId);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          textEditingController.clear();
          openNoteBox();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
