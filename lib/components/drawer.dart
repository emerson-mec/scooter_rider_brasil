import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class MeuDrawer extends StatelessWidget {
  final User _user;

  MeuDrawer(this._user);

  Widget _createItem({IconData icon, String titulo, String subtitulo, Function onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Colors.orange[400],
            size: 35,
          ),
          title: Text(
            titulo,
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:  Colors.blueGrey[800],
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(color: Colors.black38, fontSize: 14),
          ),
          onTap: onTap,
        ),
        Divider(height: 15, endIndent: 30, indent: 30, color: Colors.blueGrey[300]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer( 
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.yellow[800]),
            
            currentAccountPicture: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(_user.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                   if(snapshot.connectionState == ConnectionState.waiting){
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(Constantes.SEM_AVATAR),
                      );
                   }

                   try {
                     final urlAvatar = snapshot.data.get('urlAvatar');

                      return CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: urlAvatar != null ? NetworkImage(urlAvatar) : AssetImage(Constantes.SEM_AVATAR) 
                    );
                   } on NetworkImageLoadException  catch (e) {
                     print(e.uri.toString());
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(Constantes.SEM_AVATAR) 
                      );
                   }

                  },
            ),
            accountName: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(_user.uid).snapshots(),
                  builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                     if(chatSnapshot.connectionState == ConnectionState.waiting){
                        return Center(child: Text('Carregando...'));
                    } 
                    return Text("${chatSnapshot.data.get('nome')}",style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'RobotoCondensed',color: Colors.white),);
                  },
            ), 

            accountEmail: Text(_user.email, style: TextStyle(color: Colors.grey[700], fontFamily: 'RobotoCondensed')),

            otherAccountsPictures: [
              IconButton(
                icon: Icon(
                  Icons.login,
                  color: Colors.grey[100],
                ),
                onPressed: () async {
                 await FirebaseAuth.instance.signOut();
                } 
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                _createItem(
                  icon: Icons.person,
                  titulo: 'Pefil',
                  subtitulo: 'Editar perfil, estado ou clube',
                  onTap: () {
                    Navigator.of(context).pushNamed(ROTAS.PERFIL, arguments: _user);
                    Scaffold.of(context).openDrawer();
                  },
                ),
                _createItem(
                  icon: Icons.miscellaneous_services,
                  titulo: 'Gerenciar',
                  subtitulo: 'Editar/criar Feed ou evento',
                  onTap: () {
                    Navigator.of(context).pushNamed(ROTAS.GERENCIAR);
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            //color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'Versão 1.0.0',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
