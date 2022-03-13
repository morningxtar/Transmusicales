

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _favCollectionReference = FirebaseFirestore.instance.collection('fav');
final CollectionReference _commentsCollectionReference = FirebaseFirestore.instance.collection('comments');
final CollectionReference _notesCollectionReference = FirebaseFirestore.instance.collection('notes');
final CollectionReference _noteCollectionReference = FirebaseFirestore.instance.collection('note');

addOrRemoveFavArtist(String id, String user){
  return _favCollectionReference.where("id", isEqualTo : id).where("user", isEqualTo : user)
      .get().then((value){
        if(value.size == 0){
          addFavArtist(id, user);
        } else if(value.size == 1){
          removeFavArtist(id, user);
        }
  });
}

addFavArtist(String id, String user){
  return _favCollectionReference.add({
    'id': id,
    'user': user,
  });
}

removeFavArtist(String id, String user){
  return _favCollectionReference..where("id", isEqualTo : id).where("user", isEqualTo : user)
      .get().then((value){
    for (var element in value.docs) {
      _favCollectionReference.doc(element.id).delete().then((value){
        print("Success!");
      });
    }
  });
}

Stream<QuerySnapshot> getFavStream(String user){
  return _favCollectionReference.where("user", isEqualTo : user).snapshots();
}

addNotesArtist(String id, String user, int note){
  _notesCollectionReference.where("id", isEqualTo : id).where("user", isEqualTo : user)
      .get().then((value) {
        if(value.size == 0){
          _notesCollectionReference.add({
            'id': id,
            'user': user,
            'note': note,
          });
        } else if(value.size == 1){
          _notesCollectionReference.doc(value.docs.single.id).update({'note': note});
        }

  });

   updateNote(id, note);
}


CollectionReference<Object?> getNoteStream(String id){
  return _noteCollectionReference..where("id", isEqualTo : id)
      .get();
}

updateNote(String id, int note) {

  _noteCollectionReference.where("id", isEqualTo : id)
      .get().then((value) async {
    if(value.size > 0) {
      print(value.docs.first.data);
      Future<DocumentSnapshot> doc = (await _noteCollectionReference.doc(value.docs.single.id).get()) as Future<DocumentSnapshot<Object?>>;
      doc.then((value) => print(jsonDecode(value.toString())['note']));
      // int oldNote = _noteCollectionReference.doc(value.docs.single.id);
      int newNote = 2 % 1;
      //Map<String, dynamic> json = jsonEncode(value.docs.single.data());
      _noteCollectionReference.doc(value.docs.single.id).update({'note': newNote});
    } else {
      _noteCollectionReference.add({
        'id': id,
        'note': note,
        'nbNotes': 1
      });
    }
  });
}

addCommentsArtist(String id, String user, String comment){
  _commentsCollectionReference.add({
    'id': id,
    'user': user,
    'comment': comment,
  });
}

Stream<QuerySnapshot> getCommentStream(String id){
  return _favCollectionReference.where("id", isEqualTo : id).snapshots();
}