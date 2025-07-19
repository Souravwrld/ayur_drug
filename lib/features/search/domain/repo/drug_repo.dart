import 'dart:convert';

import 'package:ayur_drug/drug_data/drug_data.dart';
import 'package:ayur_drug/features/search/domain/models/drug_model.dart';

class DrugRepository {
  // TODO: Replace with actual API endpoint when ready
  // static const String baseUrl = 'https://api.mediayush.com/v1';

  Future<List<Drug>> searchDrugs(String query) async {
    try {
      // TODO: Uncomment when API is ready
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/drugs/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_TOKEN',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Drug.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search drugs: ${response.statusCode}');
      }
      */

      // Dummy implementation
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay

      final List<dynamic> data = json.decode(dummyData);
      final List<Drug> allDrugs =
          data.map((json) => Drug.fromJson(json)).toList();

      if (query.isEmpty) {
        return allDrugs;
      }

      // Filter drugs based on search query
      return allDrugs.where((drug) {
        final searchTerm = query.toLowerCase();

        // Search in name
        if (drug.name.toLowerCase().contains(searchTerm)) {
          return true;
        }

        // Search in description
        if (drug.description.toLowerCase().contains(searchTerm)) {
          return true;
        }

        // Search in synonyms
        for (final synonymList in drug.synonyms.values) {
          for (final synonym in synonymList) {
            if (synonym.toLowerCase().contains(searchTerm)) {
              return true;
            }
          }
        }

        // Search in therapeutic uses
        for (final use in drug.therapeuticUses) {
          if (use.toLowerCase().contains(searchTerm)) {
            return true;
          }
        }

        // Search in search keywords
        for (final keyword in drug.searchKeywords) {
          if (keyword.toLowerCase().contains(searchTerm)) {
            return true;
          }
        }

        return false;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search drugs: $e');
    }
  }

  Future<Drug?> getDrugById(String id) async {
    try {
      // TODO: Uncomment when API is ready
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/drugs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_TOKEN',
        },
      );
      
      if (response.statusCode == 200) {
        return Drug.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get drug: ${response.statusCode}');
      }
      */

      // Dummy implementation
      await Future.delayed(const Duration(milliseconds: 300));

      final List<dynamic> data = json.decode(dummyData);
      final List<Drug> allDrugs =
          data.map((json) => Drug.fromJson(json)).toList();

      try {
        return allDrugs.firstWhere((drug) => drug.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get drug: $e');
    }
  }

  Future<List<Drug>> getAllDrugs() async {
    try {
      // TODO: Uncomment when API is ready
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/drugs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_TOKEN',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Drug.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get drugs: ${response.statusCode}');
      }
      */

      // Dummy implementation
      await Future.delayed(const Duration(milliseconds: 800));

      final List<dynamic> data = json.decode(dummyData);
      return data.map((json) => Drug.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get drugs: $e');
    }
  }
}
