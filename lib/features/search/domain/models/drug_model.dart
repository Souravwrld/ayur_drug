// Enhanced Drug model to handle additional fields
import 'package:ayur_drug/features/search/domain/models/morphology_model.dart';
import 'package:ayur_drug/features/search/domain/models/properties_model.dart';
import 'package:ayur_drug/features/search/domain/models/quality_standards_model.dart';

// Updated Drug class to handle new data structure
class Drug {
  final String id;
  final String name;
  final String description;
  final String? definition;
  final Map<String, List<String>> synonyms;
  final Morphology morphology;
  final QualityStandards qualityStandards;
  final List<String> constituents;
  final Properties properties; // Ayurvedic properties (rasa, guna, etc.)
  final PhysicalProperties?
      physicalProperties; // New: Physical/chemical properties
  final List<String> formulations;
  final List<String> therapeuticUses;
  final String dosage;
  final String? notes;
  final List<String> searchKeywords;
  final Shodhana? shodhana; // New: Purification process

  Drug({
    required this.id,
    required this.name,
    required this.description,
    this.definition,
    required this.synonyms,
    required this.morphology,
    required this.qualityStandards,
    required this.constituents,
    required this.properties,
    this.physicalProperties,
    required this.formulations,
    required this.therapeuticUses,
    required this.dosage,
    this.notes,
    required this.searchKeywords,
    this.shodhana,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? json['definition'] ?? '',
      definition: json['definition'],
      synonyms: _parseSynonyms(json['synonyms']),
      morphology: Morphology.fromJson(json['morphology'] ?? {}),
      qualityStandards: _parseQualityStandards(json['quality_standards']),
      constituents: _parseConstituents(json['constituents']),
      properties: _parseProperties(json),
      physicalProperties: _parsePhysicalProperties(json['properties']),
      formulations: _parseFormulationsField(json['formulations']),
      therapeuticUses: _parseTherapeuticUses(json['therapeutic_uses']),
      dosage: _parseDosageField(json['dosage']),
      notes: _parseNotesField(json['notes']),
      searchKeywords: List<String>.from(json['search_keywords'] ?? []),
      shodhana: _parseShodhana(json),
    );
  }
  static Map<String, List<String>> _parseSynonyms(dynamic synonymsValue) {
    if (synonymsValue == null) {
      return <String, List<String>>{};
    }

    if (synonymsValue is List) {
      // Handle empty array or array format
      if (synonymsValue.isEmpty) {
        return <String, List<String>>{};
      }
      // If it's a list of strings, put them under 'general' key
      return <String, List<String>>{
        'general': List<String>.from(synonymsValue)
      };
    }

    if (synonymsValue is Map<String, dynamic>) {
      return Map<String, List<String>>.from(
        synonymsValue
            .map((key, value) => MapEntry(key, List<String>.from(value ?? []))),
      );
    }

    return <String, List<String>>{};
  }

  static List<String> _parseTherapeuticUses(dynamic therapeuticUsesValue) {
    if (therapeuticUsesValue == null) {
      return [];
    }

    if (therapeuticUsesValue is List) {
      return List<String>.from(therapeuticUsesValue);
    }

    if (therapeuticUsesValue is Map<String, dynamic>) {
      final uses = <String>[];

      // Handle nested structure with internal/external categories
      therapeuticUsesValue.forEach((key, value) {
        if (value is List) {
          // Add category prefix to distinguish internal vs external uses
          final categoryPrefix = key == 'internal'
              ? 'Internal: '
              : key == 'external'
                  ? 'External: '
                  : '$key: ';

          for (final use in value) {
            uses.add('$categoryPrefix$use');
          }
        } else if (value is String) {
          uses.add('$key: $value');
        }
      });

      return uses;
    }

    if (therapeuticUsesValue is String) {
      return [therapeuticUsesValue];
    }

    return [];
  }

  // Parse constituents - can be array or object with ayurvedic properties
  static List<String> _parseConstituents(dynamic constituentsValue) {
    if (constituentsValue == null) {
      return [];
    } else if (constituentsValue is List) {
      return List<String>.from(constituentsValue);
    } else if (constituentsValue is Map<String, dynamic>) {
      // If constituents is a map (like in the new structure), extract non-ayurvedic properties
      final constituents = <String>[];
      for (final entry in constituentsValue.entries) {
        if (!_isAyurvedicProperty(entry.key)) {
          if (entry.value is List) {
            constituents.addAll(List<String>.from(entry.value));
          } else {
            constituents.add(entry.value.toString());
          }
        }
      }
      return constituents;
    }
    return [];
  }

