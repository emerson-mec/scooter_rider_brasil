import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';

class EventoProvider with ChangeNotifier {

  Firestore _db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<EventoMODEL>> loadEvento() {
    return _db.collection('evento').snapshots().map((snapshot) =>
        snapshot.documents.map((doc) => EventoMODEL.daAPI(doc.data)).toList());
  }

  Future<void> addEvento(EventoMODEL evento) async {
    final FirebaseUser currentUser = await auth.currentUser();

    await _db
        .collection('evento')
        .add(evento.paraJson())
        .then((value) {
         //quando terminar os passos acima, retorne o ID para salvar.
          value.updateData({
            'id': '${value.documentID}',
            'autor': '${currentUser.email}',
          });
        }
        );
  }

   Future<void> updateEvento(EventoMODEL eventoItem) {
     return _db
         .collection('evento')
         .document(eventoItem.id)
         .updateData(eventoItem.paraJson());
   }

   Future<void> removeFeed(String idEvento) {
     return _db.collection('evento').document(idEvento).delete();
   }

}

class Inscricoes {
  String email;
  String idUser;
  bool isInscrito;
  String eventoID;
  String vaiComo;
  Inscricoes({this.email, this.idUser, this.isInscrito, this.eventoID, this.vaiComo});
}
