import 'dart:async';

import 'package:ayur_drug/features/search/domain/models/drug_model.dart';
import 'package:ayur_drug/features/search/presentation/bloc/search_bloc.dart';
import 'package:ayur_drug/features/search/presentation/screens/drug_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDrugListScreen extends StatefulWidget {
  final String category;
  final String categoryTitle;

  const CategoryDrugListScreen({
    Key? key,
    required this.category,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  _CategoryDrugListScreenState createState() => _CategoryDrugListScreenState();
}

class _CategoryDrugListScreenState extends State<CategoryDrugListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  List<Drug> _filteredDrugs = [];
  List<Drug> _allCategoryDrugs = [];

  @override
  void initState() {
    super.initState();
    // Load category drugs when screen initializes
    _loadCategoryDrugs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _loadCategoryDrugs() {
    // Trigger search with category filter
    context.read<SearchBloc>().add(CategoryDrugsRequested(widget.category));
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        // Show all category drugs when search is empty
        setState(() {
          _filteredDrugs = _allCategoryDrugs;
        });
      } else {
        // Filter category drugs based on search query
        _filterCategoryDrugs(query);
      }
    });
  }

  void _filterCategoryDrugs(String query) {
    final searchTerm = query.toLowerCase().trim();
    setState(() {
      _filteredDrugs = _allCategoryDrugs.where((drug) {
        // Search within the category drugs
        if (drug.name.toLowerCase().contains(searchTerm)) return true;
        if (drug.description.toLowerCase().contains(searchTerm)) return true;

        // Check synonyms
        for (final synonymList in drug.synonyms.values) {
          for (final synonym in synonymList) {
            if (synonym.toLowerCase().contains(searchTerm)) return true;
          }
        }

        // Check therapeutic uses
        for (final use in drug.therapeuticUses) {
          if (use.toLowerCase().contains(searchTerm)) return true;
        }

        // Check search keywords
        for (final keyword in drug.searchKeywords) {
          if (keyword.toLowerCase().contains(searchTerm)) return true;
        }

        return false;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredDrugs = _allCategoryDrugs;
    });
  }

  String _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'classical':
        return '📜';
      case 'single herbs':
        return '🌿';
      case 'rasayana':
        return '✨';
      default:
        return '💊';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8F65)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40FF6B35),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Text(
                          _getCategoryIcon(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.categoryTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.filter_list, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText:
                              'Search within ${widget.categoryTitle.toLowerCase()}...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFFF6B35),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Drug List
            Expanded(
              child: BlocListener<SearchBloc, SearchState>(
                listener: (context, state) {
                  if (state is CategoryDrugsSuccess) {
                    setState(() {
                      _allCategoryDrugs = state.drugs;
                      _filteredDrugs = state.drugs;
                    });
                  }
                },
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading ||
                        state is CategoryDrugsLoading) {
                      return _buildLoadingState();
                    } else if (state is CategoryDrugsSuccess ||
                        _filteredDrugs.isNotEmpty) {
                      return _buildDrugsList();
                    } else if (state is SearchError ||
                        state is CategoryDrugsError) {
                      final errorMessage = state is SearchError
                          ? state.message
                          : (state as CategoryDrugsError).message;
                      return _buildErrorState(errorMessage);
                    }
                    return _buildLoadingState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading drugs...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Drugs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCategoryDrugs,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugsList() {
    if (_filteredDrugs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No results found'
                  : 'No drugs found in this category',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try different keywords'
                  : 'This category appears to be empty',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${_filteredDrugs.length} drug${_filteredDrugs.length != 1 ? 's' : ''} found',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_searchController.text.isNotEmpty) ...[
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Text(
                  'Filtered from ${_allCategoryDrugs.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Drug list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredDrugs.length,
            itemBuilder: (context, index) {
              final drug = _filteredDrugs[index];
              return _buildDrugCard(drug);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrugCard(Drug drug) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrugDetailScreen(drug: drug),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      drug.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                  if (drug.properties.virya.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        drug.properties.virya,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                drug.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              if (drug.synonyms.isNotEmpty) ...[
                const Text(
                  'Also known as:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: drug.synonyms.values
                      .expand((list) => list)
                      .take(3)
                      .map((synonym) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              synonym,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              if (drug.therapeuticUses.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        drug.therapeuticUses.take(3).join(', '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
