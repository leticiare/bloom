// Importa para codificar e decodificar dados JSON.
import 'dart:convert';
// Importa o pacote http para fazer requisições à API.
import 'package:http/http.dart' as http;
// Importa para armazenar dados de forma segura no dispositivo.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//                                  AUTH SERVICE

/// Serviço responsável pela gestão de autenticação, incluindo login,
/// armazenamento seguro de tokens e logout.
class AuthService {
  final String _baseUrl = "http://localhost:8000/api";
  final _storage = const FlutterSecureStorage();

  /// Realiza o processo de login com e-mail e senha.
  ///
  /// Retorna uma mensagem de erro em caso de falha, ou `null` em caso de sucesso.
  Future<String?> login(String email, String password) async {
    // Envia uma requisição POST para a rota de login da API.
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      // Define o cabeçalho para indicar que o corpo da requisição é um JSON.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Codifica os dados de e-mail e senha em um formato JSON para o corpo da requisição.
      body: json.encode(<String, String>{'email': email, 'senha': password}),
    );

    // Verifica se a requisição foi bem-sucedida (código 200).
    if (response.statusCode == 200) {
      await _storage.deleteAll();
      // Decodifica a resposta JSON.
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> dados = responseData['dados'];
      final String accessToken = dados['jwt_token'];

      // Armazena o token JWT de forma segura no dispositivo.
      await _storage.write(key: 'access_token', value: accessToken);

      return null; // Retorna `null` para indicar sucesso.
    } else {
      // Em caso de erro na requisição, tenta extrair a mensagem de erro da resposta.
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData['dados']['detail'] ??
            'Erro desconhecido ao fazer login.';
      } catch (e) {
        // Retorna uma mensagem genérica se a resposta do servidor não puder ser processada.
        return 'Erro ao processar a resposta do servidor.';
      }
    }
  }

  /// Recupera o token de acesso armazenado de forma segura.
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// Remove o token de acesso, efetivamente realizando o logout do usuário.
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}
