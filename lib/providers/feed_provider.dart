import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedProvider with ChangeNotifier {
  Firestore _db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  Stream<List<FeedMODEL>> loadFeed([String estado = 'EstadosFeed.RJ']) {
    return _db
    .collection('feed')
    .where("estado", whereIn: ['$estado', 'EstadosFeed.TODOS'])
    .snapshots()
    .map((snapshot) =>
        snapshot.documents.reversed 
        .map((doc) => FeedMODEL.daAPI(doc.data))
        .toList()
    );
  }

  Future<void> addFeed(FeedMODEL newFeed) async {
    final FirebaseUser currentUser = await auth.currentUser();

    await _db
        .collection('feed')
        .add(newFeed.paraMap())
        .then((value) {
         //quando terminar os passos acima, retorne o ID para salvar.
          value.updateData({
            'idFeed': '${value.documentID}',
            'autor': '${currentUser.email}',
          });
        }
        );
        
  }

  Future<void> updateFeed(FeedMODEL feedItem) {
    return _db
        .collection('feed')
        .document(feedItem.idFeed)
        .updateData(feedItem.paraMap());
  }

  Future<void> removeFeed(String idFeed) {
    return _db.collection('feed').document(idFeed).delete();
  }
}
