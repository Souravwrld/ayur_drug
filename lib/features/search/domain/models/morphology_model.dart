class Morphology {
  final dynamic macroscopic; // Can be String or Map<String, dynamic>
  final dynamic microscopic; // Can be String or Map<String, dynamic>

  Morphology({
    required this.macroscopic,
    required this.microscopic,
  });

  factory Morphology.fromJson(Map<String, dynamic> json) {
    return Morphology(
      macroscopic: json['macroscopic'] ?? '',
      microscopic: json['microscopic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'macroscopic': macroscopic,
      'microscopic': microscopic,
    };
  }

  // Helper method to get macroscopic as formatted string
  String getMacroscopicAsString() {
    if (macroscopic is String) {
      return macroscopic;
    } else if (macroscopic is Map<String, dynamic>) {
      final map = macroscopic as Map<String, dynamic>;
      return map.entries
          .map((entry) => '${_capitalizeFirst(entry.key)}: ${entry.value}')
          .join('\n\n');
    }
    return '';
  }

  // Helper method to get microscopic as formatted string
  String getMicroscopicAsString() {
    if (microscopic is String) {
      return microscopic;
    } else if (microscopic is Map<String, dynamic>) {
      final map = microscopic as Map<String, dynamic>;
      return _formatMicroscopicMap(map);
    }
    return '';
  }

  // Helper method to get macroscopic as map (if it's a map)
  Map<String, dynamic>? getMacroscopicAsMap() {
    if (macroscopic is Map<String, dynamic>) {
      return macroscopic as Map<String, dynamic>;
    }
    return null;
  }

  // Helper method to get microscopic as map (if it's a map)
  Map<String, dynamic>? getMicroscopicAsMap() {
    if (microscopic is Map<String, dynamic>) {
      return microscopic as Map<String, dynamic>;
    }
    return null;
  }

  // Check if macroscopic is a detailed map
  bool get hasMacroscopicDetails => macroscopic is Map<String, dynamic>;

  // Check if microscopic is a detailed map
  bool get hasMicroscopicDetails => microscopic is Map<String, dynamic>;

  // Helper method to format microscopic map recursively
  String _formatMicroscopicMap(Map<String, dynamic> map, {int indentLevel = 0}) {
    final indent = '  ' * indentLevel;
    final entries = <String>[];

    for (final entry in map.entries) {
      final key = _capitalizeFirst(entry.key);
      
      if (entry.value is Map<String, dynamic>) {
        entries.add('$indent$key:');
        entries.add(_formatMicroscopicMap(entry.value as Map<String, dynamic>, indentLevel: indentLevel + 1));
      } else if (entry.value is String) {
        entries.add('$indent$key: ${entry.value}');
      } else {
        entries.add('$indent$key: ${entry.value.toString()}');
      }
    }

    return entries.join('\n');
  }

  // Helper method to capitalize first letter
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// Extension to make it easier to work with morphology data in UI
extension MorphologyDisplay on Morphology {
  // Get a list of macroscopic sections for UI display
  List<MorphologySection> getMacroscopicSections() {
    if (macroscopic is Map<String, dynamic>) {
      final map = macroscopic as Map<String, dynamic>;
      return map.entries.map((entry) {
        if (entry.value is Map<String, dynamic>) {
          return MorphologySection(
            title: _capitalizeFirst(entry.key),
            content: _formatMicroscopicMap(entry.value as Map<String, dynamic>),
            isNested: true,
            nestedData: entry.value as Map<String, dynamic>,
          );
        } else {
          return MorphologySection(
            title: _capitalizeFirst(entry.key),
            content: entry.value.toString(),
            isNested: false,
          );
        }
      }).toList();
    } else if (macroscopic is String && (macroscopic as String).isNotEmpty) {
      return [
        MorphologySection(
          title: 'Macroscopic',
          content: macroscopic as String,
          isNested: false,
        )
      ];
    }
    return [];
  }

  // Get a list of microscopic sections for UI display
  List<MorphologySection> getMicroscopicSections() {
    if (microscopic is Map<String, dynamic>) {
      final map = microscopic as Map<String, dynamic>;
      return map.entries.map((entry) {
        if (entry.value is Map<String, dynamic>) {
          return MorphologySection(
            title: _capitalizeFirst(entry.key),
            content: _formatMicroscopicMap(entry.value as Map<String, dynamic>),
            isNested: true,
            nestedData: entry.value as Map<String, dynamic>,
          );
        } else {
          return MorphologySection(
            title: _capitalizeFirst(entry.key),
            content: entry.value.toString(),
            isNested: false,
          );
        }
      }).toList();
    } else if (microscopic is String && (microscopic as String).isNotEmpty) {
      return [
        MorphologySection(
          title: 'Microscopic',
          content: microscopic as String,
          isNested: false,
        )
      ];
    }
    return [];
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatMicroscopicMap(Map<String, dynamic> map, {int indentLevel = 0}) {
    final indent = '  ' * indentLevel;
    final entries = <String>[];

    for (final entry in map.entries) {
      final key = _capitalizeFirst(entry.key);
      
      if (entry.value is Map<String, dynamic>) {
        entries.add('$indent$key:');
        entries.add(_formatMicroscopicMap(entry.value as Map<String, dynamic>, indentLevel: indentLevel + 1));
      } else if (entry.value is String) {
        entries.add('$indent$key: ${entry.value}');
      } else {
        entries.add('$indent$key: ${entry.value.toString()}');
      }
    }

    return entries.join('\n');
  }
}

// Helper class for structured morphology data
class MorphologySection {
  final String title;
  final String content;
  final bool isNested;
  final Map<String, dynamic>? nestedData;

  MorphologySection({
    required this.title,
    required this.content,
    required this.isNested,
    this.nestedData,
  });
}