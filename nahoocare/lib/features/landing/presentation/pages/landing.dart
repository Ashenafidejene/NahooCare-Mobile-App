import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  late AnimationController _animationController;
  late Animation<double> _animation;
  late CurvedAnimation _curve;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
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
      child: Builder(
        builder:
            (context) => Row(
              children: [
                // Menu Icon
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    'assets/images/profile-placeholder.png',
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreeting(),
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
              ],
            ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            accountName: const Text('Nahoocare User'),
            accountEmail: const Text('user@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ), // Customize
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountPage()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchHistoryPage()),
                ),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutDialog(context),
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
}
