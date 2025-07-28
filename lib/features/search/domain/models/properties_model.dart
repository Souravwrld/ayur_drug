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
