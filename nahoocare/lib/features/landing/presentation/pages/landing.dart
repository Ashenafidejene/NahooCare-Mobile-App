import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nahoocare/core/service/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
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
    if (!_isInitialized) return tr('helloSirMadam');

    final hour = DateTime.now().hour;
    final fullName = await _localStorageService.getFullName();
    final nameToUse =
        (fullName != null && fullName.trim().isNotEmpty)
            ? fullName
            : tr('sirMadam');

    if (hour < 12) return tr('goodMorning', args: [nameToUse]);
    if (hour < 17) return tr('goodAfternoon', args: [nameToUse]);
    return tr('goodEvening', args: [nameToUse]);
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
                  title: Text(
                    "Welcome to Nahoocare".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Manage your account settings".tr()),
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
                  label: 'History'.tr(),
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
                  label: 'Language'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog(context);
                  },
                ),
                _buildOptionTile(
                  icon: Icons.info_outline,
                  label: 'About Us'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildOptionTile(
                  icon: Icons.feedback_outlined,
                  label: 'Give Feedback'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _showFeedbackDialog(context);
                  },
                ),

                const Divider(),

                // Logout
                _buildOptionTile(
                  icon: Icons.logout,
                  label: 'Logout'.tr(),
                  onTap: () {
                    // Navigator.pop(context);
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
            title: Text('Select Language'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('አማርኛ'),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    context.setLocale(const Locale('am'));
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
            title: Text('About Nahoocare'.tr()),
            content: Text(
              'Nahoocare is a healthcare application designed to help users find medical assistance quickly and efficiently.'
                  .tr(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'.tr()),
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
            title: Text('Give Feedback'.tr()),
            content: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  // Submit feedback
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for your feedback!'.tr()),
                    ),
                  );
                },
                child: Text('Submit'.tr()),
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
            title: Text('Confirm Logout'.tr()),
            content: Text('Are you sure you want to logout?'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _localStorageService.clearValue('auth_token');
                  _localStorageService.clearValue('photoUrl');
                  _localStorageService.clearValue('full_name');
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                child: Text('Logout'.tr()),
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
          elevation: 8,
          backgroundColor: Colors.blueAccent,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              iconList[_selectedIndex],
              color: Colors.white,
              size: 26,
            ),
          ),
          onPressed: () {
            // You can add specific FAB action if needed
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey[600],
        backgroundColor: Colors.white,
        splashColor: Colors.blue[100],
        splashSpeedInMilliseconds: 300,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _animationController.reset();
            _animationController.forward();
          });
        },
        // Optional: Add labels
        iconSize: 26,
        // borderWidth: 1,
        // borderColor: Colors.grey[200],
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
