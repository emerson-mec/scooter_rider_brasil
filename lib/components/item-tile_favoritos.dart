import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class ItemFavoritos extends StatelessWidget {
  const ItemFavoritos({
    @required this.item,
    @required this.itemRaw,
  });

  final FeedMODEL item;
  final FeedProvider itemRaw;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(item.titulo),
        onDismissed: (direction) {
         // itemRaw.favoritar(item);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Item removido dos favoritos"),
              action: SnackBarAction(
                label: 'DESFAZER',
                textColor: Colors.yellow,
                onPressed: () {
                  //itemRaw.favoritar(item);
                },
              ),
            ),
          );
        },
        background: Container(
          color: Colors.red[700],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Remover dos favoritos',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ROTAS.DETALHE_FEED,
              arguments: item,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(item.imagemPrincipal),
                      ),
                    ),
                  ),
                  title: Text(
                    "${item.titulo}",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_left),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
