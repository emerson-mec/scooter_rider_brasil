enum AuthMode {
  LOGIN, //logar
  SIGNUP, //inscrever-se
}

class AuthModel {
  String name;
  String emailUser;
  String password;
  String estado;
  AuthMode _mode = AuthMode.LOGIN;
  
  bool get isSignup => _mode == AuthMode.SIGNUP;
  bool get isLogin => _mode == AuthMode.LOGIN;

  void toggleMode() => _mode = _mode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
}
