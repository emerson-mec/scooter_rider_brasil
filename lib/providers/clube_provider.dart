import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/models/clube_model.dart';

class ClubeProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Stream<List<ClubeMODEL>> loadClube([String estado]) {
    return _db.collection('clube')
        .where("estado", whereIn: ['$estado']).snapshots()
        .map((snapshot) => snapshot.docs.reversed.map((doc) => ClubeMODEL.fromMap(doc.data()))
        .toList());
  }

  // Future<void> addFeed(FeedMODEL newFeed) async {
  //   final FirebaseUser currentUser = await auth.currentUser();

  //   await _db
  //       .collection('feed')
  //       .add(newFeed.paraMap())
  //       .then((value) {
  //        //quando terminar os passos acima, retorne o ID para salvar.
  //         value.updateData({
  //           'idFeed': '${value.documentID}',
  //           'autor': '${currentUser.email}',
  //         });
  //       }
  //       );

  // }

  // Future<void> updateFeed(FeedMODEL feedItem) {
  //   return _db
  //       .collection('feed')
  //       .document(feedItem.idFeed)
  //       .updateData(feedItem.paraMap());
  // }

  // Future<void> removeFeed(String idFeed) {
  //   return _db.collection('feed').document(idFeed).delete();
  // }
}
