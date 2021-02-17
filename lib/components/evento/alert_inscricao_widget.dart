import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';

class AlertInscricaoWidget extends StatefulWidget {
  final EventoMODEL eventoModalRoute;
  final Auth auth;

  const AlertInscricaoWidget({
    this.eventoModalRoute,
    this.auth,
  });

  @override
  _AlertInscricaoWidgetState createState() => _AlertInscricaoWidgetState();
}

class _AlertInscricaoWidgetState extends State<AlertInscricaoWidget> {
  TextEditingController itemController = TextEditingController();

  int _radioGroup = -1;

  String vaiComo = '';
  void _pagadorChange(int value) {
    setState(() {
      _radioGroup = value;
    });
    switch (_radioGroup) {
      case 0:
        vaiComo = 'Piloto Solo';
        break;
      case 1:
        vaiComo = 'Com Garupa';
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    EventoProvider itemRaw = Provider.of<EventoProvider>(context);

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Inscrição'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Container(
          width: 300,
          child: Column(
            children: [
              Text('Vai como?', style: TextStyle(fontWeight: FontWeight.bold)),
              Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _radioGroup,
                        onChanged: _pagadorChange,
                      ),
                      Text('Piloto Solo'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _radioGroup,
                        onChanged: _pagadorChange,
                      ),
                      Text('Com Garupa'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _radioGroup,
                        onChanged: _pagadorChange,
                      ),
                      Text('Outros'),
                    ],
                  ),
                ],
              ),
              if (_radioGroup == 2)
                TextField(
                  controller: itemController,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              itemRaw.loadInscritos(widget.eventoModalRoute.id);
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: Text(
              'Confirmar participação',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green[700],
            onPressed: () {
              if (_radioGroup < 0) {
                return;
              }
              if (itemController.text.isNotEmpty) {
                vaiComo = itemController.text;
              }

              itemRaw.addInscrito(
                  widget.eventoModalRoute, widget.auth, vaiComo);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
