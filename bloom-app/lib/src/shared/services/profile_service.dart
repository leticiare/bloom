import 'dart:convert';

import 'package:app/src/features/dashboard_pregnant/domain/entities/user_profile.dart';
import 'package:app/src/shared/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Perfil de exemplo da usuária.
final String mockPregnancyInfo = 'Primeira vez gestante';
final String mockAvatarUrl = 'https://i.pravatar.cc/150?img=1';
final String mockBabySize = '17 cm';
final String mockBabyWeight = '110 gr';
final int mockWeeksLeft = 16;
final int mockDaysLeft = 168;

class ProfileService {
  final String _baseUrl = "http://localhost:8000/api";
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  Future<UserProfile> getUser() async {
    String id = await _storage.read(key: 'user_id') ?? '';

    if (id.isEmpty) {
      await loadUserFromApi();
    }

    id = await _storage.read(key: 'user_id') ?? '';
    final name = await _storage.read(key: 'user_name');
    final dum = await _storage.read(key: 'user_dum');
    final dpp = await _storage.read(key: 'user_dpp');

    return UserProfile(
      name: name!,
      pregnancyInfo: mockPregnancyInfo,
      avatarUrl: mockAvatarUrl,
      babySize: mockBabySize,
      babyWeight: mockBabyWeight,
      dum: DateTime.parse(dum!),
      dpp: DateTime.parse(dpp!),
    );
  }

  Future<void> loadUserFromApi() async {
    final accessToken = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/perfil'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['dados']['Response'];

      await _storage.write(key: 'user_id', value: user['id']);
      await _storage.write(key: 'user_email', value: user['email']);
      await _storage.write(key: 'user_name', value: user['nome']);
      await _storage.write(key: 'user_profile', value: user['perfil']);
      await _storage.write(key: 'user_document', value: user['documento']);
      await _storage.write(
        key: 'user_birth_date',
        value: user['data_nascimento'],
      );
      await _storage.write(key: 'user_dum', value: user['dum']);
      await _storage.write(key: 'user_dpp', value: user['dpp']);
    } else {
      throw Exception('Falha ao carregar perfil do usuário');
    }
  }
}
