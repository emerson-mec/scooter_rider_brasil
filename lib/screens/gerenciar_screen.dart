import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/evento/tile_gerenciado.dart';
import 'package:scooter_rider_brasil/components/feed/tile_feed_gerenciado_tile.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class GerenciarScreen extends StatefulWidget {
  @override
  _GerenciarScreenState createState() => _GerenciarScreenState();
}

class _GerenciarScreenState extends State<GerenciarScreen> {
  bool _filtro = false;

  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    EventoProvider eventoProvider = Provider.of<EventoProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          'Gerenciar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          //SWITCH "EVENTO" OU "FEED"
          Container(
            alignment: Alignment.center,
            child: Text('Evento', style: TextStyle(fontSize: 10)),
          ),
          Switch(
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.green,
            onChanged: (bool value) {
              setState(() {
                _filtro = value;
              });
            },
            value: _filtro,
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Feed', style: TextStyle(fontSize: 10)),
          ),

          //ÍCONE DE ADICIONAR
          PopupMenuButton<Add>(
            onSelected: (Add selecionado) {
              setState(() {
                if (selecionado == Add.evento) {
                  Navigator.of(context).pushNamed(ROTAS.FORMULARIOEVENTO);
                } else if (selecionado == Add.feed) {
                  Navigator.of(context).pushNamed(ROTAS.FORMULARIOFEED);
                }
              });
            },
            icon: Icon(Icons.add),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.event),
                    Text(' Evento'),
                  ],
                ),
                value: Add.evento,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.dynamic_feed_sharp),
                    Text(' Feed'),
                  ],
                ),
                value: Add.feed,
              ),
            ],
          ),
        ],
      ),
      
      body: StreamBuilder(
        stream: authProvider.userColecao(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final snap = snapshot.data;

          return  _filtro
              ? StreamBuilder(
                  stream: feedProvider.loadFeed('EstadosFeed.${snap['estado']}'),
                  builder: (ctx, AsyncSnapshot<List<FeedMODEL>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<FeedMODEL> feedList = snapshot.data;

                    return ListView.builder(
                      itemCount: feedList.length,
                      reverse: false,
                      itemBuilder: (context, i) {
                        return TileFeedGerenciado(item: feedList[i]);
                      },
                    );
                  },
                )
              : StreamBuilder(
                  stream: eventoProvider.loadEvento(snap['idClube']),
                  builder: (ctx, AsyncSnapshot<List<EventoMODEL>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<EventoMODEL> feedList = snapshot.data;

                    return ListView.builder(
                      itemCount: feedList.length,
                      reverse: false,
                      itemBuilder: (context, i) {
                        return ItemEventoGerenciado(feedList[i],);
                      },
                    );
                  },
                );
           
        },
      ),
    );
  }
}

enum Filtro { feed, evento }
enum Add { evento, feed }
