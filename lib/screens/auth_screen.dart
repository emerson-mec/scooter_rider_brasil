import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scooter_rider_brasil/components/auth_card.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScrenn extends StatefulWidget {
  @override
  _AuthScrennState createState() => _AuthScrennState();
}

class _AuthScrennState extends State<AuthScrenn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLogo = true;
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    Future<void> _handleSubmit(Auth authData) async {
      try {
        if (authData.isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: authData.emailUser.trim(), password: authData.password);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: authData.emailUser.trim(), password: authData.password);
      }
      } on PlatformException catch (err) {

        // final msg = err.message ?? 'Ocorreu um erro! Verifique suas credencias.';
        var msg  ;
        print(err.code);

        switch (err.code) {
          case 'ERROR_WRONG_PASSWORD':
            msg = 'Senha errada';
            break;
          case 'ERROR_USER_DISABLED':
            msg = 'Usuário desativado pelo administrador. Entre em contato com scooterriderbrasil@gmail.com';
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
            msg = 'Muitas tentativas. Fale conosco pelo e-mail: scooterriderbrasil@gmail.com ou tente tente mais tarde!';
            break;
          case 'ERROR_INVALID_EMAIL':
            msg = 'Endereço de e-mail inválido';
            break;
          case 'ERROR_USER_NOT_FOUND':
            msg = 'Usuário não encontrado';
            break;
          case 'ERROR_OPERATION_NOT_ALLOWED':
            msg = 'Ocorreu um erro na autenticação.';
            break;
          default: msg = 'Tentativa de autenticação falhou.\n- Verifique sua internet';
        }

          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg),backgroundColor: Theme.of(context).errorColor,duration: Duration(seconds: 7),));

      }catch(err){
        print('=>>>>>$err');
      }
    }

    void _mostraLogo(booleano) {
      setState(() {
        showLogo = !showLogo;
      });
    }

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
          Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  if (showLogo)
                    Container(
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: Image.asset('assets/logo_srb2.png'),
                    ),
                  if (showLogo)
                    Text(
                      'Scooter Rider',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                  if (showLogo) SizedBox(height: 40),
                  if (!showLogo)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Criar conta',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  AuthForm(_handleSubmit, _mostraLogo),
                  SizedBox(height: 300),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
