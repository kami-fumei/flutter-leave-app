// import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service for handling authentication tokens.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Key under which we store the token
  static const _tokenKey = 'accesstoken';
 static const _refreshtokenKey = 'refreshtoken';
  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Extracts the access token from the response headers,
  /// saves it securely, and returns the raw token.
  Future<void> saveTokenFromResponse(http.Response response) async {
    // On Flutter mobile, header names are normalized to lowercase
    final access = response.headers['accesstoken'];
    final refresh =response.headers['refreshtoken'];

    if (access == null||refresh==null) {
      throw Exception('No Authorization header in response');
    }

  
    try{
    await _storage.write(key: _tokenKey, value: access);
    await _storage.write(key: _refreshtokenKey, value:refresh );
    }
    catch(e){
      throw Exception('something went worng while saving the token err: $e');
    }
    // return token;
  }

  /// Reads the token from secure storage (or `null` if none)
  Future<Map<String,String>>getToken() async {
    final t=  await _storage.read(key: _tokenKey);
    final Map<String,String> header = {
      _tokenKey : "$t"
    };
   return header;
  }


  /// Deletes the stored token (e.g. on logout)
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
