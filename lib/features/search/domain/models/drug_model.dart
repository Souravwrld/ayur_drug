// Enhanced Drug model to handle additional fields
import 'package:ayur_drug/features/search/domain/models/morphology_model.dart';
import 'package:ayur_drug/features/search/domain/models/properties_model.dart';
import 'package:ayur_drug/features/search/domain/models/quality_standards_model.dart';

// Enhanced Drug model with additional fields
class Drug {
  final String id;
  final String name;
  final String description;
  final String? definition;
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

  // Additional fields from the new format
  final String? broadClassification;
  final OriginAndOccurrence? originAndOccurrence;
  final PhysicalProperties? physicalProperties;
  final OpticalProperties? opticalProperties;
  final ChemicalProperties? chemicalProperties;
  final Shodhana? shodhana;
  final String? usageNote;
  final String? diagnosticProperty;
  final Attributes? attributes;
  final String? dose;
  final List<String>? importantFormulations;

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
    required this.formulations,
    required this.therapeuticUses,
    required this.dosage,
    this.notes,
    required this.searchKeywords,
    this.broadClassification,
    this.originAndOccurrence,
    this.physicalProperties,
    this.opticalProperties,
    this.chemicalProperties,
    this.shodhana,
    this.usageNote,
    this.diagnosticProperty,
    this.attributes,
    this.dose,
    this.importantFormulations,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? json['definition'] ?? '',
      definition: json['definition'],
      synonyms: Map<String, List<String>>.from(
        json['synonyms']?.map(
                (key, value) => MapEntry(key, List<String>.from(value))) ??
            {},
      ),
      morphology: Morphology.fromJson(json['morphology'] ?? {}),
      qualityStandards: _parseQualityStandards(json['quality_standards']),

      constituents: List<String>.from(json['constituents'] ?? []),
      properties: Properties.fromJson(json['properties'] ?? {}),
      formulations: _parseFormulationsField(json['formulations']),
      therapeuticUses: List<String>.from(json['therapeutic_uses'] ?? []),
      dosage: _parseDosageField(json['dosage']),
      notes: _parseNotesField(json['notes']),
      searchKeywords: List<String>.from(json['search_keywords'] ?? []),
      broadClassification: json['broad_classification'],
      originAndOccurrence: json['origin_and_occurrence'] != null
          ? OriginAndOccurrence.fromJson(json['origin_and_occurrence'])
          : null,
      physicalProperties: json['physical_properties'] != null
          ? PhysicalProperties.fromJson(json['physical_properties'])
          : null,
      opticalProperties: json['optical_properties'] != null
          ? OpticalProperties.fromJson(json['optical_properties'])
          : null,
      chemicalProperties: json['chemical_properties'] != null
          ? ChemicalProperties.fromJson(json['chemical_properties'])
          : null,
      // Updated shodhana parsing to handle both string and object
      shodhana: json['shodhana'] != null
          ? (json['shodhana'] is String
              ? Shodhana(requirement: json['shodhana'] as String)
              : Shodhana.fromJson(json['shodhana']))
          : null,
      usageNote: json['usage_note'],
      diagnosticProperty: json['diagnostic_property'],
      attributes: json['attributes'] != null
          ? Attributes.fromJson(json['attributes'])
          : null,
      dose: json['dose'],
      importantFormulations: json['important_formulations'] != null
          ? List<String>.from(json['important_formulations'])
          : null,
    );
  }

  static String? _parseNotesField(dynamic notesValue) {
    if (notesValue == null) {
      return null;
    } else if (notesValue is String) {
      return notesValue.isEmpty ? null : notesValue;
    } else if (notesValue is List) {
      // Convert list to string or return null if empty
      if (notesValue.isEmpty) {
        return null;
      } else {
        // Join list items with newlines or commas
        return notesValue.map((item) => item.toString()).join('\n');
      }
    } else {
      // For any other type, convert to string
      return notesValue.toString();
    }
  }

  static List<String> _parseFormulationsField(dynamic formulationsValue) {
    if (formulationsValue == null) {
      return [];
    } else if (formulationsValue is List) {
      return List<String>.from(formulationsValue);
    } else if (formulationsValue is Map<String, dynamic>) {
      // Convert Map to List of formatted strings
      final formulations = <String>[];

      for (final entry in formulationsValue.entries) {
        if (entry.value is Map<String, dynamic>) {
          // Handle nested objects like "assay"
          final nestedMap = entry.value as Map<String, dynamic>;
          formulations.add('${_capitalizeKey(entry.key)}:');
          for (final nestedEntry in nestedMap.entries) {
            formulations.add(
                '  ${_capitalizeKey(nestedEntry.key)}: ${nestedEntry.value}');
          }
        } else {
          // Handle simple key-value pairs
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

// Helper method to capitalize and format keys
  static String _capitalizeKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Helper method to parse dosage field (can be String or List)
  static String _parseDosageField(dynamic dosageValue) {
    if (dosageValue == null) {
      return '';
    } else if (dosageValue is String) {
      return dosageValue;
    } else if (dosageValue is List) {
      // Convert list to string with bullet points or newlines
      if (dosageValue.isEmpty) {
        return '';
      } else {
        return dosageValue.map((item) => item.toString()).join('\n');
      }
    } else {
      // For any other type, convert to string
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
      // If it's a string, use the fromString factory constructor
      return QualityStandards.fromString(qualityStandardsValue);
    } else {
      return QualityStandards.fromJson({});
    }
  }
}

// New model classes for additional fields
class OriginAndOccurrence {
  final String? geologicalContext;
  final String? indianDeposits;

  OriginAndOccurrence({
    this.geologicalContext,
    this.indianDeposits,
  });

  factory OriginAndOccurrence.fromJson(Map<String, dynamic> json) {
    return OriginAndOccurrence(
      geologicalContext: json['geological_context'],
      indianDeposits: json['indian_deposits'],
    );
  }
}

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
    );
  }

  List<MapEntry<String, String>> getPropertyEntries() {
    final properties = <MapEntry<String, String>>[];

    if (nature != null) properties.add(MapEntry('Nature', nature!));
    if (colour != null) properties.add(MapEntry('Colour', colour!));
    if (streak != null) properties.add(MapEntry('Streak', streak!));
    if (cleavage != null) properties.add(MapEntry('Cleavage', cleavage!));
    if (fracture != null) properties.add(MapEntry('Fracture', fracture!));
    if (lustre != null) properties.add(MapEntry('Lustre', lustre!));
    if (tenacity != null) properties.add(MapEntry('Tenacity', tenacity!));
    if (transparency != null)
      properties.add(MapEntry('Transparency', transparency!));
    if (hardness != null) properties.add(MapEntry('Hardness', hardness!));
    if (specificGravity != null)
      properties.add(MapEntry('Specific Gravity', specificGravity!));
    if (fluorescence != null)
      properties.add(MapEntry('Fluorescence', fluorescence!));

    return properties;
  }
}

