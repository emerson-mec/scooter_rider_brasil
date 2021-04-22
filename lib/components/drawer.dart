import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class MeuDrawer extends StatelessWidget {
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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    
    return Drawer( 
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://media2.giphy.com/media/GUuG3hg2rIcMx2s7OS/200.gif'),
                fit: BoxFit.fill,
              ),
            ), 
            currentAccountPicture: 
            FutureBuilder(
              future: authProvider.user(),
              builder: (context, snapshot) {
                
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage(Constantes.SEM_AVATAR),
                  );
                }
               
                String urlAvatar = snapshot.data['urlAvatar'];

                return CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: urlAvatar != null ? NetworkImage(urlAvatar) : AssetImage(Constantes.SEM_AVATAR) 
                );

              },
            ),
            accountName: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: Text('Carregando...'));
                }

                final userId = snapshot.data.uid;
                final a = Firestore.instance.collection('users').document(userId).snapshots();

                return StreamBuilder(
                  stream:  a, 
                  builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                     if(chatSnapshot.connectionState == ConnectionState.waiting){
                        return Center(child: Text('Carregando...'));
                    } 
                    return Text("${chatSnapshot.data['nome']}",style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'RobotoCondensed',color: Colors.white),);
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
                return Text(snapshot.data.email, style: TextStyle(color: Colors.grey[600], fontFamily: 'RobotoCondensed'));
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
                  subtitulo: 'Editar perfil, estado ou clube',
                  onTap: () {
                    Navigator.of(context).pushNamed(ROTAS.PERFIL,);
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
