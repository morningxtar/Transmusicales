import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmusicales/models/dataset.dart';

import '../models/comment.dart';

final CollectionReference _favCollectionReference =
    FirebaseFirestore.instance.collection('fav');
final CollectionReference _commentsCollectionReference =
    FirebaseFirestore.instance.collection('comments');
final CollectionReference _notesCollectionReference =
    FirebaseFirestore.instance.collection('notes');
final CollectionReference _noteCollectionReference =
    FirebaseFirestore.instance.collection('note');

double note = 0.0;
// Map<String, double>? rateList;

addOrRemoveFavArtist(Dataset dataset, String user) {
  return _favCollectionReference
      .where("id", isEqualTo: dataset.id)
      .where("user", isEqualTo: user)
      .get()
      .then((value) {
    if (value.size == 0) {
      addFavArtist(dataset, user);
    } else if (value.size == 1) {
      removeFavArtist(dataset.id, user);
    }
  });
}

addFavArtist(Dataset dataset, String user) {
  return _favCollectionReference.add({
    'id': dataset.id,
    'user': user,
    'artists': dataset.artistes,
    'annee': dataset.annee,
    'pays': dataset.origine_pays1,
    'note': dataset.note,
    'myNote': dataset.myNote,
  });
}

removeFavArtist(String id, String user) {
  return _favCollectionReference
    ..where("id", isEqualTo: id)
        .where("user", isEqualTo: user)
        .get()
        .then((value) {
      for (var element in value.docs) {
        _favCollectionReference.doc(element.id).delete().then((value) {
          print("Success!");
        });
      }
    });
}

getFavStream(String user) {
  return _favCollectionReference.where("user", isEqualTo: user).snapshots();
}

addNotesArtist(String id, String user, double note) {
  _notesCollectionReference
      .where("id", isEqualTo: id)
      .where("user", isEqualTo: user)
      .get()
      .then((value) {
    if (value.size == 0) {
      _notesCollectionReference.add({
        'id': id,
        'user': user,
        'note': note,
      });
    } else if (value.size > 1) {
      _notesCollectionReference
          .doc(value.docs.single.id)
          .update({'note': note});
    }
  });

  updateNote(id, note);
}

getAllNoteNoteStream() {
  return _noteCollectionReference.snapshots();
}

getNoteById(String id){
  return _noteCollectionReference.where("id", isEqualTo: id).snapshots();
}

getNoteByIdAndUser(String id, String user){
  return _notesCollectionReference.where("id", isEqualTo: id).where("user", isEqualTo: user).snapshots();
}

updateNote(String id, double note) {
  _notesCollectionReference.where("id", isEqualTo: id).get().then((value) {
    num avgNote = 0;

    for (var element in value.docs) {
      var json = jsonEncode(element.data());
      Map valueMap = jsonDecode(json);
      avgNote = (avgNote + valueMap['note'] / value.docs.length).round();
    }

      _noteCollectionReference.where("id", isEqualTo: id).get().then((value1) {
        if (value1.size > 0) {
          _noteCollectionReference.doc(value1.docs.single.id).update({
            'note': note
          });
        } else {
          addNote(id, note);
        }
      });
  });
}

addNote(String id, num note) {
  _noteCollectionReference.add({'id': id, 'note': note});
}

addCommentsArtist(CommentArtist comment) {
  comment.writtenDate = Timestamp.now().toDate();
  _commentsCollectionReference.add({
    'id': comment.id,
    'user': comment.pseudo,
    'comment': comment.contenu,
    'writtenDate': comment.writtenDate,
  });
}

Stream<QuerySnapshot> getCommentStream(String id) {
  return _commentsCollectionReference.where("id", isEqualTo: id).snapshots();
}

CollectionReference getNoteCollectionReference(){
  return _noteCollectionReference;
}

CollectionReference getNotesCollectionReference(){
  return _notesCollectionReference;
}

CollectionReference getFavCollectionReference(){
  return _favCollectionReference;
}