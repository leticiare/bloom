import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço responsável por lidar com a lógica de registro de usuários.
class RegistrationService {
  final String _baseUrl = 'http://localhost:8000/api';

  /// Realiza o registro de um novo usuário.
  ///
  /// Recebe um mapa de dados com as informações do usuário.
  /// Retorna o token de acesso em caso de sucesso ou uma mensagem de erro.
  Future<String?> register({required Map<String, dynamic> userData}) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_baseUrl/auth/registro/${userData['perfil'].toLowerCase()}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBody['token']);
          return null; // Retorna null para indicar sucesso
        }
      } else {
        return responseBody['detail'] ?? "Ocorreu um erro desconhecido.";
      }
    } catch (e) {
      return 'Erro de conexão: verifique sua rede.';
    }
    return 'Erro desconhecido.';
  }
}
