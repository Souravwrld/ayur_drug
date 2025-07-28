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
      rasa: _parseStringOrList(json['rasa']),
      guna: _parseStringOrList(
          json['guna'] ?? json['guṇa']), // Handle both spellings
      virya:
          _parseVirya(json['virya'] ?? json['vīrya']), // Enhanced virya parsing
      vipaka: json['vipaka'] ?? json['vipāka'] ?? '', // Handle both spellings
      karma: _parseStringOrList(json['karma']),
    );
  }

  // Enhanced virya parser to handle both string and array
  static String _parseVirya(dynamic value) {
    if (value == null) {
      return '';
    } else if (value is String) {
      return value;
    } else if (value is List && value.isNotEmpty) {
      // If it's an array, take the first value or join them
      if (value.length == 1) {
        return value[0].toString();
      } else {
        // Join multiple values with " / " to show alternatives
        return value.map((v) => v.toString()).join(' / ');
      }
    } else {
      return value.toString();
    }
  }

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
