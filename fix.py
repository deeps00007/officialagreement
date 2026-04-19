import os

with open('lib/screens/dashboard/dashboard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Restore imports
text = text.replace(
    \"import 'package:officialagreement/screens/create_agreement/create_agreement_screen.dart';\",
    \"import 'package:officialagreement/screens/create_agreement/create_agreement_screen.dart';\nimport 'package:officialagreement/screens/auth/login_screen.dart';\"
)

# Fix the welcome message
text = text.replace(
    \"'Holla, !',\",
    \"'Holla, \!',\"
)

# Add logout
notif = '''                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),'''
                  
logout = '''                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),'''
text = text.replace(notif, logout)

# Fix bottom nav
nav_on_tap = '''        onTap: (index) => setState(() => _currentIndex = index),'''
new_nav_on_tap = '''        onTap: (index) {
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAgreementScreen()));
          } else {
            setState(() => _currentIndex = index);
          }
        },'''
text = text.replace(nav_on_tap, new_nav_on_tap)

with open('lib/screens/dashboard/dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)
