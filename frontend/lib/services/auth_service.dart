import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Authenticate with backend
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken != null) {
          await _authenticateBackend(idToken);
        }
      }
      return googleUser;
    } catch (error) {
      if (kDebugMode) {
        print('Google Sign In Error: $error');
      }
      return null;
    }
  }

  Future<void> _authenticateBackend(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Backend Auth Success: ${response.body}');
        }
      } else {
        throw Exception('Backend Auth Failed: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Backend Connection Error: $e');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