  // Parse Ayurvedic properties from either 'properties' or 'constituents' field
  static Properties _parseProperties(Map<String, dynamic> json) {
    Map<String, dynamic>? propertiesData;

    // Check if properties field has ayurvedic data
    if (json['properties'] is Map<String, dynamic>) {
      final props = json['properties'] as Map<String, dynamic>;
      if (_hasAyurvedicProperties(props)) {
        propertiesData = props;
      }
    }

    // Check if constituents field has ayurvedic data
    if (propertiesData == null &&
        json['constituents'] is Map<String, dynamic>) {
      final constituents = json['constituents'] as Map<String, dynamic>;
      if (_hasAyurvedicProperties(constituents)) {
        propertiesData = constituents;
      }
    }

    return Properties.fromJson(propertiesData ?? {});
  }

  // Parse physical/chemical properties
  static PhysicalProperties? _parsePhysicalProperties(dynamic propertiesValue) {
    if (propertiesValue is Map<String, dynamic>) {
      // Check if it contains physical properties
      if (_hasPhysicalProperties(propertiesValue)) {
        return PhysicalProperties.fromJson(propertiesValue);
      }
    }
    return null;
  }

  // Parse shodhana from constituents or properties
  static Shodhana? _parseShodhana(Map<String, dynamic> json) {
    // Check in constituents first
    if (json['constituents'] is Map<String, dynamic>) {
      final constituents = json['constituents'] as Map<String, dynamic>;
      if (constituents.containsKey('shodhana')) {
        return Shodhana.fromJson(constituents['shodhana']);
      }
    }

    // Check in properties
    if (json['properties'] is Map<String, dynamic>) {
      final properties = json['properties'] as Map<String, dynamic>;
      if (properties.containsKey('shodhana')) {
        return Shodhana.fromJson(properties['shodhana']);
      }
    }

    return null;
  }

  static bool _isAyurvedicProperty(String key) {
    return ['rasa', 'guna', 'virya', 'vipaka', 'karma', 'shodhana']
        .contains(key);
  }

  static bool _hasAyurvedicProperties(Map<String, dynamic> data) {
    return data.keys.any((key) => _isAyurvedicProperty(key));
  }

  static bool _hasPhysicalProperties(Map<String, dynamic> data) {
    const physicalKeys = [
      'nature',
      'colour',
      'streak',
      'cleavage',
      'fracture',
      'lustre',
      'tenacity',
      'transparency',
      'hardness',
      'specific_gravity',
      'effect_of_heat',
      'solubility',
      'fluorescence',
      'refractive_index'
    ];
    return data.keys.any((key) => physicalKeys.contains(key));
  }

  // Keep existing helper methods
  static String? _parseNotesField(dynamic notesValue) {
    if (notesValue == null) {
      return null;
    } else if (notesValue is String) {
      return notesValue.isEmpty ? null : notesValue;
    } else if (notesValue is List) {
      if (notesValue.isEmpty) {
        return null;
      } else {
        return notesValue.map((item) => item.toString()).join('\n');
      }
    } else {
      return notesValue.toString();
    }
  }

  static List<String> _parseFormulationsField(dynamic formulationsValue) {
    if (formulationsValue == null) {
      return [];
    } else if (formulationsValue is List) {
      return List<String>.from(formulationsValue);
    } else if (formulationsValue is Map<String, dynamic>) {
      final formulations = <String>[];
      for (final entry in formulationsValue.entries) {
        if (entry.value is Map<String, dynamic>) {
          final nestedMap = entry.value as Map<String, dynamic>;
          formulations.add('${_capitalizeKey(entry.key)}:');
          for (final nestedEntry in nestedMap.entries) {
            formulations.add(
                '  ${_capitalizeKey(nestedEntry.key)}: ${nestedEntry.value}');
          }
        } else {
          formulations.add('${_capitalizeKey(entry.key)}: ${entry.value}');
        }
      }
      return formulations;
    } else if (formulationsValue is String) {
      return [formulationsValue];
    } else {
      return [formulationsValue.toString()];
    }
  }

  static String _capitalizeKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static String _parseDosageField(dynamic dosageValue) {
    if (dosageValue == null) {
      return '';
    } else if (dosageValue is String) {
      return dosageValue;
    } else if (dosageValue is List) {
      if (dosageValue.isEmpty) {
        return '';
      } else {
        return dosageValue.map((item) => item.toString()).join('\n');
      }
    } else {
      return dosageValue.toString();
    }
  }

