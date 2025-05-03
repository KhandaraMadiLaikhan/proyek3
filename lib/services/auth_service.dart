import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.0.107:8000/api/client';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Client?> register({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
    required int age,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: _headers,
        body: json.encode({
          'full_name': fullName,
          'username': username,
          'password': password,
          'password_confirmation': confirmPassword,
          'age': age,
          'gender': gender,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Client.fromJson(data['data']['client']..['access_token'] = data['data']['access_token']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<Client?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Client.fromJson(data['data']['client']..['access_token'] = data['data']['access_token']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}