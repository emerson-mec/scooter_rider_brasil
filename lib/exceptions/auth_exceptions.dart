class AuthException implements Exception {
  static const Map<String, String> errors = {
    'email-already-in-use': 'Já existe uma conta com esse e-mail.',
    'operation-not-allowed': 'Conta não ativada.',
    'weak-password': 'Senha muito fraca.',
    'user-not-found': 'E-mail inválido.',
    'invalid-email': 'E-mail inválido.',
    'too-many-requests': 'Muitas tentativas. tenta mais tarde',

    //a partir do FiresStone
    'ERROR_OPERATION_NOT_ALLOWED':'contas de e-mail e senha não estão ativadas',
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
