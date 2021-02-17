import 'package:flutter/material.dart';

class ComparaScooter extends StatefulWidget {
  @override
  ComparaScooterState createState() => ComparaScooterState();
}

class ComparaScooterState extends State<ComparaScooter> {
  //------------------------------------------- CONFIGURAÇÃO GLOBAL
  var _corFontDescricao = Colors.white70;
  var _corBarraTitulos = Colors.black87;
  var _corFontTitulo = Colors.white;
  var _corBackgroundDescricao = Color.fromRGBO(11, 99, 160, 1);
  var _corFundoDescricaoColunaCentral = Colors.black12;
  var _tamanhoFontDescricao = 14.0;
  var _corMenu = Colors.white;

  bool _valorRadio = true;

  _escolhaRadio(valorSelecionado) {
    setState(() {
      _valorRadio = valorSelecionado;

      switch (_valorRadio) {
        case true:
          _corFontDescricao = Colors.white70;
          _corBarraTitulos = Colors.black87;
          _corFontTitulo = Colors.white;
          _corBackgroundDescricao = Colors.blue[900];
          _corFundoDescricaoColunaCentral = Colors.black12;
          _tamanhoFontDescricao = 14.0;
          _corMenu = Colors.white;
          break;

        case false: //Black
          _corFontDescricao = Colors.grey;
          _corBarraTitulos = Colors.black;
          _corFontTitulo = Colors.white38;
          _corBackgroundDescricao = Colors.blueGrey[900];
          _corFundoDescricaoColunaCentral = Colors.black26;
          _tamanhoFontDescricao = 14.0;
          _corMenu = Colors.black;
          break;

        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-------------------------------------- APP BAR
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "COMPARA SCOOTER",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
            fontStyle: FontStyle.normal,
            color: _valorRadio ? Colors.blue : Colors.lime,
          ),
        ),
        centerTitle: true,
        backgroundColor: _corMenu,
        elevation: _valorRadio ? 0 : 5,
      ),

      //////////////////////////////////////////////////////////////// BODY
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          //
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Column(
              children: <Widget>[
                //--------------------------------- TELA FOTO DA MOTO
                _telaFotoVs(),

                //--------------------------------- TRÊS PONTOS
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset(
                        "assets/tresPontos.png",
                        scale: 1.5,
                      ),
                      Image.asset(
                        "assets/tresPontos.png",
                        scale: 1.5,
                      ),
                    ],
                  ),
                ),

                //--------------------------------- MENU COMPARDOR
                menuCompara(),

