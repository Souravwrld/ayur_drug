import 'package:ayur_drug/features/home/app_data_bloc/app_data_bloc.dart';
import 'package:ayur_drug/features/home/navigation_bloc/navigation_bloc.dart';
import 'package:ayur_drug/features/home/widgets/home_category_card.dart';
import 'package:ayur_drug/features/home/widgets/stat.dart';
import 'package:ayur_drug/features/search/presentation/screens/drug_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
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
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Mediayush Directory',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          context.read<NavigationBloc>().add(NavigateToTab(1));
                        },
                        child: const Icon(Icons.search, color: Colors.white)),
                    const SizedBox(width: 16),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    GestureDetector(
                      onTap: () {
                        context.read<NavigationBloc>().add(NavigateToTab(1));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf5f6f7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Quick search for drugs...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const Icon(Icons.mic, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    // Quick Stats
                    BlocBuilder<AppDataBloc, AppDataState>(
                      builder: (context, state) {
                        if (state is AppDataLoaded) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                StatCard(
                                  value: '${state.totalDrugs}',
                                  label: 'Total Drugs',
                                ),
                                const SizedBox(width: 12),
                                StatCard(
                                  value: '${state.classicalDrugs}',
                                  label: 'Classical',
                                ),
                                const SizedBox(width: 12),
                                StatCard(
                                  value: '${state.singleHerbs}',
                                  label: 'Single Herbs',
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),

                    const SizedBox(height: 20),

                    // Browse Categories Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Browse Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Categories Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          CategoryCard(
                            icon: '📜',
                            title: 'Classical',
                            subtitle: 'Traditional formulations',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDrugListScreen(
                                    category: 'classical',
                                    categoryTitle: 'Classical Drugs',
                                  ),
                                ),
                              );
                            },
                          ),
                          CategoryCard(
                            icon: '🌿',
                            title: 'Single Herbs',
                            subtitle: 'Raw medicinal herbs',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDrugListScreen(
                                    category: 'single_herbs',
                                    categoryTitle: 'Single Herbs',
                                  ),
                                ),
                              );
                            },
                          ),
                          CategoryCard(
                            icon: '🏥',
                            title: 'By Disease',
                            subtitle: 'Indication-wise search',
                            onTap: () {
                              // Add navigation logic here
                              print('By Disease category tapped');
                            },
                          ),
                          CategoryCard(
                            icon: '✨',
                            title: 'Rasayana',
                            subtitle: 'Rejuvenation drugs',
                            onTap: () {
                              // Add navigation logic here
                              print('Rasayana category tapped');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Tip
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          left: BorderSide(
                            color: Color(0xFFFF6B35),
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💡 Quick Tip',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Long press any drug card to see quick actions like bookmark, share, or calculate dose.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
