import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';

class AlertInscricao extends StatefulWidget {

 final EventoMODEL eventoModalRoute;
 final EventoProvider eventoProvider;
  
  AlertInscricao({
    Key key,
     this.eventoModalRoute,
     this.eventoProvider,
  }) : super(key: key);
  
  @override
  _AlertInscricaoState createState() => _AlertInscricaoState();
}

class _AlertInscricaoState extends State<AlertInscricao> {
  TextEditingController controller = TextEditingController();
  var garupa = false;
  var amigo = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text( 'INSCRIÇÕES', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(
            height: 166,
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  maxLength: 15,
                  decoration: InputDecoration(
                    hintText: 'Qual ponto de encontro?',
                  ),
                ),
                Row(children: [
                  Checkbox(
                    value: garupa, 
                    onChanged: (value){
                      setState(() {
                        garupa = value;
                      });
                    }
                  ),
                  Text('Vou com garupa'),
                ],),
                Row(children: [
                  Checkbox(
                    value: amigo, onChanged: (value){
                      setState(() {
                        amigo = value;
                      });
                  }),
                  Text('Convidei um amigo'),
                ],),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await widget.eventoProvider.inscreverSe(widget.eventoModalRoute.id, controller.text, garupa, amigo);
                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      
  }
}
