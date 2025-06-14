import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<Locale>(
            onSelected: (locale) {
              context.setLocale(locale);
            },
            icon: const Icon(Icons.language, color: Colors.black),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: Locale('en'.tr()),
                    child: Text('English'.tr()),
                  ),
                  PopupMenuItem(
                    value: Locale('am'.tr()),
                    child: Text('አማርኛ'.tr()),
                  ),
                ],
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 4;
              });
            },
            children: [
              OnboardingPage(
                imagePath: 'assets/images/logo with title .png',
                title: tr('welcome_title'),
                description: tr('welcome_description'),
              ),
              OnboardingPage(
                imagePath: 'assets/images/chat bot image.png',
                title: tr('symptom_title'),
                description: tr('symptom_description'),
              ),
              OnboardingPage(
                imagePath: 'assets/images/medical-center (1).png',
                title: tr('healthcare_title'),
                description: tr('healthcare_description'),
              ),
              OnboardingPage(
                imagePath: 'assets/images/first-aid.png',
                title: tr('firstaid_title'),
                description: tr('firstaid_description'),
              ),
              OnboardingPage(
                imagePath: 'assets/images/health-profile.png',
                title: tr('profile_title'),
                description: tr('profile_description'),
              ),
            ],
          ),

          // Dot Indicator
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: const WormEffect(dotHeight: 10, dotWidth: 10),
              ),
            ),
          ),

          // Circular Floating Next/Start Button
          Positioned(
            bottom: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (onLastPage) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