class OpticalProperties {
  final String? description;
  final RefractiveIndex? refractiveIndex;

  OpticalProperties({
    this.description,
    this.refractiveIndex,
  });

  factory OpticalProperties.fromJson(Map<String, dynamic> json) {
    return OpticalProperties(
      description: json['description'],
      refractiveIndex: json['refractive_index'] != null
          ? RefractiveIndex.fromJson(json['refractive_index'])
          : null,
    );
  }
}

class RefractiveIndex {
  final String? range;
  final String? nAlpha;
  final String? nBeta;
  final String? nGamma;
  final String? nOmega;
  final String? nEpsilon;

  RefractiveIndex({
    this.range,
    this.nAlpha,
    this.nBeta,
    this.nGamma,
    this.nOmega,
    this.nEpsilon,
  });

  factory RefractiveIndex.fromJson(Map<String, dynamic> json) {
    return RefractiveIndex(
      range: json['range'],
      nAlpha: json['n_alpha'],
      nBeta: json['n_beta'],
      nGamma: json['n_gamma'],
      nOmega: json['n_omega'],
      nEpsilon: json['n_epsilon'],
    );
  }
}

class ChemicalProperties {
  final dynamic effectOfHeat; // Can be String or Map<String, dynamic>
  final String? solubility;
  final String? solubilityInAcid;
  final String? reactionWithAcids;
  final Assay? assay;
  final HeavyMetalsAndArsenic? heavyMetalsAndArsenic;
  final OtherElements? otherElements;

  ChemicalProperties({
    this.effectOfHeat,
    this.solubility,
    this.solubilityInAcid,
    this.reactionWithAcids,
    this.assay,
    this.heavyMetalsAndArsenic,
    this.otherElements,
  });

  factory ChemicalProperties.fromJson(Map<String, dynamic> json) {
    return ChemicalProperties(
      effectOfHeat: json['effect_of_heat'],
      solubility: json['solubility'],
      solubilityInAcid: json['solubility_in_acid'],
      reactionWithAcids: json['reaction_with_acids'],
      assay: json['assay'] != null ? Assay.fromJson(json['assay']) : null,
      heavyMetalsAndArsenic: json['heavy_metals_and_arsenic'] != null
          ? HeavyMetalsAndArsenic.fromJson(json['heavy_metals_and_arsenic'])
          : null,
      otherElements: json['other_elements'] != null
          ? OtherElements.fromJson(json['other_elements'])
          : null,
    );
  }

  // Helper method to get effect of heat as formatted text
  String? getEffectOfHeatText() {
    if (effectOfHeat == null) return null;

    if (effectOfHeat is String) {
      return effectOfHeat as String;
    } else if (effectOfHeat is Map<String, dynamic>) {
      final effects = effectOfHeat as Map<String, dynamic>;
      return effects.entries
          .map((e) => '${e.key.replaceAll('_', ' ').toUpperCase()}: ${e.value}')
          .join('\n\n');
    }

    return null;
  }

