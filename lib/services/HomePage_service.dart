// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bricorasy/models/bricole_service.dart';
import 'package:bricorasy/models/professional_service.dart';
import 'package:bricorasy/models/dummy_tool.dart';
import 'package:bricorasy/services/auth_services.dart'; // ← on importe AuthService
import 'package:flutter_dotenv/flutter_dotenv.dart';

class apiservice {
  static final _baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<List<BricoleService>> fetchServices() async {
    final uri = Uri.parse('$_baseUrl/api/annonce/bricole');
    final response = await http.get(
      uri,
      headers: AuthService.authHeader, // ← on ajoute l’en-tête JWT
    );

    if (response.statusCode != 200) {
      throw Exception('Échec du chargement: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List;
    return data
        .map((e) => BricoleService.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class apiService_pro {
  static final _baseUrl = dotenv.env['API_BASE_URL']!;
  static Future<List<ProfessionalService>> fetchServicePro() async {
    final uri = Uri.parse('$_baseUrl/api/annonce/professionnel');
    final response = await http.get(
      uri,
      headers: AuthService.authHeader, // ← idem ici
    );

    if (response.statusCode != 200) {
      throw Exception('Échec du chargement: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List;
    return data
        .map((e) => ProfessionalService.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class apiService_outil {
  static final _baseUrl = dotenv.env['API_BASE_URL']!;
  static Future<List<DummyTool>> fetchTools() async {
    final uri = Uri.parse('$_baseUrl/api/annonce/outil');
    final response = await http.get(
      uri,
      headers: AuthService.authHeader, // ← et ici
    );

    if (response.statusCode != 200) {
      throw Exception('Échec du chargement: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List;
    return data
        .map((e) => DummyTool.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
