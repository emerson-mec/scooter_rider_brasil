import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';

class FormularioEventoScreen extends StatefulWidget {
  @override
  _FormularioFeedScreenState createState() => _FormularioFeedScreenState();
}

class _FormularioFeedScreenState extends State<FormularioEventoScreen> {
  //FocusNode == "nó de foco". Algum formulário aponta o cursor para este nó.
  final _subtituloFocusNode = FocusNode();
  final _conteudoFocusNode = FocusNode();
  final _imagemPrincialFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //salva aqui o valor de cada "onSaved" de cada formulário.
  final Map<String, Object> _formData = {};
  bool _isLoading = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    //Escute "_imageUrlFocusNode", Sempre que houver entrada e saida do cursor do campo "URL da imagem" chame a fn setState:
    _imagemPrincialFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //trás a data do evento que já estava criado. Corrige problema de pegar data atual.
    final event = ModalRoute.of(context).settings.arguments as EventoMODEL;
    if (event != null) {
      this.selectedDate = event.dataEvento;
    }

    if (_formData.isEmpty) {
      final itemEvent =
          ModalRoute.of(context).settings.arguments as EventoMODEL;
      if (itemEvent != null) {
        _formData['id'] = itemEvent.id;
        _formData['titulo'] = itemEvent.titulo;
        _formData['subtitulo'] = itemEvent.subtitulo;
        _formData['imagemPrincipal'] = itemEvent.imagemPrincipal;
        _formData['conteudo'] = itemEvent.conteudo;
        _imageUrlController.text = _formData['imagemPrincipal'];
        _formData['dataEvento'] = itemEvent.dataEvento;
      } else {
        // _formData['price'] = '';
      }
    }
  }

  void _updateImageUrl() {
    //atualize a interface gráfica de acordo com o que está no "_imageUrlController".
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endstWithPng = url.toLowerCase().endsWith('.png');
    bool endstWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endstWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endstWithPng || endstWithJpg || endstWithJpeg);
  }

  @override
  //liberar espaço de memória de objetos que foram removidos.
  void dispose() {
    super.dispose();
    _subtituloFocusNode.dispose();
    _conteudoFocusNode.dispose();
    _imagemPrincialFocusNode.removeListener(_updateImageUrl);
  }

  Future _saveForm() async {
    //
    bool isValid = _formKey.currentState.validate();
    //se formulário não for valido sai e não continue os passos abaixo.
    if (!isValid) {
      return;
    }
    //chama o "onSaved" de cada um dos formulários.
    //O "onSaved" adiciona os dados ao Map "_formData" quando este método for chamado.
    _formKey.currentState.save();

    //Objeto final criado nesta página de formulário
    final newEvento = EventoMODEL(
      id: _formData['id'],
      titulo: _formData['titulo'],
      subtitulo: _formData['subtitulo'],
      imagemPrincipal: _formData['imagemPrincipal'],
      conteudo: _formData['conteudo'],
      dataEvento: selectedDate,
    );

    final itemEvento = Provider.of<EventoProvider>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await itemEvento.addEvento(newEvento);
      } else {
        await itemEvento.updateItemEvento(newEvento);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: null,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Erro inesperado'),
          actions: [
            FlatButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //DATA MATERIAL
  // _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //     helpText: 'Data do Evento',
  //     context: context,
  //     initialEntryMode: DatePickerEntryMode.calendar,
  //     initialDate: selectedDate, // Refer step 1
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2030),
  //     cancelText: 'Cancelar',
  //     confirmText: 'Confirmar',
  //     errorFormatText: 'Data fora do range permitido',
  //     errorInvalidText: 'Data fora do range permitido',
  //     fieldLabelText: 'Booking date',
  //     fieldHintText: 'Date/Month/Year',
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.dark(), // This will change to light theme.
  //         child: child,
  //       );
  //     },

  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

//DATA
  buildCupertinoDatePicker(BuildContext context) {
     
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (picked) {

                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              initialDateTime: selectedDate,
              //minimumDate: DateTime(2021),
              minimumYear: 2020,
              maximumYear: 2040,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _formData.isEmpty
            ? Text('Adicionar Evento')
            : Text('Editar Evento'),
        actions: [
          IconButton(
            icon: _isLoading ? Icon(Icons.save) : LinearProgressIndicator(),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                maxLines: 1, maxLength: 100,
                initialValue: _formData['titulo'],
                decoration: InputDecoration(labelText: 'Titulo'),
                textInputAction: TextInputAction.next,
                //"em campo submetido" acionado quando clica no botão do teclado virtual "next".
                onFieldSubmitted: (_) {
                  //direciona (ou foca) o cursor para o formulário que tem o "focusNode: _priceFocusNode".
                  FocusScope.of(context).requestFocus(_subtituloFocusNode);
                },
                //recebe o texto que foi colocado neste formulário, e salve em no Map "_formData".
                onSaved: (value) => _formData['titulo'] = value,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Informe um titulo valido';
                  }
                  if (value.trim().length <= 2) {
                    return 'Informe um título com no mínimo 3 letras!';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['subtitulo'],
                decoration: InputDecoration(labelText: 'Subtitulo'),
                //descrição com espaçamento de 3 linhas. //descrição com até 255 caracteres.
                maxLines: 2, maxLength: 107,
                //"Tipo de teclado" nete caso adiciona o botão "enter" no teclado para pular linha.
                textInputAction: TextInputAction.next,
                //"nó de foco" algum formulário aponta o cursor para este nó.
                focusNode: _subtituloFocusNode,
                //recebe o texto que foi colocado neste field, como se fosse o controller e salve no Map "_formData".
                onSaved: (value) => _formData['subtitulo'] = value,
                onFieldSubmitted: (_) {
                  //direciona (ou foca) o cursor para o formulário que tem o "focusNode: _priceFocusNode".
                  FocusScope.of(context).requestFocus(_imagemPrincialFocusNode);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      //initialValue: _formData['imagemPrincipal'],
                      //este campo será preenchido automáticamente pelo didChangeDependencies() caso este produtos seja chamado para atualizar

                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      //"Tipo de teclado" nete caso foi otimizado para URL's.
                      keyboardType: TextInputType.url,
                      //parecido com "keyboardType". ação ao apertar o botão "done".
                      textInputAction: TextInputAction.next,
                      focusNode: _imagemPrincialFocusNode,
                      //captura o texto digitado.
                      controller: _imageUrlController,
                      //recebe o texto que foi colocado neste field, como se fosse o controller e salve no Map "_formData".
                      onSaved: (value) => _formData['imagemPrincipal'] = value,
                      onFieldSubmitted: (_) {
                        //direciona (ou foca) o cursor para o formulário que tem o "focusNode: _priceFocusNode".
                        FocusScope.of(context).requestFocus(_conteudoFocusNode);
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 170,
                    margin: EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_imageUrlController.text),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              TextFormField(
                //tela inicializa com os valores já preenchidos no Field.
                //usado para atualizar um produto, aqui chama o método didChangeDependencies().
                initialValue: _formData['conteudo'],
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(labelText: 'Conteúdo'),
                //descrição com espaçamento de 3 linhas. //descrição com até 255 caracteres.
                maxLines: 10,
                //"Tipo de teclado" nete caso adiciona o botão "enter" no teclado para pular linha.
                keyboardType: TextInputType.multiline,
                //"nó de foco" algum formulário aponta o cursor para este nó.
                focusNode: _conteudoFocusNode,
                //recebe o texto que foi colocado neste field, como se fosse o controller e salve no Map "_formData".
                onSaved: (value) => _formData['conteudo'] = value,
              ),
              SizedBox(height: 10),

              //DATA MATERIAL
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //     Text(
              //       "${selectedDate.toLocal()}".split(' ')[0],
              //       style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
              //     ),
              //     SizedBox(
              //       height: 20.0,
              //     ),
              //     RaisedButton(
              //       onPressed: () => _selectDate(context), // Refer step 3
              //       child: Text(
              //         'Select date',
              //         style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold),
              //       ),
              //       color: Colors.greenAccent,
              //     ),
              //   ],
              // ),

              //DATA
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Data do evento: ', style: TextStyle(fontSize: 15)),
                  FlatButton(
                    //DATA CUPERTINO
                    onPressed: () => buildCupertinoDatePicker(context), 
                    child: Text(
                      '${DateFormat('dd-MM-y - hh:mm').format(selectedDate.toLocal())}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    color: Colors.grey[100],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: FlatButton.icon(
                      colorBrightness: Brightness.dark,
                      color: Colors.green,
                      icon: Icon(Icons.save),
                      label: Text('Salvar'),
                      onPressed: () => _saveForm(),
                    ),
                  ),
                  FlatButton.icon(
                    colorBrightness: Brightness.dark,
                    color: Colors.red,
                    icon: Icon(Icons.cancel),
                    label: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
