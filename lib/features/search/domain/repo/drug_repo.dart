import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ayur_drug/drug_data/drug_data.dart';
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
  static const Duration _cacheExpiration = Duration(hours: 24); // Cache for 24 hours

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
      // Wait for ongoing request to complete
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
          ).timeout(const Duration(seconds: 30)), // 30-second timeout per request
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
            } else if (responseData is Map && responseData.containsKey('data')) {
              volumeData = responseData['data'];
            } else if (responseData is Map && responseData.containsKey('products')) {
              volumeData = responseData['products'];
            } else if (responseData is Map && responseData.containsKey('items')) {
              volumeData = responseData['items'];
            } else {
              print('Unexpected response structure from volume ${i + 1}: ${responseData.runtimeType}');
              continue;
            }

            final List<Drug> volumeDrugs = [];
            
            for (var drugData in volumeData) {
              try {
                final drug = Drug.fromJson(drugData);
                volumeDrugs.add(drug);
              } catch (parseError) {
                print('Error parsing individual drug in volume ${i + 1}: $parseError');
                print('Problematic data: ${drugData.toString().substring(0, 200)}...');
                // Continue with other drugs even if one fails
              }
            }
            
            allDrugs.addAll(volumeDrugs);
            print('Successfully loaded ${volumeDrugs.length} drugs from volume ${i + 1}');
          } catch (e) {
            print('Error parsing data from volume ${i + 1}: $e');
            // Continue with other volumes even if one fails
          }
        } else {
          print('Failed to load volume ${i + 1}: HTTP ${response.statusCode}');
          // Continue with other volumes even if one fails
        }
      }

      // Cache the results
      _cachedDrugs = allDrugs;
      _lastFetchTime = DateTime.now();
      
      print('Total drugs loaded: ${allDrugs.length}');
      return allDrugs;

    } catch (e) {
      print('Error fetching drugs from API: $e');
      
      // Fallback to dummy data if API fails completely
      if (_cachedDrugs == null) {
        return _getFallbackDrugs();
      }
      
      return _cachedDrugs!;
    } finally {
      _isLoading = false;
    }
  }

  /// Fallback method that returns dummy data when API is unavailable
  List<Drug> _getFallbackDrugs() {
    try {
      final List<dynamic> data = json.decode(dummyData);
      return data.map((json) => Drug.fromJson(json)).toList();
    } catch (e) {
      print('Error loading fallback data: $e');
      return [];
    }
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