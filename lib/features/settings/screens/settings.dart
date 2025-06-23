import 'package:ayur_drug/features/settings/widgets/section_header.dart';
import 'package:ayur_drug/features/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
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
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'More Options',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  const SectionHeader(title: 'APP SETTINGS'),
                  SettingsItem(
                    icon: '👤',
                    title: 'Profile',
                    subtitle: 'Manage your account',
                    backgroundColor: const Color(0xFFE3F2FD),
                    onTap: () {
                      // Add navigation logic here
                      print('Profile tapped');
                    },
                  ),
                  SettingsItem(
                    icon: '🔔',
                    title: 'Notifications',
                    subtitle: 'Update alerts & reminders',
                    backgroundColor: const Color(0xFFFFF3E0),
                    onTap: () {
                      // Add navigation logic here
                      print('Notifications tapped');
                    },
                  ),
                  SettingsItem(
                    icon: '📱',
                    title: 'Offline Mode',
                    subtitle: 'Download for offline use',
                    backgroundColor: const Color(0xFFF3E5F5),
                    onTap: () {
                      // Add navigation logic here
                      print('Offline Mode tapped');
                    },
                  ),

                  const SectionHeader(title: 'ABOUT'),
                  SettingsItem(
                    icon: '📖',
                    title: 'About This App',
                    subtitle: 'Version 1.0',
                    backgroundColor: const Color(0xFFE8F5E9),
                    onTap: () {
                      // Add navigation logic here
                      print('About This App tapped');
                    },
                  ),
                  SettingsItem(
                    icon: '⭐',
                    title: 'Rate App',
                    subtitle: 'Help us improve',
                    backgroundColor: const Color(0xFFFCE4EC),
                    onTap: () {
                      // Add navigation logic here
                      print('Rate App tapped');
                    },
                  ),

                  const SizedBox(height: 40),

                  // Database Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Text(
                          'Database Last Updated',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'January 2025',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Total Drugs: 1,256',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
