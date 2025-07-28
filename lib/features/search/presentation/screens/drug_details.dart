import 'package:ayur_drug/features/search/domain/models/drug_model.dart';
import 'package:ayur_drug/features/search/domain/models/morphology_model.dart';
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

                  // Broad Classification
                  if (drug.broadClassification != null)
                    _buildSection(
                      title: 'Classification',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.category,
                              color: Colors.purple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                drug.broadClassification!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Origin and Occurrence
                  if (drug.originAndOccurrence != null)
                    _buildOriginAndOccurrenceSection(drug.originAndOccurrence!),

                  // Physical Properties
                  if (drug.physicalProperties != null)
                    _buildPhysicalPropertiesSection(drug.physicalProperties!),

                  // Optical Properties
                  if (drug.opticalProperties != null)
                    _buildOpticalPropertiesSection(drug.opticalProperties!),

                  // Chemical Properties
                  if (drug.chemicalProperties != null)
                    _buildChemicalPropertiesSection(drug.chemicalProperties!),

                  // Properties (Original Ayurvedic Properties)
                  _buildSection(
                    title: 'Ayurvedic Properties',
                    child: Column(
                      children: [
                        _buildPropertyRow(
                            'Rasa', drug.properties.rasa.join(', ')),
                        _buildPropertyRow(
                            'Guna', drug.properties.guna.join(', ')),
                        _buildPropertyRow('Virya', drug.properties.virya),
                        _buildPropertyRow('Vipaka', drug.properties.vipaka),
                        _buildPropertyRow(
                            'Karma', drug.properties.karma.join(', ')),
                      ],
                    ),
                  ),

                  // Attributes (Alternative Ayurvedic Properties)
                  if (drug.attributes?.propertiesAndActions != null)
                    _buildAttributesSection(drug.attributes!),

                  // Shodhana
                  if (drug.shodhana != null)
                    _buildShodhanaSection(drug.shodhana!),

                  // Diagnostic Property
                  if (drug.diagnosticProperty != null)
                    _buildSection(
                      title: 'Diagnostic Property',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.cyan.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.cyan,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                drug.diagnosticProperty!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Therapeutic Uses
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
                                  color:
                                      const Color(0xFFFF6B35).withOpacity(0.1),
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

                  // Dosage (using both dosage and dose fields)
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
                              drug.dose ?? drug.dosage,
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

                  // Important Formulations
                  if (drug.importantFormulations != null &&
                      drug.importantFormulations!.isNotEmpty)
                    _buildSection(
                      title: 'Important Formulations',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: drug.importantFormulations!
                            .map((formulation) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Color(0xFFFF6B35),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          formulation,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
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
                  _buildSection(
                    title: 'Quality Standards',
                    child: Column(
                      children: [
                        _buildQualityStandard('Foreign Matter',
                            drug.qualityStandards.foreignMatter),
                        _buildQualityStandard(
                            'Total Ash', drug.qualityStandards.totalAsh),
                        _buildQualityStandard('Acid Insoluble Ash',
                            drug.qualityStandards.acidInsolublAsh),
                        _buildQualityStandard('Alcohol Soluble Extractive',
                            drug.qualityStandards.alcoholSolubleExtractive),
                        _buildQualityStandard('Water Soluble Extractive',
                            drug.qualityStandards.waterSolubleExtractive),
                        if (drug.qualityStandards.volatileOil != null)
                          _buildQualityStandard('Volatile Oil',
                              drug.qualityStandards.volatileOil!),
                      ],
                    ),
                  ),

                  // Usage Note
                  if (drug.usageNote != null && drug.usageNote!.isNotEmpty)
                    _buildSection(
                      title: 'Usage Note',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                drug.usageNote!,
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

  Widget _buildOriginAndOccurrenceSection(OriginAndOccurrence origin) {
    return _buildSection(
      title: 'Origin & Occurrence',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (origin.geologicalContext != null) ...[
            _buildPropertyRow('Geological Context', origin.geologicalContext!),
          ],
          if (origin.indianDeposits != null) ...[
            _buildPropertyRow('Indian Deposits', origin.indianDeposits!),
          ],
        ],
      ),
    );
  }

  Widget _buildPhysicalPropertiesSection(PhysicalProperties physical) {
    final properties = physical.getPropertyEntries();
    if (properties.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      title: 'Physical Properties',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.indigo.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: properties
              .map(
                  (property) => _buildPropertyRow(property.key, property.value))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildOpticalPropertiesSection(OpticalProperties optical) {
    return _buildSection(
      title: 'Optical Properties',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (optical.description != null) ...[
            Text(
              optical.description!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (optical.refractiveIndex != null) ...[
            Text(
              'Refractive Index',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (optical.refractiveIndex!.range != null)
                    _buildPropertyRow('Range', optical.refractiveIndex!.range!),
                  if (optical.refractiveIndex!.nAlpha != null)
                    _buildPropertyRow('nα', optical.refractiveIndex!.nAlpha!),
                  if (optical.refractiveIndex!.nBeta != null)
                    _buildPropertyRow('nβ', optical.refractiveIndex!.nBeta!),
                  if (optical.refractiveIndex!.nGamma != null)
                    _buildPropertyRow('nγ', optical.refractiveIndex!.nGamma!),
                  if (optical.refractiveIndex!.nOmega != null)
                    _buildPropertyRow('nω', optical.refractiveIndex!.nOmega!),
                  if (optical.refractiveIndex!.nEpsilon != null)
                    _buildPropertyRow('nε', optical.refractiveIndex!.nEpsilon!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChemicalPropertiesSection(ChemicalProperties chemical) {
    return _buildSection(
      title: 'Chemical Properties',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Effect of Heat
          if (chemical.effectOfHeat != null) ...[
            Text(
              'Effect of Heat',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chemical.effectOfHeat is String) ...[
                    Text(
                      chemical.effectOfHeat as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ] else if (chemical.getEffectOfHeatEntries() != null) ...[
                    ...chemical
                        .getEffectOfHeatEntries()!
                        .map((entry) =>
                            _buildPropertyRow(entry.key, entry.value))
                        .toList(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Solubility Properties
          if (chemical.solubility != null) ...[
            _buildPropertyRow('Solubility', chemical.solubility!),
          ],
          if (chemical.solubilityInAcid != null) ...[
            _buildPropertyRow('Solubility in Acid', chemical.solubilityInAcid!),
          ],
          if (chemical.reactionWithAcids != null) ...[
            _buildPropertyRow(
                'Reaction with Acids', chemical.reactionWithAcids!),
          ],

          // Assay
          if (chemical.assay != null) ...[
            const SizedBox(height: 16),
            Text(
              'Assay',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (chemical.assay!.silicaSio2 != null)
                    _buildPropertyRow(
                        'Silica (SiO₂)', chemical.assay!.silicaSio2!),
                  if (chemical.assay!.ironContent != null)
                    _buildPropertyRow(
                        'Iron Content', chemical.assay!.ironContent!),
                ],
              ),
            ),
          ],

          // Heavy Metals and Arsenic
          if (chemical.heavyMetalsAndArsenic != null) ...[
            const SizedBox(height: 16),
            Text(
              'Heavy Metals & Arsenic',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (chemical.heavyMetalsAndArsenic!.limits != null)
                    _buildPropertyRow(
                        'Limits', chemical.heavyMetalsAndArsenic!.limits!),
                  ...chemical.heavyMetalsAndArsenic!
                      .getMetalEntries()
                      .map((entry) => _buildPropertyRow(entry.key, entry.value))
                      .toList(),
                ],
              ),
            ),
          ],

          // Other Elements
          if (chemical.otherElements != null) ...[
            const SizedBox(height: 16),
            Text(
              'Other Elements',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (chemical.otherElements!.limits != null)
                    _buildPropertyRow(
                        'Limits', chemical.otherElements!.limits!),
                  ...chemical.otherElements!
                      .getElementEntries()
                      .map((entry) => _buildPropertyRow(entry.key, entry.value))
                      .toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShodhanaSection(Shodhana shodhana) {
    return _buildSection(
      title: 'Shodhana (Purification)',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.pink.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shodhana.requirement != null) ...[
              _buildPropertyRow('Requirement', shodhana.requirement!),
            ],
            if (shodhana.reference != null) ...[
              _buildPropertyRow('Reference', shodhana.reference!),
            ],
            if (shodhana.ingredients != null &&
                shodhana.ingredients!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Ingredients',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              ...shodhana.ingredients!
                  .map((ingredient) =>
                      _buildPropertyRow(ingredient.name, ingredient.quantity))
                  .toList(),
            ],
            if (shodhana.method != null) ...[
              const SizedBox(height: 12),
              Text(
                'Method',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shodhana.method!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesSection(Attributes attributes) {
    final props = attributes.propertiesAndActions;
    if (props == null) return const SizedBox.shrink();

    return _buildSection(
      title: 'Alternative Ayurvedic Properties',
      child: Column(
        children: [
          if (props.rasa != null && props.rasa!.isNotEmpty)
            _buildPropertyRow('Rasa', props.rasa!.join(', ')),
          if (props.guna != null && props.guna!.isNotEmpty)
            _buildPropertyRow('Guna', props.guna!.join(', ')),
          if (props.virya != null) _buildPropertyRow('Vīrya', props.virya!),
          if (props.vipaka != null) _buildPropertyRow('Vipāka', props.vipaka!),
          if (props.karma != null && props.karma!.isNotEmpty)
            _buildPropertyRow('Karma', props.karma!.join(', ')),
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
