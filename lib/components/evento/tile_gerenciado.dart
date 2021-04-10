import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class ItemEventoGerenciado extends StatelessWidget {
  final EventoMODEL item;

  ItemEventoGerenciado(this.item);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ListTile(
          
          //NAVEGA PARA PÁGINA DETALHE EVENTO
          onTap: () {
            Navigator.of(context).pushNamed(
              ROTAS.DETALHE_EVENTO,
              arguments: item,
            );
          },
          
          // IMAGEM
          leading: Container(
            width: 60,
            child: Image.network(
              item.imagemPrincipal,
              fit: BoxFit.fitWidth,
            ),
          ),
         
         // TITULO
          title: Text(
            "${item.titulo}",
            style: TextStyle(fontSize: 14),
          ),
          
          // SUBTITULO
          subtitle: Text(
            'Data do evento: ' +
                DateFormat('dd/MM/yyyy').format(item.dataEvento),
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          
          // BOTÕES
          trailing: Container(
            width: 96,
            child: Row(
              children: [

                // EDITAR
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
                
                // EXCLUIR
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => 
                      AlertDialog(
                        title: Text('Excluir evento',style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Tem certeza que deseja excluir "${item.titulo}?"'),
                        actions: [
                          TextButton(
                            child: Text('Excluir', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Provider.of<EventoProvider>(context, listen: false).removeFeed(item.id);
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
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
