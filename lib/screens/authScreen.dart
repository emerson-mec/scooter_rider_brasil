import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scooter_rider_brasil/components/authForm.dart';
import 'package:scooter_rider_brasil/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  bool _isLogo = true;
  bool _isLoading = false;


  Future<void>  _handleSubmit(AuthModel authData) async {
    AuthResult authResult;

    setState(() =>_isLoading = true);
    try {
      if (authData.isLogin) {
      authResult = await _auth.signInWithEmailAndPassword(
          email: authData.emailUser.trim(),
          password: authData.password,
      );
      
    } else {
      authResult= await _auth.createUserWithEmailAndPassword(
          email: authData.emailUser.trim(), 
          password: authData.password,
      );

      final userData = {
        'nome' : authData.name,
        'estado' : authData.estado,
        'email' : authData.emailUser,
      };

      await Firestore.instance.collection('users').document(authResult.user.uid).setData(userData);
      
    }
    } on PlatformException catch (err) {
      var msg ;
      // final msg = err.message ?? 'Ocorreu um erro! Verifique suas credencias.';
      switch (err.code) {
        case 'ERROR_WRONG_PASSWORD': msg = 'Senha errada'; break;
        case 'ERROR_USER_DISABLED': msg = 'Usuário desativado pelo administrador. Entre em contato com scooterriderbrasil@gmail.com'; break;
        case 'ERROR_TOO_MANY_REQUESTS': msg = 'Muitas tentativas. Fale conosco pelo e-mail: scooterriderbrasil@gmail.com ou tente tente mais tarde!'; break;
        case 'ERROR_INVALID_EMAIL': msg = 'Endereço de e-mail inválido'; break;
        case 'ERROR_USER_NOT_FOUND': msg = 'Usuário não encontrado'; break;
        case 'ERROR_OPERATION_NOT_ALLOWED': msg = 'Ocorreu um erro na autenticação.'; break;
        case 'ERROR_WEAK_PASSWORD': msg = 'Senha fraca.'; break;
        case 'ERROR_INVALID_EMAIL': msg = 'Endereço de e-mail incorreto.'; break;
        case 'ERROR_EMAIL_ALREADY_IN_USE': msg = 'E-mail já está sendo usado.'; break;
        default: msg = 'Tentativa de autenticação falhou.';
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg),backgroundColor: Theme.of(context).errorColor,duration: Duration(seconds: 7),));

    }catch(err){
      print('=>>>>>$err');
    }finally{
      setState(() =>_isLoading = false);
    }
  }

  void _mostraLogo(booleano) => setState(() => _isLogo = !_isLogo);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.7),
                  BlendMode.modulate,
                ),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fill,
                image: AssetImage('assets/image/background.jpg'),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .12),
                if (_isLogo)
                  Container(
                    height: MediaQuery.of(context).size.width * 0.22,
                    child: Image.asset('assets/logo_srb2.png'),
                  ),
                if (_isLogo)
                  Text(
                    'Scooter Rider',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                if (_isLogo) SizedBox(height: 43),
                if (!_isLogo)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Criar conta',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                Stack(
                  children: [
                    AuthForm(_handleSubmit, _mostraLogo),
                    if(_isLoading) Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7)),
                        child: Padding(
                          padding: const EdgeInsets.all(98.0),
                          child: Stack(fit: StackFit.expand, children:[CircularProgressIndicator(), Positioned(top: 80,left: 45, child: Text('Carregando...', style: TextStyle(color: Colors.white70),))]),
                        ),
                      ),
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
}
