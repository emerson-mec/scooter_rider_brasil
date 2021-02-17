import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:direct_select/direct_select.dart';
import 'package:scooter_rider_brasil/exceptions/auth_exceptions.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';


// CÓGIDO ANTIGO
enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();

  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Ocorreu um erro!'),
              content: Text(msg),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await auth.signup(
          _authData["email"],
          _authData["password"],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Erro inexperado!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Login ? 290 : 371,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Informe um senha válida.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Senhas são diferentes';
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                    _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                  onPressed: _submit,
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                  'ALTERNAR PARA ${_authMode == AuthMode.Login ? 'REGISTRAR' : 'LOGIN'}',
                ),
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//CÓDIGO NOVO ////////////////////////////////////////////////////////////////////////
class AuthForm extends StatefulWidget {
  final void Function(Auth authData) onSubmit;
  final void Function(bool) mostrarLogo;

  AuthForm(this.onSubmit, this.mostrarLogo);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Auth _authData = Auth();

  final estados = const [
    "Selecione seu estado*",
    "Rio de Janeiro",
    "São Paulo",
    "Minas Gerais",
    "Santa Catarina",
    "Paraná"
  ];

  int selectedIndex = 0;

  List<Widget> _buildItem() {
    _authData.estado = estados[selectedIndex];
    return estados.map((val) => MySelectionItem(title: val)).toList();
  }

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // Fecha teclado

    if (_authData.isLogin) {
      if (isValid) {
        print('Login com dados corretos');
        widget.onSubmit(_authData);
      }
    } else if (_authData.isSignup) {
      if (isValid && selectedIndex != 0) {
        print('Cadastro com dados corretos');
        widget.onSubmit(_authData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.only(bottom: 60,top: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          border: Border.all(color: Colors.white54,width: 0.5),
          color:  Colors.white.withOpacity(0.2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        backgroundColor: Theme.of(context).primaryColor,
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
                if (_authData.isSignup)
                  TextFormField(
                    initialValue: _authData
                        .name, //para restaurar o nome ao alternar entre tela de cadastro e login
                    key: ValueKey('nome'), //para não embaralha os dados ao alternar tela de cadastro e login
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                    ),
                    style: TextStyle (
                      color: Colors.white,
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
                TextFormField(
                  key: ValueKey('email'), //para não embaralha os dados ao alternar tela de cadastro e login
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[800]),
                  ),
                  style: TextStyle (
                    color: Colors.white,
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
                TextFormField(
                  key: ValueKey('password'), //para não embaralha os dados ao alternar tela de cadastro e login
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.grey[800]),
                  ),
                  style: TextStyle (
                    color: Colors.white,
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
                RaisedButton(
                  elevation: 10,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  color: _authData.isLogin ? Colors.black87 : Colors.green[500],
                  child: Text(
                    _authData.isLogin ? 'Entrar' : 'Cadastrar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: _submit,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black54),
                  ),

                  child: FlatButton(
                    
                    textColor: Colors.black,
                    child: Text(_authData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já tenho uma contar',style: TextStyle(fontSize: 18),),
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
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
              margin: EdgeInsets.only(left: 5.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.57,
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(color: Colors.white, fontSize: 17),),
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
