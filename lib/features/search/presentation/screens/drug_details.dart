import 'package:ayur_drug/features/search/domain/models/drug_model.dart';
import 'package:ayur_drug/features/search/domain/models/morphology_model.dart';
import 'package:ayur_drug/features/search/domain/models/properties_model.dart';
import 'package:ayur_drug/features/search/domain/models/quality_standards_model.dart';
import 'package:flutter/material.dart';

class DrugDetailScreen extends StatelessWidget {
  final Drug drug;

  const DrugDetailScreen({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                drug.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8F65)],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_pharmacy,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Implement bookmark functionality
                },
                icon: const Icon(Icons.bookmark_border),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement share functionality
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(
                    title: 'Description',
                    child: Text(
                      drug.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Definition (if different from description)
                  if (drug.definition != null &&
                      drug.definition != drug.description)
                    _buildSection(
                      title: 'Definition',
                      child: Text(
                        drug.definition!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  // Ayurvedic Properties
                  if (_hasAyurvedicProperties(drug.properties))
                    _buildSection(
                      title: 'Ayurvedic Properties',
                      child: Column(
                        children: [
                          if (drug.properties.rasa.isNotEmpty)
                            _buildPropertyRow(
                                'Rasa', drug.properties.rasa.join(', ')),
                          if (drug.properties.guna.isNotEmpty)
                            _buildPropertyRow(
                                'Guna', drug.properties.guna.join(', ')),
                          if (drug.properties.virya.isNotEmpty)
                            _buildPropertyRow('Virya', drug.properties.virya),
                          if (drug.properties.vipaka.isNotEmpty)
                            _buildPropertyRow('Vipaka', drug.properties.vipaka),
                          if (drug.properties.karma.isNotEmpty)
                            _buildPropertyRow(
                                'Karma', drug.properties.karma.join(', ')),
                        ],
                      ),
                    ),

                  // Physical Properties
                  if (drug.physicalProperties?.hasData == true)
                    _buildPhysicalPropertiesSection(drug.physicalProperties!),

                  // Shodhana (Purification Process)
                  if (drug.shodhana != null)
                    _buildShodhanaSection(drug.shodhana!),

                  // Therapeutic Uses
                  if (drug.therapeuticUses.isNotEmpty)
                    _buildSection(
                      title: 'Therapeutic Uses',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: drug.therapeuticUses
                            .map((use) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFFF6B35)
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    use,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFF6B35),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // Dosage
                  if (drug.dosage.isNotEmpty)
                    _buildSection(
                      title: 'Dosage',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                drug.dosage,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Synonyms
                  if (drug.synonyms.isNotEmpty)
                    _buildSection(
                      title: 'Regional Names',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: drug.synonyms.entries
                            .where((entry) => entry.value.isNotEmpty)
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          '${entry.key.toUpperCase()}:',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          entry.value.join(', '),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // Morphology
                  _buildMorphologySection(drug),

                  // Formulations
                  if (drug.formulations.isNotEmpty)
                    _buildSection(
                      title: 'Formulations',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: drug.formulations
                            .map((formulation) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFFFF6B35),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          formulation,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // Constituents
                  if (drug.constituents.isNotEmpty)
                    _buildSection(
                      title: 'Chemical Constituents',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: drug.constituents
                            .map((constituent) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    constituent,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // Quality Standards
                  _buildQualityStandardsSection(drug.qualityStandards),

                  // Notes
                  if (drug.notes != null && drug.notes!.isNotEmpty)
                    _buildSection(
                      title: 'Notes',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.note,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                drug.notes!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasAyurvedicProperties(Properties properties) {
    return properties.rasa.isNotEmpty ||
        properties.guna.isNotEmpty ||
        properties.virya.isNotEmpty ||
        properties.vipaka.isNotEmpty ||
        properties.karma.isNotEmpty;
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalPropertiesSection(PhysicalProperties properties) {
    return _buildSection(
      title: 'Physical & Chemical Properties',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (properties.nature != null)
            _buildPropertyRow('Nature', properties.nature!),
          if (properties.colour != null)
            _buildPropertyRow('Colour', properties.colour!),
          if (properties.streak != null)
            _buildPropertyRow('Streak', properties.streak!),
          if (properties.cleavage != null)
            _buildPropertyRow('Cleavage', properties.cleavage!),
          if (properties.fracture != null)
            _buildPropertyRow('Fracture', properties.fracture!),
          if (properties.lustre != null)
            _buildPropertyRow('Lustre', properties.lustre!),
          if (properties.tenacity != null)
            _buildPropertyRow('Tenacity', properties.tenacity!),
          if (properties.transparency != null)
            _buildPropertyRow('Transparency', properties.transparency!),
          if (properties.hardness != null)
            _buildPropertyRow('Hardness', properties.hardness!),
          if (properties.specificGravity != null)
            _buildPropertyRow('Specific Gravity', properties.specificGravity!),
          if (properties.fluorescence != null)
            _buildPropertyRow('Fluorescence', properties.fluorescence!),
          if (properties.solubility != null)
            _buildPropertyRow('Solubility', properties.solubility!),
          if (properties.solubilityInAcid != null)
            _buildPropertyRow(
                'Solubility in Acid', properties.solubilityInAcid!),
          if (properties.description != null)
            _buildPropertyRow('Description', properties.description!),

          // Effect of Heat
          if (properties.effectOfHeat != null)
            _buildComplexPropertySection(
                'Effect of Heat', properties.effectOfHeat!),

          // Refractive Index
          if (properties.refractiveIndex != null)
            _buildComplexPropertySection(
                'Refractive Index', properties.refractiveIndex!),

          // Assay
          if (properties.assay != null)
            _buildComplexPropertySection('Assay', properties.assay!),

          // Heavy Metals and Arsenic
          if (properties.heavyMetalsAndArsenic != null)
            _buildComplexPropertySection(
                'Heavy Metals & Arsenic', properties.heavyMetalsAndArsenic!),

          // Other Elements
          if (properties.otherElements != null)
            _buildComplexPropertySection(
                'Other Elements', properties.otherElements!),
        ],
      ),
    );
  }

  Widget _buildComplexPropertySection(String title, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 8),
            ...data.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${_formatKey(entry.key)}:',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildShodhanaSection(Shodhana shodhana) {
    return _buildSection(
      title: 'Shodhana (Purification Process)',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requirement
            if (shodhana.requirement.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.purple, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Requirement',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                shodhana.requirement,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Reference
            if (shodhana.reference != null) ...[
              Text(
                shodhana.reference!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Ingredients
            if (shodhana.ingredients.isNotEmpty) ...[
              const Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              ...shodhana.ingredients
                  .map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 6, color: Colors.purple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${ingredient.name} - ${ingredient.quantity}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              const SizedBox(height: 16),
            ],

            // Method
            if (shodhana.method.isNotEmpty) ...[
              const Text(
                'Method:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shodhana.method,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQualityStandardsSection(QualityStandards qualityStandards) {
    // If it only has notes/description, show it differently
    if (qualityStandards.hasNotesOnly) {
      return _buildSection(
        title: 'Quality Standards',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  qualityStandards.notes!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If it has standard data, show in table format
    if (qualityStandards.hasStandardsData) {
      return _buildSection(
        title: 'Quality Standards',
        child: Column(
          children: [
            if (qualityStandards.foreignMatter.isNotEmpty)
              _buildQualityStandard(
                  'Foreign Matter', qualityStandards.foreignMatter),
            if (qualityStandards.totalAsh.isNotEmpty)
              _buildQualityStandard('Total Ash', qualityStandards.totalAsh),
            if (qualityStandards.acidInsolublAsh.isNotEmpty)
              _buildQualityStandard(
                  'Acid Insoluble Ash', qualityStandards.acidInsolublAsh),
            if (qualityStandards.alcoholSolubleExtractive.isNotEmpty)
              _buildQualityStandard('Alcohol Soluble Extractive',
                  qualityStandards.alcoholSolubleExtractive),
            if (qualityStandards.waterSolubleExtractive.isNotEmpty)
              _buildQualityStandard('Water Soluble Extractive',
                  qualityStandards.waterSolubleExtractive),
            if (qualityStandards.volatileOil != null)
              _buildQualityStandard(
                  'Volatile Oil', qualityStandards.volatileOil!),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildQualityStandard(String parameter, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              parameter,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorphologySection(Drug drug) {
    final macroscopicSections = drug.morphology.getMacroscopicSections();
    final microscopicSections = drug.morphology.getMicroscopicSections();

    if (macroscopicSections.isEmpty && microscopicSections.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      title: 'Morphology',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Macroscopic Section
          if (macroscopicSections.isNotEmpty) ...[
            _buildMorphologySubSection('Macroscopic', macroscopicSections),
            if (microscopicSections.isNotEmpty) const SizedBox(height: 20),
          ],

          // Microscopic Section
          if (microscopicSections.isNotEmpty) ...[
            _buildMorphologySubSection('Microscopic', microscopicSections),
          ],
        ],
      ),
    );
  }

  Widget _buildMorphologySubSection(
      String mainTitle, List<MorphologySection> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(height: 12),
        ...sections
            .map((section) => _buildMorphologyItem(
                  section.title,
                  section.content,
                  isNested: section.isNested,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildMorphologyItem(String title, String description,
      {bool isNested = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNested ? Colors.grey.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNested
              ? const Color(0xFFFF6B35).withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Row(
              children: [
                if (isNested) ...[
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isNested ? 15 : 14,
                      fontWeight: FontWeight.w600,
                      color:
                          isNested ? const Color(0xFFFF6B35) : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
