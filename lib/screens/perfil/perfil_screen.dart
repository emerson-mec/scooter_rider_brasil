import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/clube_model.dart';
import 'package:scooter_rider_brasil/providers/clube_provider.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';

import '../authScreen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  //final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();

  TextEditingController textEditingController = TextEditingController();

  Future _saveForm() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) return;

    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    var clubePovider = Provider.of<ClubeProvider>(context);

    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Editar Perfil'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
            child: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                }
                final userId = snapshot.data.uid;

                return StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userId).snapshots(),
                  builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final user = chatSnapshot.data;
                    final urlAvatar = chatSnapshot.data['urlAvatar'];

                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // AVATAR
                          CircleAvatar(
                            maxRadius: 100,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: urlAvatar != null ? NetworkImage(urlAvatar) : AssetImage(Constantes.SEM_AVATAR) 
                          ),
                         
                          SizedBox(height: 15),
                          Text('ID: ${user['id']}'),

                          // NOME
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
                            maxLength: 34,
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

                          // EMAIL
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

                          SizedBox(height: 20),

                          // ESTADO
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
                            // isso foi feito para quando mudar o estado o clube ser atualizado
                            onChanged: (value) async {
                              if(value.length <= 1){
                                return null;
                              }
                               if (value.isEmpty ||
                                  value.length > 2 ||
                                  value.length == 1)
                                return await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .setData(
                                            {
                                              'clube': FieldValue.delete(),
                                              'idClube': FieldValue.delete(),
                                            },
                                            merge: true,
                                          );

                              if (value.toUpperCase() != "RJ" &&
                                  value.toUpperCase() != "SP" &&
                                  value.toUpperCase() != "MG" &&
                                  value.toUpperCase() != "SC") {
                                return await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .setData(
                                            {
                                              'clube': FieldValue.delete(),
                                              'idClube': FieldValue.delete(),
                                            },
                                            merge: true,
                                          );
                              }

                              

                              await Firestore.instance
                                  .collection('users')
                                  .document(userId)
                                  .setData(
                                {
                                  'estado': '${value.toUpperCase()}',
                                },
                                merge: true,
                              ).then((value) async {
                                 await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .setData(
                                            {
                                              'clube': FieldValue.delete(),
                                              'idClube': FieldValue.delete(),
                                            },
                                            merge: true,
                                          );
                              }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado salvo com sucesso!'),backgroundColor: Colors.green, action: SnackBarAction(label: 'OK', onPressed: () {  },textColor: Colors.white,) ,)));
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

                          SizedBox(height: 10),

                          // CLUBE
                          StreamBuilder(
                            stream: clubePovider.loadClube('${user['estado']}'),
                            builder: (context, AsyncSnapshot<List<ClubeMODEL>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('Carregando'),
                                  ],
                                );
                              }

                              List<ClubeMODEL> snapClube = snapshot.data;
                              

                              bool temEvento = snapClube.isNotEmpty;
                              


                                if (temEvento) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:EdgeInsets.only(top: 30, right: 5),
                                        child: Column(
                                          children: [
                                            DropdownSearch<ClubeMODEL>(
                                              label: "Clube",
                                              showSearchBox: true,
                                              searchBoxDecoration: InputDecoration(suffixIcon: Icon(Icons.search), hintText: 'Buscar Scooter Clube'),
                                              mode: Mode.BOTTOM_SHEET,
                                              itemAsString: (ClubeMODEL clube) => clube.clube,
                                              selectedItem: user['clube'] == null ? ClubeMODEL(clube: 'Faça parte de um clube!') : ClubeMODEL(clube: '${user['clube']}'),
                                              popupItemBuilder: _customPopupItemBuilderExample,
                                              onFind: (String filter) async {
                                                final Firestore _db = Firestore.instance;
                                                    return _db
                                                        .collection('clube')
                                                        .where("estado", whereIn: ['${user['estado']}'])
                                                        .getDocuments()
                                                        .then((snapshot) => snapshot.documents.reversed
                                                            .map((doc) => ClubeMODEL.fromMap(doc.data))
                                                            .toList(),
                                                          );
                                              },
                                              onChanged: (ClubeMODEL value) async {
                                                await Firestore.instance
                                                    .collection('users')
                                                    .document(userId)
                                                    .setData(
                                                  {
                                                    'clube': '${value.clube}',
                                                    'idClube': '${value.id}',
                                                  },
                                                  merge: true,
                                                ).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Clube salvo com sucesso!'),backgroundColor: Colors.green, 
                                                action: SnackBarAction(label: 'OK', onPressed: () {  },textColor: Colors.white,) ,)));
                                                
                                              },
                                              
 
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                            //////////// REMOVER CLUBE /////////////
                                   Container(
                                      height: 70,
                                      //color: Colors.redAccent,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: () async {
                                          await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .setData(
                                            {
                                              'clube': FieldValue.delete(),
                                              'idClube': FieldValue.delete(),
                                            },
                                            merge: true,
                                          );
                                        },
                                      ),
                                    ),


                                  ],
                                );
                              } 
                              else {
                                return Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                            child: Container(
                                            child: DropdownSearch<String>(
                                              label: "Clube",
                                              selectedItem:
                                                  'Não encontramos clube no seu estado',
                                              enabled: false,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                           child: Container(
                                            height: 70,
                                            //color: Colors.redAccent,
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              icon: Icon(Icons.cancel),
                                              onPressed: () async {
                                                        await Firestore.instance
                                                      .collection('users')
                                                      .document(userId)
                                                      .setData(
                                                    {
                                                      'clube': FieldValue.delete(),
                                                      'idClube': FieldValue.delete(),
                                                    },
                                                    merge: true,
                                                  );
                                            },
                                      ),
                                    ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                  ],
                                );
                              }
                              },
                          ),
                          

                          SizedBox(height: 20),

                          // BOTÕES
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
                          // TextButton(
                          //   onPressed: () async { 
                          //     try {
                               
                          //       var user = await FirebaseAuth.instance.currentUser();
                                
                          //       if (user != null) {

                          //         showDialog(context: context, builder: (builder){
                          //             return AlertDialog( 
                          //               title: Text('EXCLUIR CONTA?'),
                          //               actions: [
                          //                 TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Cancelar', style: TextStyle(color: Colors.blue))),
                          //                 TextButton(
                          //                   child: Text('Excluir conta',style: TextStyle(color: Colors.redAccent)),
                          //                   onPressed: () async {

                          //                     // await FirebaseStorage.instance
                          //                     //       .getReferenceFromUrl('https://firebasestorage.googleapis.com/v0/b/scooter-rider-brasil-6532a.appspot.com/o/user_images%2F1WW3EIXhrfTLFVnYI0gh0HoGecB2.jpg?alt=media&token=e17da926-79ed-42e8-9394-29174009e3a2')
                          //                     //       .then((value) => value.delete());
                                                   
                                                  
                          //                     await Firestore.instance.collection('users').document(userId).delete().then((value) async {
                          //                         await user.delete().then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conta excluida'),backgroundColor: Colors.green,)));
                          //                     });

                          //                     Navigator.of(context).pushAndRemoveUntil(
                          //                       MaterialPageRoute(builder: (context) {
                          //                         return AuthScreen();
                          //                       }),
                          //                     );

                          //                 },
                          //               ),
                          //               ],
                          //             );
                          //           }
                          //         );

                          //       } 

                          //     } catch (e) {
                          //       print(e);
                          //     }
                          //   },

                          //   child: Text('Excluir conta',style: TextStyle(color: Colors.redAccent)),
                          // ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


 

  Widget _customPopupItemBuilderExample(
      BuildContext context, ClubeMODEL item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.clube),
        subtitle: Text("${item.descricao}"),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.imagemUrl),
        ),
      ),
    );
  }
