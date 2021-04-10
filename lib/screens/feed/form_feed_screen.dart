import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';

class FormularioFeedScreen extends StatefulWidget {
  @override
  _FormularioFeedScreenState createState() => _FormularioFeedScreenState();
}

class _FormularioFeedScreenState extends State<FormularioFeedScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  //salva aqui o valor de cada "onSaved" de cada formulário.
  final Map<String, Object> _formData = {};
  
  //FocusNode == "nó de foco". Algum formulário aponta o cursor para este nó.
  final _subtituloFocusNode = FocusNode();
  final _conteudoFocusNode = FocusNode();
  final _imagemPrincialFocusNode = FocusNode();

  bool _isLoading = true;

  /////////////////////////////////////////////


  int _radioValue = -1;
  void _radioTipoFeed(int value) {
    setState(() {
      _radioValue = value;
    });

    switch (_radioValue) {
      case 0:
        _formData['tipoFeed'] = TipoFeed.noticia;
        break;
      case 1:
        _formData['tipoFeed'] = TipoFeed.patrocinado;
        break;
      case 2:
        _formData['tipoFeed'] = TipoFeed.dica;
        break;
      case 3:
        _formData['tipoFeed'] = TipoFeed.review;
        break;
    }
  }

  int _radioValue2 = -1;
  void _radioEstado(int value) {
    setState(() {
      _radioValue2 = value;
    });

    switch (_radioValue2) {
      case 0:
        _formData['estado'] = EstadosFeed.TODOS;
        break;
      case 1:
        _formData['estado'] = EstadosFeed.RJ;
        break;
      case 2:
        _formData['estado'] = EstadosFeed.SP;
        break;
      case 3:
        _formData['estado'] = EstadosFeed.MG;
        break;
      case 4:
        _formData['estado'] = EstadosFeed.SC;
        break;
      default:
        _formData['estado'] = EstadosFeed.TODOS;
        break;
    }
  }

  
  @override
  void initState() {
    super.initState();
    //Escute "_imageUrlFocusNode", Sempre que houver entrada e saida do cursor do campo "URL da imagem" chame a fn setState:
    _imagemPrincialFocusNode.addListener(_updateImageUrl);
  }

  //QUANDO FOR EDITAR
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final itemFeedModal = ModalRoute.of(context).settings.arguments as FeedMODEL;

    if (_formData.isEmpty) {
      if (itemFeedModal != null) {
        _formData['idFeed'] = itemFeedModal.idFeed;
        _formData['titulo'] = itemFeedModal.titulo;
        _formData['subtitulo'] = itemFeedModal.subtitulo;
        _formData['imagemPrincipal'] = itemFeedModal.imagemPrincipal;
        _formData['conteudo'] = itemFeedModal.conteudo;
        _formData['tipoFeed'] = itemFeedModal.tipoFeed;
        _formData['dataPublicacao'] = itemFeedModal.dataPublicacao;
        _formData['estado'] = itemFeedModal.estado;

        
        //POSICIONAR O RADIO QUANDO FOR EDITAR 
        int radioFeed(FeedMODEL itemFeedModal){
          switch (itemFeedModal.tipoFeedAsText) {
            case "Notícia":
              return 0;
            case "Patrocínado":
              return 1;
            case "Dica":
              return 2;
            case "Review":
              return 3;
            default: 
               return 0;
          }
        }
        _radioTipoFeed(radioFeed(itemFeedModal));
        
        
        //POSICIONAR O RADIO QUANDO FOR EDITAR 
        int radioEstado(FeedMODEL itemFeedModal){
          switch (itemFeedModal.estadoFeedAsText) {
            case "Todos":
              return 0;
            case "Rio de Janeiro":
              return 1;
            case "São Paulo":
              return 2;
            case "Minas Gerais":
              return 3;
            case "Santa Catarina":
              return 4;
            default: 
               return 0;
          }
        }
       _radioEstado(radioEstado(itemFeedModal));
       
        //COLOCA A URL QUANDO FOR EDITAR
        _imageUrlController.text = _formData['imagemPrincipal'];
      } 
    }
  }

  //ATUALIZA INTERFACE GRÁFICA de acordo com o que está no "_imageUrlController.text".
  void _updateImageUrl() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  //VALIDA URL
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
    _subtituloFocusNode.dispose();
    _conteudoFocusNode.dispose();
    _imagemPrincialFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    super.dispose();
  }

  //CHAMADO QUANDO CLICA EM NO BOTÃO "SALVAR"
  Future _saveForm() async {
    //se todos os campos do form forem válidos, retorne true.
    bool isValid = _formKey.currentState.validate();
    
    //não deixa salvar se formulário não for valido.
    if (!isValid || _radioValue == -1 || _radioValue2 == -1) {
      return;
    }
    _formKey.currentState.save();

    final newFeed = FeedMODEL(
      idFeed: _formData['idFeed'], //o id será passado quando o "addFeed()" for chamado.
      titulo: _formData['titulo'],
      subtitulo: _formData['subtitulo'],
      imagemPrincipal: _formData['imagemPrincipal'],
      conteudo: _formData['conteudo'],
      tipoFeed: _formData['tipoFeed'],
      dataPublicacao: DateTime.now(),  
      estado: _formData['estado'],
    );

    

    setState(() {
      _isLoading = true;
    });

    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    try {
      if (_formData['idFeed'] == null) {
        await feedProvider.addFeed(newFeed);
      } else {
        await feedProvider.updateFeed(newFeed);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: null,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Erro inesperado'),
          actions: [
            TextButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _formData.isEmpty
            ? Text('Adicionar Feed')
            : Text('Editar item Feed'),
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

              Text('ID: ${_formData['idFeed']}'),
              Text('DATA: ${_formData['dataPublicacao']}'),

              // TIPO DE FEED
              Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      _radioValue == -1
                          ? Text(
                              '*Tipo de Feed:',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(
                              '*Tipo de Feed:',
                              style: TextStyle(color: Colors.grey),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _radioTipoFeed,
                          ),
                          Text('notícia'),
                          Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _radioTipoFeed,
                          ),
                          Text('patrocinado'),
                          Radio(
                            value: 2,
                            groupValue: _radioValue,
                            onChanged: _radioTipoFeed,
                          ),
                          Text('dica'),
                          Radio(
                            value: 3,
                            groupValue: _radioValue,
                            onChanged: _radioTipoFeed,
                          ),
                          Text('review'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // ESTADO
              Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      _radioValue2 == -1
                          ? Text(
                              '*Estado:',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(
                              '*Estado:',
                              style: TextStyle(color: Colors.grey),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 0,
                            groupValue: _radioValue2,
                            onChanged: _radioEstado,
                          ),
                          Text('Todos'),
                          Radio(
                            value: 1,
                            groupValue: _radioValue2,
                            onChanged: _radioEstado,
                          ),
                          Text('RJ'),
                          Radio(
                            value: 2,
                            groupValue: _radioValue2,
                            onChanged: _radioEstado,
                          ),
                          Text('SP'),
                          Radio(
                            value: 3,
                            groupValue: _radioValue2,
                            onChanged: _radioEstado,
                          ),
                          Text('MG'),
                          Radio(
                            value: 4,
                            groupValue: _radioValue2,
                            onChanged: _radioEstado,
                          ),
                          Text('SC'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // TITULO
              TextFormField(
                maxLines: 1, maxLength: 100,
                initialValue: _formData['titulo'],
                decoration: InputDecoration(labelText: '*Titulo'),
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
             
              // SUBTITULO
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
              
              // URL DA IMAGEM
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
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe um URL';
                        }
                        if (!isValidImageUrl(value.toString())) {
                          return 'Informe uma URL válida. \nFormato: .png / .jpg / .jpeg';
                        }
                        return null;
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
             
              // CONTEUDO
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
               
              // BOTÕES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: _isLoading ? Icon(Icons.save) : Icon(Icons.save_alt),
                    label: Text('Salvar'),
                    onPressed: () => _saveForm(),
                  ),
                  TextButton.icon(
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
