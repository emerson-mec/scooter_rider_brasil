import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/evento/tile_eventos_widget.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
//SCREENS

class EventoScreen extends StatefulWidget {
  @override
  _EventoScreenState createState() => _EventoScreenState();
}

class _EventoScreenState extends State<EventoScreen> {
  @override
  Widget build(BuildContext context) {
    EventoProvider eventoProvider = Provider.of<EventoProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        //actions: [Icon(Icons.menu, color: Theme.of(context).primaryColor)],
        elevation: 10,
        flexibleSpace: Center(
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 55),
                    Image.asset('assets/logo_srb.png', scale: 18),
                    SizedBox(width: 7),
                    Text(
                      'Eventos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Bookman',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: authProvider.user(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var user = snapshot.data;
          print(user['idClube']);

          return StreamBuilder(
            stream: eventoProvider.loadEvento(user['idClube']),
            builder: (ctx, AsyncSnapshot<List<EventoMODEL>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              List<EventoMODEL> evento = snapshot.data;

              return evento.isEmpty ? Center(child: Text('Sem evento para o seu Clube')) :ListView.builder(
                itemCount: evento.length,
                reverse: false,
                itemBuilder: (context, i) {
                  return TileEventoWidget(evento[i]);
                },
              );
            },
          );
        },
      ),
      //bottomNavigationBar: MenuBottom(),

      //drawer: MeuDrawer(),

      // endDrawer: MeuDrawer(),
    );
  }
}
