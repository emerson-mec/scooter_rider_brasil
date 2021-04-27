import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedProvider with ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser;


  Stream<List<FeedMODEL>> loadFeed([String estado = 'EstadosFeed.RJ']) {
    return _db
    .collection('feed')
    .where("estado", whereIn: ['$estado', 'EstadosFeed.TODOS'])
    .snapshots()
    .map((snapshot) => snapshot.docs.reversed.map((doc) => FeedMODEL.daAPI(doc.data()))
    .toList()
    );
  }

  Future<void> addFeed(FeedMODEL newFeed) async {

    await _db
        .collection('feed')
        .add(newFeed.paraMap())
        .then((value) {
         //quando terminar os passos acima, retorne o ID para salvar.
          value.update({
            'idFeed': '${value.id}',
            'autor': '${_user.email}',
          });
        }
        );
        
  }

  Future<void> updateFeed(FeedMODEL feedItem) {
    return _db
        .collection('feed')
        .doc(feedItem.idFeed)
        .update(feedItem.paraMap());
  }

  Future<void> removeFeed(String idFeed) {
    return _db.collection('feed').doc(idFeed).delete();
  }
}
