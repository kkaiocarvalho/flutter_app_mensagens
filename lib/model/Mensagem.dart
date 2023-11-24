class Mensagem {
  String _emailSender;
  String _message;

  Mensagem(this._emailSender, this._message);

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get emailSender => _emailSender;

  set emailSender(String value) {
    _emailSender = value;
  }
}