abstract class Validator {
  final String errorText;
  Validator([this.errorText]);

  bool isValid(String text);
}

class NoEmptyValidator extends Validator {
  NoEmptyValidator([String errorText]) : super(errorText);

  @override
  bool isValid(String text) {
    return text.isNotEmpty;
  }
}

class EmailValidator extends Validator {
  EmailValidator([String errorText]) : super(errorText);

  static final RegExp _regExt = RegExp(r"(?:[a-z0-9!#$%&'"
  r"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"
  r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');

  @override
  bool isValid(String text) {
    return _regExt.hasMatch(text);
  }
}