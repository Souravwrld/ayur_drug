// models/drug.dart
import 'package:ayur_drug/features/search/domain/models/morphology_model.dart';

class Drug {
  final String id;
  final String name;
  final String description;
  final Map<String, List<String>> synonyms;
  final Morphology morphology;
  final QualityStandards qualityStandards;
  final List<String> constituents;
  final Properties properties;
  final List<String> formulations;
  final List<String> therapeuticUses;
  final String dosage;
  final String? notes;
  final List<String> searchKeywords;

  Drug({
    required this.id,
    required this.name,
    required this.description,
    required this.synonyms,
    required this.morphology,
    required this.qualityStandards,
    required this.constituents,
    required this.properties,
    required this.formulations,
    required this.therapeuticUses,
    required this.dosage,
    this.notes,
    required this.searchKeywords,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      synonyms: Map<String, List<String>>.from(
        json['synonyms']?.map(
                (key, value) => MapEntry(key, List<String>.from(value))) ??
            {},
      ),
      morphology: Morphology.fromJson(json['morphology'] ?? {}),
      qualityStandards:
          QualityStandards.fromJson(json['quality_standards'] ?? {}),
      constituents: List<String>.from(json['constituents'] ?? []),
      properties: Properties.fromJson(json['properties'] ?? {}),
      formulations: List<String>.from(json['formulations'] ?? []),
      therapeuticUses: List<String>.from(json['therapeutic_uses'] ?? []),
      dosage: json['dosage'] ?? '',
      notes: json['notes'],
      searchKeywords: List<String>.from(json['search_keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'synonyms': synonyms,
      'morphology': morphology.toJson(),
      'quality_standards': qualityStandards.toJson(),
      'constituents': constituents,
      'properties': properties.toJson(),
      'formulations': formulations,
      'therapeutic_uses': therapeuticUses,
      'dosage': dosage,
      'notes': notes,
      'search_keywords': searchKeywords,
    };
  }
}

class QualityStandards {
  final String foreignMatter;
  final String totalAsh;
  final String acidInsolublAsh;
  final String alcoholSolubleExtractive;
  final String waterSolubleExtractive;
  final String? volatileOil;

  QualityStandards({
    required this.foreignMatter,
    required this.totalAsh,
    required this.acidInsolublAsh,
    required this.alcoholSolubleExtractive,
    required this.waterSolubleExtractive,
    this.volatileOil,
  });

  factory QualityStandards.fromJson(Map<String, dynamic> json) {
    return QualityStandards(
      foreignMatter: json['foreign_matter'] ?? '',
      totalAsh: json['total_ash'] ?? '',
      acidInsolublAsh: json['acid_insoluble_ash'] ?? '',
      alcoholSolubleExtractive: json['alcohol_soluble_extractive'] ?? '',
      waterSolubleExtractive: json['water_soluble_extractive'] ?? '',
      volatileOil: json['volatile_oil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foreign_matter': foreignMatter,
      'total_ash': totalAsh,
      'acid_insoluble_ash': acidInsolublAsh,
      'alcohol_soluble_extractive': alcoholSolubleExtractive,
      'water_soluble_extractive': waterSolubleExtractive,
      'volatile_oil': volatileOil,
    };
  }
}

class Properties {
  final List<String> rasa;
  final List<String> guna;
  final String virya;
  final String vipaka;
  final List<String> karma;

  Properties({
    required this.rasa,
    required this.guna,
    required this.virya,
    required this.vipaka,
    required this.karma,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      // Handle both single string and list of strings for rasa
      rasa: _parseStringOrList(json['rasa']),
      guna: List<String>.from(json['guna'] ?? []),
      virya: json['virya'] ?? '',
      vipaka: json['vipaka'] ?? '',
      karma: List<String>.from(json['karma'] ?? []),
    );
  }

  // Helper method to handle both string and list cases
  static List<String> _parseStringOrList(dynamic value) {
    if (value == null) {
      return [];
    } else if (value is String) {
      return [value];
    } else if (value is List) {
      return List<String>.from(value);
    } else {
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'rasa': rasa,
      'guna': guna,
      'virya': virya,
      'vipaka': vipaka,
      'karma': karma,
    };
  }
}
