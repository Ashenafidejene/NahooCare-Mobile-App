import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nahoocare/core/service/local_storage_service.dart';

import '../../../accounts/presentation/pages/account_page.dart';
import '../../../firstaid/presentation/pages/first_aid_list_page.dart';
import '../../../history/presentation/pages/search_history_page.dart';
import '../../../hospitalSearch/presentation/pages/healthcare_search_page.dart';
import '../../../profile/presentation/pages/health_profile_page.dart';
import '../../../symptomSearch/presentation/pages/symptom_input_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SymptomInputPage(),
    HealthcareCentersPage(),
    FirstAidListPage(),
    HealthProfilePage(),
  ];

  final iconList = <IconData>[
    Icons.medical_services,
    Icons.local_hospital,
    Icons.healing,
    Icons.person,
  ];

  late final LocalStorageServiceImpl _localStorageService;
  bool _isInitialized = false;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    _initializeStorage();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_curve);
    _animationController.forward();
  }

  Future<void> _initializeStorage() async {
    _localStorageService = await LocalStorageServiceImpl.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<String> getGreeting() async {
    if (!_isInitialized) return 'Hello, Sir/Madam';

    final hour = DateTime.now().hour;
    final fullName = await _localStorageService.getFullName();
    final nameToUse =
        (fullName != null && fullName.trim().isNotEmpty)
            ? fullName
            : 'Sir/Madam';

    if (hour < 12) return 'Good Morning, $nameToUse';
    if (hour < 17) return 'Good Afternoon, $nameToUse';
    return 'Good Evening, $nameToUse';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _showAccountOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Header
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(
                      "assets/images/profile-placeholder.png",
                    ),
                  ),
                  title: const Text(
                    "Welcome to Nahoocare",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Manage your account settings"),
                  trailing: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.blueAccent),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AccountPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                _buildOptionTile(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchHistoryPage(),
                      ),
                    );
                  },
                ),
                _buildOptionTile(
                  icon: Icons.language,
                  label: 'Language',
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog(context);
                  },
                ),
                _buildOptionTile(
                  icon: Icons.info_outline,
                  label: 'About Us',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildOptionTile(
                  icon: Icons.feedback_outlined,
                  label: 'Give Feedback',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeedbackDialog(context);
                  },
                ),

                const Divider(),

                // Logout
                _buildOptionTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.blueAccent,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    // Handle language change
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Arabic'),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    // Handle language change
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Nahoocare'),
            content: const Text(
              'Nahoocare is a healthcare application designed to help users find medical assistance quickly and efficiently.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Give Feedback'),
            content: const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Submit feedback
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for your feedback!'),
                    ),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopGreeting(context),
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(iconList[_selectedIndex], color: Colors.white),
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onTabTap,
      ),
    );
  }

  Widget _buildTopGreeting(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getGreeting(), _localStorageService.getProfile()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        String greeting = 'Hello, Sir/Madam';
        ImageProvider imageProvider = const AssetImage(
          'assets/images/profile-placeholder.png',
        );

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final fetchedGreeting = snapshot.data![0] as String;
          final imageUrl = snapshot.data![1] as String?;

          greeting = fetchedGreeting;
          if (imageUrl != null && imageUrl.trim().isNotEmpty) {
            imageProvider = NetworkImage(imageUrl);
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, MMM d').format(DateTime.now()),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showAccountOptions(context),
                child: CircleAvatar(radius: 22, backgroundImage: imageProvider),
              ),
            ],
          ),
        );
      },
    );
  }
}
