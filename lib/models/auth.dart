import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/store.dart';
import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _signOutTimer;

  bool get isAuthenticated {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuthenticated ? _token : null;
  String? get email => isAuthenticated ? _email : null;
  String? get userId => isAuthenticated ? _userId : null;

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyABPb8oA_wocAUQkGmIKiwokad4u5tDsZk';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoSignOut();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoSignIn() async {
    if (isAuthenticated) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoSignOut();
    notifyListeners();
  }

  void signOut() {
    Store.remove('userData').then((_) {
      _token = null;
      _email = null;
      _userId = null;
      _expiryDate = null;
      _clearSignOutTimer();
      notifyListeners();
    });
  }

  void _clearSignOutTimer() {
    _signOutTimer?.cancel();
    _signOutTimer = null;
  }

  void _autoSignOut() {
    _clearSignOutTimer();
    final expiresIn = _expiryDate?.difference(DateTime.now()).inSeconds;
    _signOutTimer = Timer(Duration(seconds: expiresIn ?? 0), signOut);
  }
}
