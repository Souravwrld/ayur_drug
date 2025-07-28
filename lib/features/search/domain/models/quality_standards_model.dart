class QualityStandards {
  final String foreignMatter;
  final String totalAsh;
  final String acidInsolublAsh;
  final String alcoholSolubleExtractive;
  final String waterSolubleExtractive;
  final String? volatileOil;
  final String? notes; // Add this field to handle string descriptions

  QualityStandards({
    required this.foreignMatter,
    required this.totalAsh,
    required this.acidInsolublAsh,
    required this.alcoholSolubleExtractive,
    required this.waterSolubleExtractive,
    this.volatileOil,
    this.notes,
  });

  factory QualityStandards.fromJson(Map<String, dynamic> json) {
    return QualityStandards(
      foreignMatter: json['foreign_matter'] ?? '',
      totalAsh: json['total_ash'] ?? '',
      acidInsolublAsh: json['acid_insoluble_ash'] ?? '',
      alcoholSolubleExtractive: json['alcohol_soluble_extractive'] ?? '',
      waterSolubleExtractive: json['water_soluble_extractive'] ?? '',
      volatileOil: json['volatile_oil'],
      notes: json['notes'],
    );
  }

  // Factory constructor for when quality_standards is a string
  factory QualityStandards.fromString(String description) {
    return QualityStandards(
      foreignMatter: '',
      totalAsh: '',
      acidInsolublAsh: '',
      alcoholSolubleExtractive: '',
      waterSolubleExtractive: '',
      notes: description,
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
      'notes': notes,
    };
  }

  // Helper method to check if this contains actual quality standards data
  bool get hasStandardsData =>
      foreignMatter.isNotEmpty ||
      totalAsh.isNotEmpty ||
      acidInsolublAsh.isNotEmpty ||
      alcoholSolubleExtractive.isNotEmpty ||
      waterSolubleExtractive.isNotEmpty ||
      volatileOil != null;

  // Helper method to check if this only contains a description/notes
  bool get hasNotesOnly =>
      !hasStandardsData && notes != null && notes!.isNotEmpty;
}