                //RADIO
                Container(
                  height: 30,
                  color: _valorRadio ? Colors.white : Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Text(
                            'TEMA ESCURO: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      Radio(
                        value: true,
                        groupValue: _valorRadio,
                        onChanged: _escolhaRadio,
                        activeColor: Colors.green,
                      ),
                      Text('Não'),
                      Radio(
                        value: false,
                        groupValue: _valorRadio,
                        onChanged: _escolhaRadio,
                        activeColor: Colors.black54,
                      ),
                      Text('Sim'),
                    ],
                  ),
                ),
                //FIM RADIO

                // ----------------- CONTAINER TITULO E DESCRIÇÃO
                Column(
                  children: <Widget>[
                    //--------------------------------- TITULO "MOTOR"
                    Container(
                      height: 30,
                      color: _corBarraTitulos,
                      child: Center(
                        child: Text("MOTOR", style: estiloTitulo()),
                      ),
                    ),
                    //--------------------------------- DESCRIÇÃO DO MOTOR
                    textoMotor(
                      cavalosDir: "21 cv (7.0 rpm)",
                      cavalosEsq: "22 cv (7.5 rpm)",
                      cilindradaEsq: "150 cc",
                      torqueEsq: "2,5 Kgf.m",
                      torqueDir: "2,1 Kgf.m",
                      cilindradaDir: "160 cc",
                    ),

                    //---------------------------------- TITULO "DIMENSSÕES"
                    Container(
                      height: 30,
                      color: _corBarraTitulos,
                      child: Center(
                        child: Text("DIMENSÕES", style: estiloTitulo()),
                      ),
                    ),

                    //--------------------------------- DESCRIÇÃO DAS DIMENSSÕES
                    _descricaoDimensoes(
                        larguraEsq: "78 cm",
                        comprimentoEsq: "218 cm",
                        alturaEsq: "118 cm",
                        rodaEsqDianteira: "120/70 - aro 15",
                        rodaEsqTraseira: "120/80 - aro 16",
                        larguraDir: "68 cm",
                        comprimentoDir: "198 cm",
                        alturaDir: "128 cm",
                        rodaDirDianteira: "120/70 - aro 15",
                        rodaDirTraseira: "140/70 - aro 17"),
                    //------------------------------------------------ TITULO MAIS
                    Container(
                      height: 30,
                      color: _corBarraTitulos,
                      child: Center(
                        child: Text("MAIS INFORMAÇÕES", style: estiloTitulo()),
                      ),
                    ),

                    //------------------------------------------------ DESCRIÇÃO DE MAIS INFORMAÇÕES
                    _descricaoMaisInformacoes(
                      pesoDir: "178 Kg",
                      pesoEsq: "188 Kg",
                      tanqueDir: "8 Litros",
                      tanqueEsq: "6,6 Litros",
                      absDir: "Sim",
                      absEsq: "Não",
                      smartKeyDir: 'Não',
                      smartKeyEsq: 'Sim',
                      indingStopDir: 'Não',
                      indingStopEsq: 'Não',
                      usbDir: 'Sim',
                      usbEsq: 'Sim',
                      ledDir: 'Não',
                      ledEsq: 'Somente dianteira',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------- TELA DAS FOTOS
  _telaFotoVs() {
    return Container(
      height: 180,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: PageView(
              children: <Widget>[
                Image.asset('assets/pcx.jpg'),
                Image.asset('assets/pcx2.jpg'),
                Center(child: Text("Ver mais fotos...")),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              children: <Widget>[
                Image.asset('assets/nmax.jpg'),
                Image.asset('assets/nmax2.jpg'),
                Center(child: Text("Ver mais fotos...")),
              ],
            ),
          ),
        ],
      ),
    );
  }

//--------------------------- TELA ONDE MOSTRA O NOME DA MOTO

//--------------------------- DESCRIÇÃO DO MOTOR
  textoMotor({
    String cavalosEsq,
    torqueEsq,
    cilindradaEsq,
    cavalosDir,
    torqueDir,
    cilindradaDir,
  }) {
    return Container(
      height: 90,
      color: _corBackgroundDescricao,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(cavalosEsq, //cavalos Esquerda
                        style: styleDescricao()),
                    divider(0, 10),
                    Text(torqueEsq, //torque esquerda
                        style: styleDescricao()),
                    divider(0, 10),
                    Text(cilindradaEsq, //cilindradas esquerda
                        style: styleDescricao()),
                  ],
                ),
              ),
            ),
            Container(
                width: 108,
                margin: EdgeInsets.only(right: 8),
                color: _corFundoDescricaoColunaCentral,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Cavalos", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Torque", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Cilindradas", style: styleSubtituloCentral()),
                  ],
                )),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(cavalosDir, //cavalos direita
                        style: styleDescricao()),
                    divider(10, 0),
                    Text(torqueDir, //torque direita
                        style: styleDescricao()),
                    divider(10, 0),
                    Text(cilindradaDir, // cilindrada direita
                        style: styleDescricao()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------------- DESCRIÇÃO DAS DIMENSSÕES
  _descricaoDimensoes({
    String larguraEsq,
    comprimentoEsq,
    alturaEsq,
    rodaEsqDianteira,
    rodaEsqTraseira,
    larguraDir,
    comprimentoDir,
    alturaDir,
    rodaDirDianteira,
    rodaDirTraseira,
  }) {
    return Container(
      height: 140,
      color: _corBackgroundDescricao,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(larguraEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(comprimentoEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(alturaEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(rodaEsqDianteira, style: styleDescricao()),
                    divider(0, 10),
                    Text(rodaEsqTraseira, style: styleDescricao()),
                  ],
                ),
              ),
            ),
            Container(
                width: 108,
                color: _corFundoDescricaoColunaCentral,
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Largura", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Comprim.", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Altura", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Roda (diant.)", style: styleSubtituloCentral()),
                    divider(10, 10),
                    Text("Roda (tras.)", style: styleSubtituloCentral()),
                  ],
                )),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(larguraDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(comprimentoDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(alturaDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(rodaDirDianteira, style: styleDescricao()),
                    divider(10, 0),
                    Text(rodaDirTraseira, style: styleDescricao()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//------------------------------------------------ DESCRIÇÃO DE MAIS INFORMAÇÕES
  _descricaoMaisInformacoes(
      {pesoDir,
      tanqueDir,
      pesoEsq,
      tanqueEsq,
      absDir,
      absEsq,
      ledDir,
      ledEsq,
      smartKeyDir,
      smartKeyEsq,
      indingStopDir,
      indingStopEsq,
      usbDir,
      usbEsq}) {
    return Container(
      height: 185,
      color: _corBackgroundDescricao,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(pesoEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(tanqueEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(absEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(smartKeyEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(indingStopEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(usbEsq, style: styleDescricao()),
                    divider(0, 10),
                    Text(ledEsq, style: styleDescricao()),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8),
              width: 108,
              color: _corFundoDescricaoColunaCentral,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Peso", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("Tanque", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("ABS", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("Smart Key", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("Inding Stop", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("Tomada USB", style: styleSubtituloCentral()),
                  divider(10, 10),
                  Text("LED", style: styleSubtituloCentral()),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(pesoDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(tanqueDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(absDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(smartKeyDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(indingStopDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(usbDir, style: styleDescricao()),
                    divider(10, 0),
                    Text(ledDir, style: styleDescricao()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//MENU COMPARAÇÃO
  menuCompara() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: 60,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,

              //color: Colors.green,
              child: Column(
                children: <Widget>[
                  Text(
                    "Honda",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "PCX 150 (2020)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 176, 207, 33),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 35,
            child: Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(
                    'assets/vs2.png',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              child: Column(
                children: <Widget>[
                  Text(
                    "Yamaha",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "NMAX 160 (2019)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 176, 207, 33),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //------------------------------------------- FIM DO MENU COMPARDOR
    );
  }

//

  //
  //ESTILO DA FONTE INTERNA
  TextStyle styleDescricao() {
    return TextStyle(
        color: _corFontDescricao,
        fontSize: _tamanhoFontDescricao,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic);
  }

  //DIVISOR
  Divider divider([double endIndent = 0.0, double indent = 0.0]) {
    return Divider(
      color: Colors.white24,
      height: 0.5,
      thickness: 0.8,
      endIndent: endIndent,
      indent: indent,
    );
  }

  //
  TextStyle estiloTitulo() {
    return TextStyle(
      color: _corFontTitulo,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      fontSize: 25,
    );
  }

  //
  TextStyle styleSubtituloCentral() {
    return TextStyle(
      color: _valorRadio ? Colors.white70 : Colors.orange,
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );
  }
}
