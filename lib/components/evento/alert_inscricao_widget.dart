import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: authProvider.user(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        String avatar =  snapshot.data['urlAvatar'];

        return AlertDialog(
          title: Center(child: Text('INSCRIÇÕES',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[800]))),
          content: Container(
            height: 180,
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  maxLength: 15,
                  decoration: InputDecoration(
                    hintText: 'Qual ponto de encontro?',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.black87,
                        value: garupa,
                        onChanged: (value) {
                          setState(() {
                            garupa = value;
                          });
                        }),
                    Text('Vou com garupa',
                        style: TextStyle(color: Colors.blueGrey[700])),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.black87,
                        value: amigo,
                        onChanged: (value) {
                          setState(() {
                            amigo = value;
                          });
                        }),
                    Text('Convidei um amigo',
                        style: TextStyle(color: Colors.blueGrey[700])),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w400),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              onPressed: () async {
                await widget.eventoProvider.inscreverSe(
                  widget.eventoModalRoute.id,
                  avatar,
                  controller.text,
                  garupa,
                  amigo,
                );
                Navigator.of(context).pop(true);
              },
              child: Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }
}
