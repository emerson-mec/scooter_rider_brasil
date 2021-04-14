import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          final userId = snapshot.data.uid;

          return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(userId)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final user = chatSnapshot.data;

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 1,
                      maxLength: 100,
                      initialValue: user['nome'],
                      decoration: InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe um nome válido';
                        }
                        if (value.trim().length <= 2) {
                          return 'Informe um nome com no mínimo 3 letras!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: user['email'],
                      decoration: InputDecoration(labelText: 'E-mail'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe um e-mail válido';
                        }
                        if (value.trim().length <= 2) {
                          return 'Informe um e-mail com no mínimo 3 letras!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: user['estado'],
                      decoration: InputDecoration(labelText: 'Estado'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe um estado';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: user['id'],
                      decoration: InputDecoration(labelText: 'ID'),
                      textInputAction: TextInputAction.next,
                    ),
                   
                   // CLUBE
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('clube')
                          .where("estado", whereIn: ['${user['estado']}'])
                          .snapshots()
                          .map((snapshot) => snapshot.documents),
                      builder: (context, AsyncSnapshot snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Column(
                            children: [
                              CircularProgressIndicator(),
                              Text('Carregando'),
                            ],
                          );
                        }

                        List snapClube = snapshot.data;

                        bool temEvento = snapClube.isNotEmpty;

                        List  a = snapClube.map((e) => e).toList();

                        print(a[0]['id']);
                        
                        return temEvento ? Container(
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.all(16),
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Text('CLUBE:',style: TextStyle(fontWeight: FontWeight.bold),),

                              DropdownSearch<String>(
                                mode: Mode.BOTTOM_SHEET,
                                showSelectedItem: true,
                                items: snapClube.map((e) => e['clube'].toString()).toList(),
                                label: "Clube",
                                //popupItemDisabled: (String s) => s.startsWith('T'),
                                selectedItem: user['clube'], 
                                enabled: true,
                                showSearchBox: true,
                                
                                onChanged: (String value) async {

                                  await Firestore.instance.collection('users').document(userId).setData(
                                    {
                                      'clube' : '$value',
                                    }, merge: true,
                                  );
                                }, 
                                popupTitle: Text('Busque por um Scooter Clube'),
                                validator: (String item) {
                                  if (item == null)
                                    return "Required field";
                                  else if (item == "Brazil")
                                    return "Invalid item";
                                  else
                                    return null;
                                },
                                key: null,
                              ),


                            ],
                          ),
                        ) : Column(
                          children: [
                            SizedBox(height: 30),
                            DropdownSearch<String>(
                                label: "Clube",
                                selectedItem: 'Não encontramos clube no seu estado', 
                                enabled: false,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
