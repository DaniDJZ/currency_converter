class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  String toString() {
    return '$_prefix$_message';
  }
}

class NoInternetException extends ApiException {
  NoInternetException() : super('Please Check Out Your Internet Connection...', '');
}

class FetchDataException extends ApiException {
  FetchDataException([message]) : super(message, 'Error During Communication: ');
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([message]) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends ApiException {
  InvalidInputException([message]) : super(message, 'Invalid Input: ');
}

class ApiRequestException extends ApiException {
  ApiRequestException([message]) : super(message, '');
}