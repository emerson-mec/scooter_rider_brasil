import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scooter_rider_brasil/exceptions/http_exceptions.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class ItemEventoGerenciado extends StatelessWidget {
  final EventoMODEL item;
  final EventoProvider itemRAW;

  ItemEventoGerenciado({this.item, this.itemRAW});
  
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              ROTAS.DETALHE_EVENTO,
              arguments: item,
            );
          },
          leading: Container(
            width: 60,
            child: Image.network(
              item.imagemPrincipal,
              fit: BoxFit.fitWidth,
            ),
          ),
          title: Text(
            "${item.titulo}",
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            'Data do evento: ' +
                DateFormat('dd/MM/yyyy').format(item.dataEvento),
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          trailing: Container(
            width: 96,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                      Navigator.of(context).pushNamed(
                        ROTAS.FORMULARIOEVENTO,
                        arguments: item,
                      );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Excluir item',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Tem certeza que deseja excluir "${item.titulo}?"'),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                    ).then(
                      (value) async {
                        if (value) {
                          try {
                            await itemRAW.deletar(item);
                          } on HttpException catch (error) {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        Divider(indent: 30, endIndent: 30),
      ],
    );
  }
}
