import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/evento/tile_eventos_widget.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';
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
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 5,
        title: Text('Eventos'.toUpperCase()),
        centerTitle: true,
      ),
      body: Container(
         decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf3f5f7),
              Color(0xFFd3dde7),
            ],
          ),
        ),
        child: FutureBuilder(
          future: authProvider.user(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var user = snapshot.data;

            return StreamBuilder(
              stream: eventoProvider.loadEvento(user['idClube']),
              builder: (ctx, AsyncSnapshot<List<EventoMODEL>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<EventoMODEL> evento = snapshot.data;

                return evento.isEmpty ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Esta mensagem está aparecendo pois:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    Text('- Você ainda não se cadastrou em um clube de seu estado.',textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () { 
                        Navigator.of(context).pushNamed(ROTAS.PERFIL);
                       },
                    child: Text('Clique aqui para se cadastrar'),
                    ),
                    Text('- ou talvez ainda não exista clube no seu estado.',textAlign: TextAlign.center),
                  ],
                )) :ListView.builder(
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
      ),
      //bottomNavigationBar: MenuBottom(),

      //drawer: MeuDrawer(),

      // endDrawer: MeuDrawer(),
    );
  }
}
