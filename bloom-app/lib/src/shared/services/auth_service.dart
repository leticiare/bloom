import 'dart:convert'; // Importe o dart:convert para usar o json.encode
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // A URL base da sua API. Use o IP 10.0.2.2 para o emulador Android
  // se a API estiver rodando localmente na sua máquina.
  final String _baseUrl = "http://localhost:8000/api";
  final _storage = const FlutterSecureStorage();

  // Função para realizar o login
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'), // <-- CORREÇÃO 1: A rota é /token
      // CORREÇÃO 2: Mudar o cabeçalho
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      // CORREÇÃO 3: Enviar como mapa, não como JSON
      body: json.encode(<String, String>{'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> dados = responseData['dados'];
      final String accessToken = dados['jwt_token'];

      // Armazena o token de forma segura
      await _storage.write(key: 'access_token', value: accessToken);

      return null; // Sucesso
    } else {
      // Tenta decodificar a mensagem de erro da API
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData['mensagem'] ?? 'Erro desconhecido ao fazer login.';
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
