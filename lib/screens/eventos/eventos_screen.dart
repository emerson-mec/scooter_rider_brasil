import 'package:firebase_auth/firebase_auth.dart';
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
    final _auth = ModalRoute.of(context).settings.arguments as User;

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
       
        child: StreamBuilder(
          stream: authProvider.userColecao(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            
            var usuario;

            try {
              usuario = snapshot.data['idClube'];
            } catch (e) {
              usuario = null;
              print(e);
            }

            //bool temClubeNoUser = idClubeDoUsuario.isEmpty;
            
            
            return StreamBuilder(
              stream: eventoProvider.loadEvento(usuario),
              builder: (ctx, AsyncSnapshot<List<EventoMODEL>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<EventoMODEL> evento = snapshot.data;

                return evento.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/image/fimFeed.png',scale: 2.9),
                              Text('Esta mensagem está aparecendo pois:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27, color: Colors.grey[800])),
                              SizedBox(height: 20),
                              Text('- Você ainda não se cadastrou em um clube de seu estado,',textAlign: TextAlign.center,),
                              SizedBox(height: 3),
                              InkWell(child: Text('Clique aqui para se cadastrar',style: TextStyle(color: Colors.blue[700]),), onTap: ()=> Navigator.of(context).pushNamed(ROTAS.PERFIL, arguments: _auth),),
                              SizedBox(height: 20),
                              Text('- Ou talvez ainda não exista clube no seu estado.',textAlign: TextAlign.center),
                              SizedBox(height: 20),
                              Text('- Verifique sua internet.',textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                    )
                    : ListView.builder(
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
    );
    //bottomNavigationBar: MenuBottom(),
    //drawer: MeuDrawer(),
  }
}