  static QualityStandards _parseQualityStandards(
      dynamic qualityStandardsValue) {
    if (qualityStandardsValue == null) {
      return QualityStandards.fromJson({});
    } else if (qualityStandardsValue is Map<String, dynamic>) {
      return QualityStandards.fromJson(qualityStandardsValue);
    } else if (qualityStandardsValue is String) {
      return QualityStandards.fromString(qualityStandardsValue);
    } else {
      return QualityStandards.fromJson({});
    }
  }
}

// New class for Shodhana (purification process)
class Shodhana {
  final String requirement;
  final String? reference;
  final List<ShodhanaIngredient> ingredients;
  final String method;

  Shodhana({
    required this.requirement,
    this.reference,
    required this.ingredients,
    required this.method,
  });

  factory Shodhana.fromJson(Map<String, dynamic> json) {
    return Shodhana(
      requirement: json['requirement'] ?? '',
      reference: json['reference'],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((ing) => ShodhanaIngredient.fromJson(ing))
              .toList() ??
          [],
      method: json['method'] ?? '',
    );
  }
}

class ShodhanaIngredient {
  final String name;
  final String quantity;

  ShodhanaIngredient({
    required this.name,
    required this.quantity,
  });

  factory ShodhanaIngredient.fromJson(Map<String, dynamic> json) {
    return ShodhanaIngredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}

// New class for Physical/Chemical Properties
class PhysicalProperties {
  final String? nature;
  final String? colour;
  final String? streak;
  final String? cleavage;
  final String? fracture;
  final String? lustre;
  final String? tenacity;
  final String? transparency;
  final String? hardness;
  final String? specificGravity;
  final String? fluorescence;
  final String? description;
  final Map<String, dynamic>? effectOfHeat;
  final String? solubility;
  final String? solubilityInAcid;
  final Map<String, dynamic>? refractiveIndex;
  final Map<String, dynamic>? assay;
  final Map<String, dynamic>? heavyMetalsAndArsenic;
  final Map<String, dynamic>? otherElements;

  PhysicalProperties({
    this.nature,
    this.colour,
    this.streak,
    this.cleavage,
    this.fracture,
    this.lustre,
    this.tenacity,
    this.transparency,
    this.hardness,
    this.specificGravity,
    this.fluorescence,
    this.description,
    this.effectOfHeat,
    this.solubility,
    this.solubilityInAcid,
    this.refractiveIndex,
    this.assay,
    this.heavyMetalsAndArsenic,
    this.otherElements,
  });

  factory PhysicalProperties.fromJson(Map<String, dynamic> json) {
    return PhysicalProperties(
      nature: json['nature'],
      colour: json['colour'],
      streak: json['streak'],
      cleavage: json['cleavage'],
      fracture: json['fracture'],
      lustre: json['lustre'],
      tenacity: json['tenacity'],
      transparency: json['transparency'],
      hardness: json['hardness'],
      specificGravity: json['specific_gravity'],
      fluorescence: json['fluorescence'],
      description: json['description'],
      effectOfHeat: json['effect_of_heat'] is Map<String, dynamic>
          ? json['effect_of_heat']
          : null,
      solubility: json['solubility'],
      solubilityInAcid: json['solubility_in_acid'],
      refractiveIndex: json['refractive_index'] is Map<String, dynamic>
          ? json['refractive_index']
          : null,
      assay: json['assay'] is Map<String, dynamic> ? json['assay'] : null,
      heavyMetalsAndArsenic:
          json['heavy_metals_and_arsenic'] is Map<String, dynamic>
              ? json['heavy_metals_and_arsenic']
              : null,
      otherElements: json['other_elements'] is Map<String, dynamic>
          ? json['other_elements']
          : null,
    );
  }

  // Helper method to check if there's any meaningful data
  bool get hasData =>
      nature != null ||
      colour != null ||
      streak != null ||
      cleavage != null ||
      fracture != null ||
      lustre != null ||
      tenacity != null ||
      transparency != null ||
      hardness != null ||
      specificGravity != null ||
      fluorescence != null ||
      description != null ||
      effectOfHeat != null ||
      solubility != null ||
      solubilityInAcid != null ||
      refractiveIndex != null ||
      assay != null ||
      heavyMetalsAndArsenic != null ||
      otherElements != null;
}
