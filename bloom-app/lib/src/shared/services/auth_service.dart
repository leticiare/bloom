import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // A URL base da sua API. Use o IP 10.0.2.2 para o emulador Android
  // se a API estiver rodando localmente na sua máquina.
  final String _baseUrl = "http://10.0.2.2:8000/api/v1";
  final _storage = const FlutterSecureStorage();

  // Função para realizar o login
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      // A API espera dados de formulário, não JSON
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];

      // Armazena o token de forma segura
      await _storage.write(key: 'access_token', value: accessToken);

      return null; // Sucesso
    } else {
      // Tenta decodificar a mensagem de erro da API
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData['detail'] ?? 'Erro desconhecido ao fazer login.';
      } catch (e) {
        return 'Erro ao processar a resposta do servidor.';
      }
    }
  }

  // Função para ler o token armazenado
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Função para fazer logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}
