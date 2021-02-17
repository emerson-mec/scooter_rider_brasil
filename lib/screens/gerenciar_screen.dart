import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/evento/tile_gerenciado.dart';
import 'package:scooter_rider_brasil/components/feed/tile_feed_gerenciado_tile.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class GerenciarScreen extends StatefulWidget {
  @override
  _GerenciarScreenState createState() => _GerenciarScreenState();
}

class _GerenciarScreenState extends State<GerenciarScreen> {
  Future<void> _refreshFeed(BuildContext context) {
    return Provider.of<FeedProvider>(context, listen: false).loadFeed();
  }

  Future<void> _refreshEvento(BuildContext context) {
    return Provider.of<EventoProvider>(context, listen: false).loadEvento();
  }

  bool _filtro = true;

  @override
  void initState() {
    super.initState();
    Provider.of<EventoProvider>(context, listen: false).loadEvento();
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider feedRaw = Provider.of<FeedProvider>(context);
    List<FeedMODEL> itemsFeed = feedRaw.itemFeed;

    EventoProvider itemsEventoRaw = Provider.of<EventoProvider>(context);
    List<EventoMODEL> itemsEvento = itemsEventoRaw.itemEvento;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Gerenciar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            child: Text('Evento', style: TextStyle(fontSize: 10)),
          ),
          Switch(
            focusColor: Colors.green,
            activeColor: Colors.white,
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
      body: _filtro
          ? RefreshIndicator(
              onRefresh: () => _refreshFeed(context),
              child: ListView.builder(
                //reverse: true,
                itemCount: itemsFeed.length,
                itemBuilder: (context, index) => ItemFeedGerenciado(
                  item: itemsFeed[index],
                  itemRAW: feedRaw,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshEvento(context),
              child: ListView.builder(
                //reverse: true,
                itemCount: itemsEvento.length,
                itemBuilder: (context, index) => ItemEventoGerenciado(
                    item: itemsEvento[index], itemRAW: itemsEventoRaw),
              ),
            ),
    );
  }
}

enum Filtro { feed, evento }
enum Add { evento, feed }
