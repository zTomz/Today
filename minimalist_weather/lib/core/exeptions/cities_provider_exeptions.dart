class CityAlreadyExistsExeption implements Exception {
  final String message;

  CityAlreadyExistsExeption({
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}
