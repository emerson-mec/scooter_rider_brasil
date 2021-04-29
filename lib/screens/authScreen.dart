import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/components/auth/authForm.dart';
import 'package:scooter_rider_brasil/exceptions/auth_exceptions.dart';
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

  Future<void> _submitForm(AuthModel authData) async {
    UserCredential  userCredential;

    setState(() => _isLoading = true);
    try {
      if (authData.isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: authData.emailUser.trim(),
          password: authData.password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: authData.emailUser.trim(),
          password: authData.password,
        );

        final ref = FirebaseStorage.instance
          .ref()
          .child('user_avatar')
          .child(userCredential.user.uid + '.jpg'); 

        await ref.putFile(authData.image);
        final url = await ref.getDownloadURL();
 
        final userData = {
          'nome': authData.name,
          'estado': authData.estado.toString(),
          'email': authData.emailUser,
          'id': userCredential.user.uid,
          'urlAvatar': url,
          'dataCadastro': Timestamp.now(),
          //'tipoUser': 'comum',
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set(userData);
      }
    } on FirebaseAuthException catch (err) {
      print('======= ${err.code}');
      
      var msg = AuthException(err.code);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg.toString()),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 7),
      ));
    
    } catch (err) {
      print('=>>>>>$err');
      
    } finally {
      setState(() => _isLoading = false);
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
              color: Colors.red,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFf3f5f7),
                  Color(0xFFd3dde7),
                ],
              ),

              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.9),
                  BlendMode.modulate,
                ),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fill,
                image: NetworkImage('https://i.pinimg.com/736x/41/6a/c1/416ac1aea1d23abf4573c308ff9bf9ab.jpg') ?? 'https://www.tricurioso.com/wp-content/uploads/2018/12/estradas-mais-longas-do-mundo.jpg',
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .12),
                if (_isLogo)
                  Container(
                    height: MediaQuery.of(context).size.width * 0.18,
                    child: Image.asset('assets/logo_srb3.png'),
                  ),
                if (_isLogo) SizedBox(height: 43),
                Stack(
                  children: [
                    AuthForm(_submitForm, _mostraLogo),
                    if (_isLoading)
                      Positioned.fill(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
                          child: Padding(
                            padding: const EdgeInsets.all(98.0),
                            child: Stack(fit: StackFit.loose, children: [
                              Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 20),
                                  Text(
                                    'Carregando...',
                                    style: TextStyle(color: Colors.white70),
                                  )
                                ],
                              )),
                              
                            ]),
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
