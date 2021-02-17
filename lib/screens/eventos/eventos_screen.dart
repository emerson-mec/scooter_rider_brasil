import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/drawer.dart';
import 'package:scooter_rider_brasil/components/evento/tile_eventos_widget.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
//SCREENS

class EventoScreen extends StatefulWidget {
  @override
  _EventoScreenState createState() => _EventoScreenState();
}

class _EventoScreenState extends State<EventoScreen> {
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<EventoProvider>(context, listen: false).loadEvento();
  }

  @override
  void initState() {
    super.initState();
    // Carregar os produtos
    Provider.of<EventoProvider>(context, listen: false).loadEvento();
  }

  @override
  Widget build(BuildContext context) {
    final itemRaw = Provider.of<EventoProvider>(context);

    return Scaffold(
     appBar: AppBar(
        //actions: [Icon(Icons.menu, color: Theme.of(context).primaryColor)],
        elevation: 1,
        flexibleSpace: Center(
          child: Column(
            children: [
                  SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_srb.png', scale: 20),
                  SizedBox(width: 7),
                  Text(
                    'Eventos',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Bookman',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          itemCount: itemRaw.itemCount(),
          reverse: false,
          itemBuilder: (context, index) {
            return TileEventoWidget(itemRaw.itemEvento[index]);
          },
        ),
      ),
     // bottomNavigationBar: MenuBottom(),

     // drawer: MeuDrawer(),

     endDrawer: MeuDrawer(),
    );
  }
}
