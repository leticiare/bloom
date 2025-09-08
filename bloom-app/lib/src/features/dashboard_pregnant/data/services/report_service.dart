import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Serviço para gerar e baixar relatórios clínicos.
class ReportService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://127.0.0.1:8000/api/gestante';
  static const String _gestanteId = '2970c137-35bf-404f-bb2a-e0628960ab05';

  /// Baixa o relatório em PDF da API e salva localmente.
  /// Retorna o caminho do arquivo salvo ou lança uma exceção em caso de erro.
  Future<String> downloadReport({required String reportType}) async {
    final String? token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('$_baseUrl/relatorio/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'id_gestante': _gestanteId, 'tipo': reportType}),
    );

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/relatorio_prenatal.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Erro ao baixar o relatório: ${response.statusCode}');
    }
  }
}
