class ApiExeption implements Exception {
  final String message;

  ApiExeption(this.message);
}

class UnknownApiExeption implements Exception {
  final int statusCode;

  UnknownApiExeption(this.statusCode);
}

