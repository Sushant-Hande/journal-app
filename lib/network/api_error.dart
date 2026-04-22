
class ApiError {
  final String message;
  final int? statusCode;
  final String? code;

  const ApiError({required this.message, this.statusCode, this.code});
}
