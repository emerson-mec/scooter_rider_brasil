import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class MeuDrawer extends StatelessWidget {
  Widget _createItem({IconData icon, String titulo, String subtitulo, Function onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Colors.orange[400],
            size: 30,
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
        Divider(height: 15, endIndent: 20, indent: 20, color: Colors.black38),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer( 
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Image.asset('assets/logo_srb.png'),
            accountName: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                
                if(snapshot.connectionState == ConnectionState.waiting){
                  return LinearProgressIndicator();
                }
                final userId = snapshot.data.uid;
                final a = Firestore.instance.collection('users').document(userId).snapshots();

                return StreamBuilder(
                  stream:  a, 
                  builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Text("${chatSnapshot.data['nome']} - ${chatSnapshot.data['estado']} ",style: TextStyle(fontWeight: FontWeight.bold),);
                  },
                  
                );
              },
            ),

            accountEmail: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text('carregando...');
                }
                return Text(snapshot.data.email);
              },
            ),

            otherAccountsPictures: [
              IconButton(
                icon: Icon(
                  Icons.login,
                  color: Colors.grey,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
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
                  subtitulo: 'Gerenciar perfil',
                  onTap: () {
                    Navigator.of(context).pushNamed(ROTAS.PERFIL,);
                    Scaffold.of(context).openDrawer();
                  },
                ),
                _createItem(
                  icon: Icons.miscellaneous_services,
                  titulo: 'Gerenciar',
                  subtitulo: 'Feed de notícias e eventos',
                  onTap: () {
                    Navigator.of(context).pushNamed(ROTAS.GERENCIAR);
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 40,
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
