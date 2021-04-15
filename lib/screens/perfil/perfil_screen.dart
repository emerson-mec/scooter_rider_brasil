import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();

  Future _saveForm() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) return;

    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          maxRadius: 100,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage('https://www.leadsdeconsorcio.com.br/blog/wp-content/uploads/2019/11/25.jpg'),
                        ),

                        Text('ID: ${user['id']}'),

                        TextFormField(
                          onSaved: (value) async {
                            await Firestore.instance
                                .collection('users')
                                .document(userId)
                                .setData(
                              {
                                'nome': '$value',
                              },
                              merge: true,
                            );
                            //_formData['titulo'] = value;
                          },
                          maxLines: 1,
                          maxLength: 30,
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
                          readOnly: true,
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
                          onSaved: (value) async {
                            await Firestore.instance
                                .collection('users')
                                .document(userId)
                                .setData(
                              {
                                'estado': '${value.toUpperCase()}',
                              },
                              merge: true,
                            );
                          },
                          initialValue: user['estado'],
                          decoration: InputDecoration(
                              labelText: 'Estado (RJ, SP, MG ou SC)'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty ||
                                value.length > 2 ||
                                value.length == 1)
                              return 'Digite RJ, SP, MG ou SC!';

                            if (value.toUpperCase() != "RJ" &&
                                value.toUpperCase() != "SP" &&
                                value.toUpperCase() != "MG" &&
                                value.toUpperCase() != "SC") {
                              return 'Digite RJ, SP, MG ou SC';
                            }

                            return null;
                          },
                        ),
                        

                        // CLUBE
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('clube')
                              .where("estado", whereIn: ['${user['estado']}'])
                              .snapshots()
                              .map((snapshot) => snapshot.documents),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  CircularProgressIndicator(),
                                  Text('Carregando'),
                                ],
                              );
                            }

                            List snapClube = snapshot.data;

                            bool temEvento = snapClube.isNotEmpty;

                            return temEvento
                                ? Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Column(
                                      children: [
                                       
                                        DropdownSearch<String>(
                                          mode: Mode.BOTTOM_SHEET,
                                          showSelectedItem: true,
                                          showClearButton: true,
                                          items: snapClube
                                              .map((e) => e['clube'].toString())
                                              .toList(),
                                          label: "Clube",
                                          //popupItemDisabled: (String s) => s.startsWith('T'),
                                          selectedItem: user['clube'],
                                          enabled: true,
                                          showSearchBox: true,

                                          onChanged: (String value) async {
                                            await Firestore.instance
                                                .collection('users')
                                                .document(userId)
                                                .setData(
                                              {
                                                'clube': '$value',
                                              },
                                              merge: true,
                                            );
                                          },
                                          popupTitle: Text('Busque por um Scooter Clube'),
                                          validator: (String item) {
                                            if (item == null)
                                              return "Requisição falhou";
                                            else
                                              return null;
                                          },

               
                 

                                       isFilteredOnline: true,

                                        dropdownBuilder: (BuildContext buildContext, n,a) {
                                          return Container(
                                              child: (n == null)
                                                  ? ListTile(
                                                      contentPadding: EdgeInsets.all(0),
                                                      leading: Icon(Icons.search),
                                                      title: Text("Nenhum clube selecionado"),
                                                    )
                                                  : ListTile(
                                                      contentPadding: EdgeInsets.all(0),
                                                      leading: CircleAvatar(
                                                        backgroundImage: NetworkImage('https://image.freepik.com/vetores-gratis/logotipo-motoclub-vetor_23-2147491888.jpg'),
                                                      ),
                                                      title: Text(a),
                                                      subtitle: Text(
                                                        '${a}'
                                                      ),
                                                    ),
                                            );
                                        }
 





                                        ),
                                      
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(height: 30),
                                      DropdownSearch<String>(
                                        label: "Clube",
                                        selectedItem:
                                            'Não encontramos clube no seu estado',
                                        enabled: false,
                                      ),
                                    ],
                                  );
                          },
                        ),
                       


                        SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.save),
                                  onPressed: () async {
                                    await _saveForm();
                                    //Navigator.of(context).pop();
                                  },
                                  label: Text("SALVAR"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.cancel),
                                  label: Text("CANCELAR"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


 