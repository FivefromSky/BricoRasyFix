import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfessionalService {
  final String id;
  final String name;
  final String dateCreation;
  final String dateExpiration;
  final String imagePath;
  final String localisation;
  final String? numtel;
  final String idc;
  final double prix;
  final List<String> categories;
  final String? description;

  ProfessionalService({
    required this.id,
    required this.name,
    required this.dateCreation,
    required this.dateExpiration,
    required this.imagePath,
    required this.localisation,
    required this.numtel,
    required this.idc,
    required this.prix,
    required this.categories,
    this.description,
  });

  factory ProfessionalService.fromJson(Map<String, dynamic> json) {
    final String apiBaseUrl = dotenv.env['API_BASE_URL']!;

    String safeString(dynamic v) => v?.toString() ?? '';

    final id = safeString(json['id'] ?? json['_id']);
    final name = safeString(json['name']);
    final dateCreation = safeString(json['date_creation']);
    final dateExpiration = safeString(json['date_expiration']);
    final localisation = safeString(json['localisation']);
    final numtel = safeString(json['numtel']);
    final idc = safeString(json['idc']);
    final description = safeString(json['description']);

    // parse prix en gérant Decimal128 de Mongo
    double prixValue = 0.0;
    final rawPrix = json['prix'];
    if (rawPrix is String) {
      prixValue = double.tryParse(rawPrix) ?? 0.0;
    } else if (rawPrix is num) {
      prixValue = rawPrix.toDouble();
    } else if (rawPrix is Map<String, dynamic> &&
        rawPrix.containsKey(r'$numberDecimal')) {
      prixValue = double.tryParse(rawPrix[r'$numberDecimal']) ?? 0.0;
    }

    // photos → first URL
    final List<dynamic> rawPhotos = json['photo'] as List<dynamic>;
    final imagePath =
        rawPhotos.isNotEmpty ? '$apiBaseUrl/uploads/${rawPhotos.first}' : '';

    // types → categories
    final List<String> categories =
        (json['types'] as List<dynamic>?)?.whereType<String>().toList() ?? [];

    return ProfessionalService(
      id: id,
      name: name,
      dateCreation: dateCreation,
      dateExpiration: dateExpiration,
      imagePath: imagePath,
      localisation: localisation,
      numtel: numtel.isEmpty ? null : numtel,
      idc: idc,
      prix: prixValue,
      categories: categories,
      description: description.isEmpty ? null : description,
    );
  }
}
