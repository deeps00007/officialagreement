import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:officialagreement/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color sheetColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF2F4F7);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color textSecondary = isDark ? Colors.white54 : Colors.black54;
    final Color headerBgColor = isDark
        ? const Color(0xFF111111)
        : const Color(0xFF160AE8);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: headerBgColor,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                            user?.displayName?.isNotEmpty == true
                                ? user!.displayName![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: headerBgColor, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: titleColor,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? 'User Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'email@example.com',
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: sheetColor),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  _buildGroup(
                    cardColor: cardColor,
                    children: [
                      _buildItem(
                        context,
                        Icons.account_balance_wallet_outlined,
                        'Wallet',
                        titleColor,
                        textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildGroup(
                    cardColor: cardColor,
                    children: [
                      _buildItem(
                        context,
                        Icons.edit_outlined,
                        'Edit Profile',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.person_off_outlined,
                        'View Blocked Users',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.assignment_outlined,
                        'Task Center',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.history_toggle_off_outlined,
                        'Activities',
                        titleColor,
                        textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildGroup(
                    cardColor: cardColor,
                    children: [
                      _buildItem(
                        context,
                        Icons.settings_outlined,
                        'Settings',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.workspace_premium_outlined,
                        'Level',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.favorite_border_outlined,
                        'Favorites',
                        titleColor,
                        textSecondary,
                      ),
                      _buildDivider(),
                      _buildItem(
                        context,
                        Icons.file_download_outlined,
                        'Downloads',
                        titleColor,
                        textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildGroup(
                    cardColor: cardColor,
                    children: [
                      InkWell(
                        onTap: () async {
                          try {
                            await GoogleSignIn().disconnect();
                          } catch (_) {
                            // Ignore if not logged in with Google
                          }
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Colors.redAccent.shade200,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent.shade200,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.redAccent.withAlpha(80),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroup({
    required Color cardColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    Color titleColor,
    Color arrowColor,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigating to $title')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: arrowColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 56, right: 16),
      height: 1,
      color: Colors.grey.withAlpha(30),
    );
  }
}