  // Helper method to get effect of heat as map entries
  List<MapEntry<String, String>>? getEffectOfHeatEntries() {
    if (effectOfHeat == null) return null;

    if (effectOfHeat is Map<String, dynamic>) {
      final effects = effectOfHeat as Map<String, dynamic>;
      return effects.entries
          .map((e) => MapEntry(
              e.key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((word) => word.isEmpty
                      ? ''
                      : word[0].toUpperCase() + word.substring(1))
                  .join(' '),
              e.value.toString()))
          .toList();
    }

    return null;
  }
}

class Assay {
  final String? silicaSio2;
  final String? ironContent;

  Assay({
    this.silicaSio2,
    this.ironContent,
  });

  factory Assay.fromJson(Map<String, dynamic> json) {
    return Assay(
      silicaSio2: json['silica_sio2'],
      ironContent: json['iron_content'],
    );
  }
}

class HeavyMetalsAndArsenic {
  final String? limits;
  final String? lead;
  final String? arsenic;
  final String? cadmium;

  HeavyMetalsAndArsenic({
    this.limits,
    this.lead,
    this.arsenic,
    this.cadmium,
  });

  factory HeavyMetalsAndArsenic.fromJson(Map<String, dynamic> json) {
    return HeavyMetalsAndArsenic(
      limits: json['limits'],
      lead: json['lead'],
      arsenic: json['arsenic'],
      cadmium: json['cadmium'],
    );
  }

  List<MapEntry<String, String>> getMetalEntries() {
    final metals = <MapEntry<String, String>>[];

    if (lead != null) metals.add(MapEntry('Lead', lead!));
    if (arsenic != null) metals.add(MapEntry('Arsenic', arsenic!));
    if (cadmium != null) metals.add(MapEntry('Cadmium', cadmium!));

    return metals;
  }
}

class OtherElements {
  final String? limits;
  final String? iron;
  final String? aluminium;
  final String? magnesium;
  final String? potassium;
  final String? titanium;

  OtherElements({
    this.limits,
    this.iron,
    this.aluminium,
    this.magnesium,
    this.potassium,
    this.titanium,
  });

  factory OtherElements.fromJson(Map<String, dynamic> json) {
    return OtherElements(
      limits: json['limits'],
      iron: json['iron'],
      aluminium: json['aluminium'],
      magnesium: json['magnesium'],
      potassium: json['potassium'],
      titanium: json['titanium'],
    );
  }

  List<MapEntry<String, String>> getElementEntries() {
    final elements = <MapEntry<String, String>>[];

    if (iron != null) elements.add(MapEntry('Iron', iron!));
    if (aluminium != null) elements.add(MapEntry('Aluminium', aluminium!));
    if (magnesium != null) elements.add(MapEntry('Magnesium', magnesium!));
    if (potassium != null) elements.add(MapEntry('Potassium', potassium!));
    if (titanium != null) elements.add(MapEntry('Titanium', titanium!));

    return elements;
  }
}

class Shodhana {
  final String? requirement;
  final String? reference;
  final List<Ingredient>? ingredients;
  final String? method;

  Shodhana({
    this.requirement,
    this.reference,
    this.ingredients,
    this.method,
  });

  factory Shodhana.fromJson(Map<String, dynamic> json) {
    return Shodhana(
      requirement: json['requirement'],
      reference: json['reference'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : null,
      method: json['method'],
    );
  }
}

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}

class Attributes {
  final PropertiesAndActions? propertiesAndActions;
  final List<String>? therapeuticUses;

  Attributes({
    this.propertiesAndActions,
    this.therapeuticUses,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      propertiesAndActions: json['properties_and_actions'] != null
          ? PropertiesAndActions.fromJson(json['properties_and_actions'])
          : null,
      therapeuticUses: json['therapeutic_uses'] != null
          ? List<String>.from(json['therapeutic_uses'])
          : null,
    );
  }
}

class PropertiesAndActions {
  final List<String>? rasa;
  final List<String>? guna;
  final String? virya;
  final String? vipaka;
  final List<String>? karma;

  PropertiesAndActions({
    this.rasa,
    this.guna,
    this.virya,
    this.vipaka,
    this.karma,
  });

  factory PropertiesAndActions.fromJson(Map<String, dynamic> json) {
    return PropertiesAndActions(
      rasa: json['rasa'] != null ? List<String>.from(json['rasa']) : null,
      guna: json['guna'] != null ? List<String>.from(json['guna']) : null,
      virya: json['vīrya'] ?? json['virya'],
      vipaka: json['vipāka'] ?? json['vipaka'],
      karma: json['karma'] != null ? List<String>.from(json['karma']) : null,
    );
  }
}
