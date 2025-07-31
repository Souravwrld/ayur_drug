import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ayur_drug/features/search/domain/models/drug_model.dart';
import 'package:http/http.dart' as http;

class DrugRepository {
  // API endpoints for all 7 volumes
  static const List<String> apiEndpoints = [
    'http://94.23.35.117/ayurved/product_vol_1.json',
    'http://94.23.35.117/ayurved/product_vol_2.json',
    'http://94.23.35.117/ayurved/product_vol_3.json',
    'http://94.23.35.117/ayurved/product_vol_4.json',
    'http://94.23.35.117/ayurved/product_vol_5.json',
    'http://94.23.35.117/ayurved/product_vol_6.json',
    'http://94.23.35.117/ayurved/product_vol_7.json',
  ];

  // Cache for storing all drugs in memory
  static List<Drug>? _cachedDrugs;
  static bool _isLoading = false;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiration = Duration(hours: 24);

  /// Fetches all drugs from all volumes with proper error handling and caching
  Future<List<Drug>> _getAllDrugsFromAPI() async {
    // Return cached data if available and not expired
    if (_cachedDrugs != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheExpiration) {
        return _cachedDrugs!;
      }
    }

    // Prevent multiple simultaneous API calls
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedDrugs ?? [];
    }

    _isLoading = true;

    try {
      List<Drug> allDrugs = [];
      List<Future<http.Response>> futures = [];

      // Create concurrent requests for all volumes
      for (String endpoint in apiEndpoints) {
        futures.add(
          http.get(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ).timeout(const Duration(seconds: 30)),
        );
      }

      // Wait for all requests to complete
      List<http.Response> responses = await Future.wait(futures);

      // Process responses
      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];

        if (response.statusCode == 200) {
          try {
            final dynamic responseData = json.decode(response.body);
            List<dynamic> volumeData;

            // Handle different response structures
            if (responseData is List) {
              volumeData = responseData;
            } else if (responseData is Map &&
                responseData.containsKey('data')) {
              volumeData = responseData['data'];
            } else if (responseData is Map &&
                responseData.containsKey('products')) {
              volumeData = responseData['products'];
            } else if (responseData is Map &&
                responseData.containsKey('items')) {
              volumeData = responseData['items'];
            } else {
              print(
                  'Unexpected response structure from volume ${i + 1}: ${responseData.runtimeType}');
              continue;
            }

            final List<Drug> volumeDrugs = [];

            for (var drugData in volumeData) {
              try {
                final drug = Drug.fromJson(drugData);
                volumeDrugs.add(drug);
              } catch (parseError) {
                print(
                    'Error parsing individual drug in volume ${i + 1}: $parseError');
                print(
                    'Problematic data: ${drugData.toString().substring(0, 200)}...');
              }
            }

            allDrugs.addAll(volumeDrugs);
            print(
                'Successfully loaded ${volumeDrugs.length} drugs from volume ${i + 1}');
          } catch (e) {
            print('Error parsing data from volume ${i + 1}: $e');
          }
        } else {
          print('Failed to load volume ${i + 1}: HTTP ${response.statusCode}');
        }
      }

      // Cache the results
      _cachedDrugs = allDrugs;
      _lastFetchTime = DateTime.now();

      print('Total drugs loaded: ${allDrugs.length}');
      return allDrugs;
    } catch (e) {
      print('Error fetching drugs from API: $e');
      return _cachedDrugs ?? [];
    } finally {
      _isLoading = false;
    }
  }

  /// Get drugs by category with enhanced filtering
  Future<List<Drug>> getDrugsByCategory(String category) async {
    try {
      final List<Drug> allDrugs = await _getAllDrugsFromAPI();

      if (allDrugs.isEmpty) {
        return [];
      }
      return allDrugs;

      // final categoryLower = category.toLowerCase().trim();

      // return allDrugs.where((drug) {
      //   // Check if the drug belongs to the specified category
      //   return _drugBelongsToCategory(drug, categoryLower);
      // }).toList();
    } catch (e) {
      throw Exception('Failed to get drugs by category: $e');
    }
  }

  /// Helper method to determine if a drug belongs to a specific category
  bool _drugBelongsToCategory(Drug drug, String category) {
    switch (category) {
      case 'classical':
        return _isClassicalDrug(drug);
      case 'single herbs':
        return _isSingleHerb(drug);
      case 'rasayana':
        return _isRasayanaDrug(drug);
      case 'by disease':
        return true; // All drugs can be categorized by disease
      default:
        return false;
    }
  }

  /// Check if drug is a classical formulation
  bool _isClassicalDrug(Drug drug) {
    // Check in formulations
    for (final formulation in drug.formulations) {
      final formLower = formulation.toLowerCase();
      if (formLower.contains('churna') ||
          formLower.contains('kwatha') ||
          formLower.contains('ghrita') ||
          formLower.contains('taila') ||
          formLower.contains('lehya') ||
          formLower.contains('asava') ||
          formLower.contains('arishta') ||
          formLower.contains('vati') ||
          formLower.contains('rasa') ||
          formLower.contains('bhasma') ||
          formLower.contains('yoga')) {
        return true;
      }
    }

    // Check in therapeutic uses for classical terms
    for (final use in drug.therapeuticUses) {
      final useLower = use.toLowerCase();
      if (useLower.contains('classical') ||
          useLower.contains('traditional') ||
          useLower.contains('ayurvedic formula')) {
        return true;
      }
    }

    // Check in search keywords
    for (final keyword in drug.searchKeywords) {
      final keywordLower = keyword.toLowerCase();
      if (keywordLower.contains('classical') ||
          keywordLower.contains('formula') ||
          keywordLower.contains('yoga') ||
          keywordLower.contains('compound')) {
        return true;
      }
    }

    // Check if drug name suggests it's a classical preparation
    final nameLower = drug.name.toLowerCase();
    if (nameLower.contains('churna') ||
        nameLower.contains('kwatha') ||
        nameLower.contains('ghrita') ||
        nameLower.contains('taila') ||
        nameLower.contains('lehya') ||
        nameLower.contains('asava') ||
        nameLower.contains('arishta') ||
        nameLower.contains('vati') ||
        nameLower.contains('rasa') ||
        nameLower.contains('yoga')) {
      return true;
    }

    return false;
  }

  /// Check if drug is a single herb
  bool _isSingleHerb(Drug drug) {
    // If it's clearly a classical drug, it's not a single herb
    if (_isClassicalDrug(drug)) {
      return false;
    }

    // Check in search keywords
    for (final keyword in drug.searchKeywords) {
      final keywordLower = keyword.toLowerCase();
      if (keywordLower.contains('single herb') ||
          keywordLower.contains('individual drug') ||
          keywordLower.contains('single drug') ||
          keywordLower.contains('herb')) {
        return true;
      }
    }

    // Check in therapeutic uses
    for (final use in drug.therapeuticUses) {
      final useLower = use.toLowerCase();
      if (useLower.contains('single herb') ||
          useLower.contains('individual') ||
          useLower.contains('raw herb')) {
        return true;
      }
    }

    // Check if formulations suggest single herb (minimal processing)
    bool hasComplexFormulation = false;
    for (final formulation in drug.formulations) {
      final formLower = formulation.toLowerCase();
      if (formLower.contains('churna') ||
          formLower.contains('kwatha') ||
          formLower.contains('compound') ||
          formLower.contains('mixed') ||
          formLower.contains('combination')) {
        hasComplexFormulation = true;
        break;
      }
    }

    // If no complex formulations and not identified as classical, likely single herb
    if (!hasComplexFormulation && drug.formulations.isNotEmpty) {
      for (final formulation in drug.formulations) {
        final formLower = formulation.toLowerCase();
        if (formLower.contains('powder') ||
            formLower.contains('dried') ||
            formLower.contains('fresh') ||
            formLower.contains('raw') ||
            formLower.contains('whole')) {
          return true;
        }
      }
    }

    // Default logic: if it has fewer formulations and constituents, it's likely a single herb
    return drug.formulations.length <= 2 && drug.constituents.length <= 5;
  }

  /// Check if drug is a Rasayana (rejuvenative) drug
  bool _isRasayanaDrug(Drug drug) {
    // Check in therapeutic uses
    for (final use in drug.therapeuticUses) {
      final useLower = use.toLowerCase();
      if (useLower.contains('rasayana') ||
          useLower.contains('rejuvenative') ||
          useLower.contains('rejuvenation') ||
          useLower.contains('anti-aging') ||
          useLower.contains('longevity') ||
          useLower.contains('immunity') ||
          useLower.contains('immunomodulator') ||
          useLower.contains('tonic') ||
          useLower.contains('vitality')) {
        return true;
      }
    }

    // Check in search keywords
    for (final keyword in drug.searchKeywords) {
      final keywordLower = keyword.toLowerCase();
      if (keywordLower.contains('rasayana') ||
          keywordLower.contains('rejuvenative') ||
          keywordLower.contains('tonic') ||
          keywordLower.contains('immunity') ||
          keywordLower.contains('anti-aging')) {
        return true;
      }
    }

    // Check in drug name
    final nameLower = drug.name.toLowerCase();
    if (nameLower.contains('rasayana') ||
        nameLower.contains('amalaki') ||
        nameLower.contains('ashwagandha') ||
        nameLower.contains('brahmi') ||
        nameLower.contains('shankhpushpi')) {
      return true;
    }

    // Check in karma (action)
    for (final karma in drug.properties.karma) {
      final karmaLower = karma.toLowerCase();
      if (karmaLower.contains('rasayana') ||
          karmaLower.contains('balya') ||
          karmaLower.contains('vajikara') ||
          karmaLower.contains('medhya')) {
        return true;
      }
    }

    return false;
  }

  /// Search drugs with enhanced performance for large datasets
  Future<List<Drug>> searchDrugs(String query) async {
    try {
      final List<Drug> allDrugs = await _getAllDrugsFromAPI();

      if (query.isEmpty) {
        return allDrugs;
      }

      final searchTerm = query.toLowerCase().trim();

      // Use more efficient filtering for large datasets
      return allDrugs.where((drug) {
        // Quick check for exact matches first (most efficient)
        if (drug.name.toLowerCase() == searchTerm) return true;
        if (drug.id.toLowerCase() == searchTerm) return true;

        // Then check contains matches
        if (drug.name.toLowerCase().contains(searchTerm)) return true;
        if (drug.description.toLowerCase().contains(searchTerm)) return true;

        // Check synonyms efficiently
        for (final synonymList in drug.synonyms.values) {
          for (final synonym in synonymList) {
            if (synonym.toLowerCase().contains(searchTerm)) return true;
          }
        }

        // Check therapeutic uses
        for (final use in drug.therapeuticUses) {
          if (use.toLowerCase().contains(searchTerm)) return true;
        }

        // Check search keywords (most relevant for search)
        for (final keyword in drug.searchKeywords) {
          if (keyword.toLowerCase().contains(searchTerm)) return true;
        }

        return false;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search drugs: $e');
    }
  }

  /// Get drug by ID with optimized lookup
  Future<Drug?> getDrugById(String id) async {
    try {
      final List<Drug> allDrugs = await _getAllDrugsFromAPI();

      // Use firstWhere with orElse for better performance
      try {
        return allDrugs.firstWhere(
          (drug) => drug.id == id,
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get drug: $e');
    }
  }

  /// Get all drugs (now uses the cached API data)
  Future<List<Drug>> getAllDrugs() async {
    try {
      return await _getAllDrugsFromAPI();
    } catch (e) {
      throw Exception('Failed to get drugs: $e');
    }
  }

  /// Clear cache manually if needed
  static void clearCache() {
    _cachedDrugs = null;
    _lastFetchTime = null;
  }

  /// Get cache status
  static Map<String, dynamic> getCacheStatus() {
    return {
      'isCached': _cachedDrugs != null,
      'drugCount': _cachedDrugs?.length ?? 0,
      'lastFetchTime': _lastFetchTime?.toIso8601String(),
      'isLoading': _isLoading,
      'cacheExpired': _lastFetchTime != null
          ? DateTime.now().difference(_lastFetchTime!) > _cacheExpiration
          : true,
    };
  }

  /// Preload data (useful for app initialization)
  static Future<void> preloadData() async {
    final repository = DrugRepository();
    await repository._getAllDrugsFromAPI();
  }
}
