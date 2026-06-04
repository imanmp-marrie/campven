import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  bool _darkMode = false;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await _authService.getUserEmail();
    setState(() => _userEmail = email);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout,
                  color: Colors.grey, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Konfirmasi Logout',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Yakin ingin keluar dari akun Anda?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Logout',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1A6BFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Campven',
          style: TextStyle(
              color: Color(0xFF1A6BFF), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1A6BFF)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your account and app preferences',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            // Account section
            _buildSectionTitle('Account'),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.person_outline,
                label: 'Account Settings',
                subtitle: 'Email, password, and security',
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                subtitle: 'Manage push and email alerts',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 20),
            // Preferences section
            _buildSectionTitle('Preferences'),
            _buildSettingsCard([
              _buildToggleItem(
                icon: Icons.palette_outlined,
                label: 'App Theme',
                subtitle: _darkMode ? 'Dark Mode' : 'Light Mode',
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
              ),
            ]),
            const SizedBox(height: 20),
            // About section
            _buildSectionTitle('About Campven'),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A6BFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.school,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Campven',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Text(
                    'Version 2.4.0 (Academic Build)',
                    style:
                        TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Campven is the premier academic lifecycle management tool, designed to streamline campus events, workshops, and social engagements for the modern student.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF3FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.email_outlined,
                              color: Color(0xFF1A6BFF), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Support & Contact',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ),
                        const Icon(Icons.open_in_new,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Logged in as $_userEmail',
                style:
                    const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            color: Color(0xFF1A6BFF),
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF3FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: const Color(0xFF1A6BFF), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                color: const Color(0xFF1A6BFF), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A6BFF),
          ),
        ],
      ),
    );
  }
}