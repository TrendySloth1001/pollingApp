import 'package:flutter/material.dart';
import '../services/hello_service.dart';

class HomeController extends ChangeNotifier {
  final HelloService _helloService = HelloService();
  String _message = 'Press the button to say hello!';
  String get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchHello() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _helloService.fetchHello();
      _message = response.message;
    } catch (e) {
      _message = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
