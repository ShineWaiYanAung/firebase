import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //Create : add A new Note
  Future<void> addNote(String note){
    return notes.add({
      'note':note,
      'timestamp': Timestamp.now()
    });

  }
//READ : get Notes from database


//Update : Update Notes to Database


//DELETE : deletle notes give a doc id

}