import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';

class FormularioFeedScreen extends StatefulWidget {
  @override
  _FormularioFeedScreenState createState() => _FormularioFeedScreenState();
}

class _FormularioFeedScreenState extends State<FormularioFeedScreen> {
  //FocusNode == "nó de foco". Algum formulário aponta o cursor para este nó.
  final _subtituloFocusNode = FocusNode();
  final _conteudoFocusNode = FocusNode();
  final _imagemPrincialFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //salva aqui o valor de cada "onSaved" de cada formulário.
  final Map<String, Object> _formData = {};
  bool _isLoading = true;

  int _radioValue = -1;
  void _radioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });

    switch (_radioValue) {
      case 0:
        _formData['tipoFeed'] = TipoFeed.noticia;
        break;
      case 2:
        _formData['tipoFeed'] = TipoFeed.patrocinado;
        break;
      case 3:
        _formData['tipoFeed'] = TipoFeed.review;
        break;
      case 4:
        _formData['tipoFeed'] = TipoFeed.dica;
        break;
    }
  }

  int _radioValue2 = -1;
  void _radioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
    });

    switch (_radioValue2) {
      case 0:
        _formData['estado'] = 'todos';
        break;
      case 1:
        _formData['estado'] = 'RJ';
        break;
      case 2:
        _formData['estado'] = 'SP';
        break;
      case 3:
        _formData['estado'] = 'MG';
        break;
      default:
        _formData['estado'] = 'todos';
        break;
    }
  }

  

  @override
  void initState() {
    super.initState();
    //Escute "_imageUrlFocusNode", Sempre que houver entrada e saida do cursor do campo "URL da imagem" chame a fn setState:
    _imagemPrincialFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final itemFeed = ModalRoute.of(context).settings.arguments as FeedMODEL;
      if (itemFeed != null) {
        _formData['idFeed'] = itemFeed.idFeed;
        _formData['titulo'] = itemFeed.titulo;
        _formData['subtitulo'] = itemFeed.subtitulo;
        _formData['imagemPrincipal'] = itemFeed.imagemPrincipal;
        _formData['conteudo'] = itemFeed.conteudo;
        _formData['tipoFeed'] = itemFeed.tipoFeed;
        _formData['estado'] = itemFeed.estado;
        //_formData['dataPublicacao'] = itemFeed.dataPublicacao;

        _radioValueChange(itemFeed.tipoFeed.index);

        int radioEstado(FeedMODEL itemFeed){
          switch (itemFeed.estado) {
            case "todos":
              return 0;
            case "RJ":
              return 1;
            case "SP":
              return 2;
            case "MG":
              return 3;
            default: 
               return 0;
          }
        }
       _radioValueChange2(radioEstado(itemFeed));

        _imageUrlController.text = _formData['imagemPrincipal'];
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
    if (_radioValue == -1) {
      return;
    }
    //chama o "onSaved" de cada um dos formulários.
    //O "onSaved" adiciona os dados ao Map "_formData" quando este método for chamado.
    _formKey.currentState.save();

    //Objeto final criado nesta página de formulário
    final newFeed = FeedMODEL(
      idFeed: _formData['idFeed'],
      titulo: _formData['titulo'],
      subtitulo: _formData['subtitulo'],
      imagemPrincipal: _formData['imagemPrincipal'],
      conteudo: _formData['conteudo'],
      tipoFeed: _formData['tipoFeed'],
      dataPublicacao: DateTime.now(),
      curtidas: 0,
      estado: _formData['estado'],
      //favorito: false,
    );
    setState(() {
      _isLoading = true;
    });

    final itemFeed = Provider.of<FeedProvider>(context, listen: false);

    try {
      if (_formData['idFeed'] == null) {
        await itemFeed.addFeed(newFeed);
      } else {
        await itemFeed.updateItemFeed(newFeed);
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
                            onChanged: _radioValueChange,
                          ),
                          Text('notícia'),
                          Radio(
                            value: 3,
                            groupValue: _radioValue,
                            onChanged: _radioValueChange,
                          ),
                          Text('review'),
                          Radio(
                            value: 4,
                            groupValue: _radioValue,
                            onChanged: _radioValueChange,
                          ),
                          Text('dica'),
                          Radio(
                            value: 2,
                            groupValue: _radioValue,
                            onChanged: _radioValueChange,
                          ),
                          Text('patrocinado'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                            onChanged: _radioValueChange2,
                          ),
                          Text('Todos'),
                          Radio(
                            value: 1,
                            groupValue: _radioValue2,
                            onChanged: _radioValueChange2,
                          ),
                          Text('RJ'),
                          Radio(
                            value: 2,
                            groupValue: _radioValue2,
                            onChanged: _radioValueChange2,
                          ),
                          Text('SP'),
                          Radio(
                            value: 3,
                            groupValue: _radioValue2,
                            onChanged: _radioValueChange2,
                          ),
                          Text('MG'),
                          
                       

    
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: FlatButton.icon(
                      colorBrightness: Brightness.dark,
                      color: Colors.green,
                      icon:
                          _isLoading ? Icon(Icons.save) : Icon(Icons.save_alt),
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
