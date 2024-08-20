import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //Create : add A new Note
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

//READ : get Notes from database
  Stream<QuerySnapshot> getNoteStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

//Update : Update Notes to Database
  Future<void> updateNote(String noteId, String newNote) {
    return notes
        .doc(noteId)
        .update({'note': newNote, 'timestamp': Timestamp.now()});
  }

//DELETE : deletle notes give a doc id
  Future<void> deleteNote(String noteId)
  {
    return notes.doc(noteId).delete();
  }}
