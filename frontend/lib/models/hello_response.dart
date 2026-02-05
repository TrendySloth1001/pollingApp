class HelloResponse {
  final String message;

  HelloResponse({required this.message});

  factory HelloResponse.fromJson(Map<String, dynamic> json) {
    return HelloResponse(message: json['message'] as String);
  }
}
