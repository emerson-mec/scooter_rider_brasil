class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "O endereço de e-mail já está sendo usado por outra conta.",
    "OPERATION_NOT_ALLOWED": "Login e senha está desativado para você.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":"Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum.",
    "EMAIL_NOT_FOUND": "Não há registro de usuário correspondente a este identificador. O usuário pode ter sido excluído.",
    "INVALID_PASSWORD": "A senha é inválida ou o usuário não possui uma senha.",
    "USER_DISABLED": "A conta do usuário foi desabilitada por um administrador.",

    //a partir do FiresStone
    'ERROR_OPERATION_NOT_ALLOWED' : 'contas de e-mail e senha não estão ativadas',
  };

  final String key;
  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro na autenticação.';
    }
  }
}


class PlatformException implements Exception {
  static const Map<String, String> errors = {
    //a partir do FiresStone
    'ERROR_WRONG_PASSWORD':
             'Senha errada',
           
          'ERROR_USER_DISABLED':
              'Usuário desativado pelo administrador. Entre em contato com scooterriderbrasil@gmail.com',
            
           'ERROR_TOO_MANY_REQUESTS':
             'Muitas tentativas falhas de Login, tente tente mais tarde!',
            
           'ERROR_INVALID_EMAIL':
             'Endereço de e-mail inválido',
            
           'ERROR_USER_NOT_FOUND':
             'Usuário não encontrado',
            
           'ERROR_OPERATION_NOT_ALLOWED':
             'Ocorreu um erro na autenticação.',
            
  };

  final String key;
  PlatformException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro na autenticação.';
    }
  }
}
