import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nahoocare/features/history/presentation/pages/history.dart';

import '../../../firstAid/presentation/pages/firstaid.dart';
import '../../../hospitalSearch/presentation/pages/healthcare_search_page.dart';
import '../../../hospitalSearch/presentation/pages/search_pages.dart';
import '../../../profile/presentation/pages/health_profile_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../symptomSearch/presentation/pages/symptomSearch_page.dart';
import '../../../symptomSearch/presentation/pages/symptom_input_page.dart';

class LandingPage extends StatefulWidget {
  // final VoidCallback toggleTheme;
  //final bool isDarkMode;

  const LandingPage({
    super.key,
    // required this.toggleTheme,
    // required this.isDarkMode,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SymptomInputPage(),
    HealthcareSearchPage(),
    Firstaid(),
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
      appBar: AppBar(title: const Text('NhooCare'), actions: [
      
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
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
}
