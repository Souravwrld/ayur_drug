import 'package:ayur_drug/features/home/navigation_bloc/navigation_bloc.dart';
import 'package:ayur_drug/features/home/screens/home_screen.dart';
import 'package:ayur_drug/features/saved/screens/save.dart';
import 'package:ayur_drug/features/search/screens/search.dart';
import 'package:ayur_drug/features/settings/screens/settings.dart';
import 'package:ayur_drug/features/tools/screens/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWrapper extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    SavedScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is NavigationChanged) {
          currentIndex = state.currentIndex;
        }

        return Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    _buildNavItem(context, 0, '🏠', 'Home', currentIndex),
                    _buildNavItem(context, 1, '🔍', 'Search', currentIndex),
                    _buildNavItem(context, 2, '⭐', 'Saved', currentIndex),
                    _buildNavItem(context, 3, '⚙️', 'More', currentIndex),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String icon,
      String label, int currentIndex) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<NavigationBloc>().add(NavigateToTab(index));
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                icon,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isActive ? const Color(0xFFFF6B35) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
