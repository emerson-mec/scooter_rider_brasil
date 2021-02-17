import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class MeuDrawer extends StatelessWidget {
  Widget _createItem(
      {IconData icon, String titulo, String subtitulo, Function onTap}) {
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
    final Auth auth = Provider.of(context);
    return Drawer( 
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Image.asset('assets/logo_srb.png'),
            accountName: Text(
              'Fulano Barbosa da Silva de Sá',
              style:
                  TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, color:  Colors.white, fontSize: 18),
            ),
            accountEmail: Text(
              '${auth.email}',
              style: TextStyle(fontFamily: 'Raleway', color:  Colors.black45),
            ),
            onDetailsPressed: () {
              print('object');
            },
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed(ROTAS.AUTH_HOME);
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
                  onTap: () {},
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
