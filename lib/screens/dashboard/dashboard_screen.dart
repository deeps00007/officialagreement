import 'package:flutter/material.dart';
import 'package:officialagreement/screens/create_agreement/create_agreement_screen.dart';
import 'package:officialagreement/screens/agreement_details/agreement_details_screen.dart';
import 'package:officialagreement/screens/settings/settings_screen.dart';
import 'package:officialagreement/widgets/banner_ad_widget.dart';
import 'package:officialagreement/services/firestore_service.dart';
import 'package:officialagreement/models/agreement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();

  String _getAppBarTitle(int index) {
    switch (index) {
      case 1:
        return 'Drive';
      case 3:
        return 'Service Requests';
      case 4:
        return 'Account & Settings';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const Color headerBlue = Color(0xFF160AE8);
    final Color surfaceColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: _currentIndex == 0 ? headerBlue : surfaceColor,
      appBar: _currentIndex == 0
          ? null
          : AppBar(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                _getAppBarTitle(_currentIndex),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateAgreementScreen()),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        selectedItemColor: headerBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Drive',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: headerBlue,
              foregroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.add, size: 22),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            label: 'S. Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Holla, ${user?.displayName?.split(' ').first ?? 'User'}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Here is an overview of your documents.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No new notifications'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onSubmitted: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Searching for "$value"...')),
                        );
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search your documents',
                        hintStyle: TextStyle(
                          color: Colors.white.withAlpha(150),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: StreamBuilder<List<AgreementModel>>(
                        stream: _firestoreService.getMyAgreements(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: headerBlue,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ',
                                style: TextStyle(color: textColor),
                              ),
                            );
                          }

                          final agreements = snapshot.data ?? [];
                          final actionNeeded = agreements
                              .where((a) => a.status != 'Signed')
                              .length;

                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(
                              top: 24,
                              left: 24,
                              right: 24,
                              bottom: 40,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      if (!isDark)
                                        BoxShadow(
                                          color: Colors.black.withAlpha(12),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ' unresolved signing',
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.green,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '+10 compared to yesterday',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                width: 45,
                                                height: 45,
                                                child: CircularProgressIndicator(
                                                  value: actionNeeded > 0
                                                      ? 0.9
                                                      : 0.0,
                                                  strokeWidth: 4,
                                                  backgroundColor: Colors.grey
                                                      .withAlpha(50),
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.green),
                                                ),
                                              ),
                                              Text(
                                                '90',
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            _buildPillBtn(
                                              'New Sign',
                                              headerBlue,
                                              Colors.white,
                                              () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const CreateAgreementScreen(),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            _buildPillBtn(
                                              'Drafts',
                                              isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade100,
                                              textColor,
                                              () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Drafts folder opening...',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            _buildPillBtn(
                                              'Bulk sign',
                                              isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade100,
                                              textColor,
                                              () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Bulk sign feature coming soon',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC107),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.auto_awesome,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'New AI Features',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Hold the screen and swipe up',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMetricCard(
                                        title: 'DOCUMENT',
                                        icon: Icons.bookmark_outline,
                                        mainValue: '',
                                        rows: [
                                          _MetricRow(label: 'Sent', value: ''),
                                          _MetricRow(
                                            label: 'Completed',
                                            value: '',
                                          ),
                                          _MetricRow(
                                            label: 'Action Needed',
                                            value: '',
                                          ),
                                        ],
                                        isDark: isDark,
                                        headerColor: headerBlue,
                                        textColor: textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildMetricCard(
                                        title: 'AVERAGE TIME',
                                        icon: Icons.hourglass_empty,
                                        mainValue: '00:12:38',
                                        mainValueSize: 18,
                                        rows: [
                                          _MetricRow(
                                            label: 'Sign alone',
                                            value: '1 min',
                                          ),
                                          _MetricRow(
                                            label: 'With Others',
                                            value: '2 hrs',
                                          ),
                                          _MetricRow(label: '', value: ''),
                                        ],
                                        isDark: isDark,
                                        headerColor: Colors.pinkAccent,
                                        textColor: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Recent Documents',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'See all documents tapped',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'See all',
                                        style: TextStyle(
                                          color: headerBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                agreements.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Text(
                                            'No documents yet. Create one above.',
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: agreements.length > 5
                                            ? 5
                                            : agreements.length,
                                        separatorBuilder: (context, index) =>
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              child: Divider(
                                                color: Colors.grey.withAlpha(
                                                  50,
                                                ),
                                              ),
                                            ),
                                        itemBuilder: (context, index) {
                                          final agreement = agreements[index];
                                          final isSigned =
                                              agreement.status == 'Signed';
                                          return ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      AgreementDetailsScreen(
                                                        agreement: agreement,
                                                      ),
                                                ),
                                              );
                                            },
                                            contentPadding: EdgeInsets.zero,
                                            leading: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.grey.shade800
                                                    : Colors.grey.shade100,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.description_outlined,
                                                color: textColor,
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(
                                              agreement.projectTitle.isNotEmpty
                                                  ? agreement.projectTitle
                                                  : 'NDA Document',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            subtitle: Text(
                                              isSigned
                                                  ? 'Completed'
                                                  : 'Action Required',
                                              style: TextStyle(
                                                color: isSigned
                                                    ? Colors.green
                                                    : headerBlue,
                                                fontSize: 13,
                                              ),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  isSigned ? 'View' : 'Sign',
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.grey.shade500,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                const SizedBox(height: 32),
                                const Center(child: BannerAdWidget()),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              'Drive Placeholder',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Center(
            child: Text(
              'Add Placeholder',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Center(
            child: Text(
              'Service Request Placeholder',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SettingsScreen(onBack: () => setState(() => _currentIndex = 0)),
        ],
      ),
    );
  }

  Widget _buildPillBtn(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required String mainValue,
    required List<_MetricRow> rows,
    required bool isDark,
    required Color headerColor,
    required Color textColor,
    double mainValueSize = 28,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.transparent : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: headerColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: headerColor, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mainValue,
            style: TextStyle(
              color: textColor,
              fontSize: mainValueSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r.label,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  Text(
                    r.value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow {
  final String label;
  final String value;
  _MetricRow({required this.label, required this.value});
}
