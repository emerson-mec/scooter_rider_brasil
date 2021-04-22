import 'dart:io';

import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';
import 'package:scooter_rider_brasil/components/auth/user_Image_picker.dart';
import 'package:scooter_rider_brasil/models/auth_model.dart';



//CÓDIGO NOVO ////////////////////////////////////////////////////////////////////////
class AuthForm extends StatefulWidget {
  final void Function(AuthModel authData) onSubmit;
  final void Function(bool) mostrarLogo;
  
  AuthForm(this.onSubmit, this.mostrarLogo);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthModel _authData = AuthModel();


  // MÉTODO SELECT ESTADO ///////////////////////////////
  final estados = const [
    "Selecione seu estado*",
    "RJ",
    "SP",
    "MG",
    "SC",
  ];
  int selectedIndex = 0;
  List<Widget> _buildItem() {
    _authData.estado = estados[selectedIndex];
    return estados.map((val) => MySelectionItem(title: val)).toList();
  }

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // Fecha teclado

    //VALIDAR SE USUÁRIO ESCOLHEU UMA FOTO
    if (_authData.image == null && _authData.isSignup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Precisamos da sua foto!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (_authData.isLogin) {
      if (isValid) {
        //dados corretos
        widget.onSubmit(_authData);
      }
    } else if (_authData.isSignup) {
      if (isValid && selectedIndex != 0) {
        widget.onSubmit(_authData);
      }
    }
  }

  //FOTO QUE VEM DE UserImagePicker (componente filho (UserImagePicker) passando pro pai(AuthForm))
  void _handlePickedImage( File image){
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(bottom: 40,top: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.black38,width: 0.5),
        color:  Colors.white.withOpacity(0.80),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGEM PICKER
              if (_authData.isSignup)
              UserImagePicker(_handlePickedImage),
              SizedBox(height: 10),
              //ESTADO
              if (_authData.isSignup)
                Row(
                  children: [
                    Center(
                      child: Text(
                        "Estado:",
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Colors.red
                              : Colors.grey[800],
                          fontSize: 20,
                        ),
                      ),
                    ),
                    DirectSelect(
                      backgroundColor: Colors.white,
                      itemExtent: 55.0,
                      selectedIndex: selectedIndex,
                      child: MySelectionItem(
                        isForList: false,
                        title: estados[selectedIndex],
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      mode: DirectSelectMode.tap,
                      items: _buildItem(),
                    ),


                  
                  ],
                ),
                
              //NOME
              if (_authData.isSignup)
                TextFormField(
                  initialValue: _authData.name, //para restaurar o nome ao alternar entre tela de cadastro e login
                  key: ValueKey('nome'), //para não embaralha os dados ao alternar tela de cadastro e login
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.grey[800]),
                  ),
                  style: TextStyle (
                    color: Colors.blue[600],
                    fontSize: 20,
                  ), 
                  onChanged: (value) => _authData.name = value,
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return 'nome muito pequeno';
                    }
                    return null;
                  },
                ),
              // EMAIL
              TextFormField(
                key: ValueKey('email'), //para não embaralha os dados ao alternar tela de cadastro e login
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey[800]),
                ),
                style: TextStyle (
                  color: Colors.blue[600],
                  fontSize: 20,
                ),
                onChanged: (value) => _authData.emailUser = value,
                validator: (value) {
                  if (value == null ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
              // SENHA
              TextFormField(
                key: ValueKey('password'), //para não embaralha os dados ao alternar tela de cadastro e login
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.grey[800]),
                ),
                style: TextStyle (
                  color: Colors.blue[600],
                  fontSize: 20,
                ), 
                onChanged: (value) => _authData.password = value,
                validator: (value) {
                  if (value == null || value.trim().length < 7) {
                    return 'senha muito pequena';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              // ENTRAR OU CADASTRAR
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    _authData.isLogin ? 'Entrar' : 'Cadastrar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                onPressed: _submit,
              ),
              SizedBox(height: 20),
              // CRIAR CONTA
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black54),
                ),

                child: TextButton(
                  child: Text(
                    _authData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já tenho uma conta',style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w400),),
                  onPressed: () {
                    widget.mostrarLogo(false);

                    FocusScope.of(context).unfocus();

                    setState(() {
                      _authData.toggleMode();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: isForList
          ? Padding(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.61,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.only(left: 5.0),
              child: Stack(
                //alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.57,
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(color: Colors.black, fontSize: 17),),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
    );
  }
}
