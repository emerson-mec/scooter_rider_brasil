import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scooter_rider_brasil/exceptions/auth_exceptions.dart';

//Faz parte do novo código
enum AuthMode {
  LOGIN, //logar
  SIGNUP, //inscrever-se
}

class Auth with ChangeNotifier {

//================= INICIO NOVO CÓDIGO =========================================
  String name;
  String emailUser;
  String password;
  String estado;
  AuthMode _mode = AuthMode.LOGIN;

  bool get isSignup => _mode == AuthMode.SIGNUP;
  bool get isLogin => _mode == AuthMode.LOGIN;
  
  void toggleMode() => _mode = _mode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
    
  
//================ FIM NOVO CÓDIGO ==============================================

  //atenção para o key do link. Pegue o key na configuração do projeto no Firebase.
  //coloque essa classe no provider com Provider proxy
  // documentação: https://firebase.google.com/docs/reference/rest/auth
  String _token;
  DateTime _expiryDate;
  String _email;
  String _userId; // ID para usuário criado

  bool get isAuth => token != null;
  String get userId => isAuth ? _userId : null;
  String get email => _email;
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD2hHSPMG9PgzDW0FooqvcOWyTRXmPi6f4';

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final responseBody = jsonDecode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _email = responseBody['email'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      notifyListeners();
    }

    return Future.value(); // para garantir que está voltando algo.
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _email = null;
    _userId = null;
    notifyListeners();
  }
}
