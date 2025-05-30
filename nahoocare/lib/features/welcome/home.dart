import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 4;
              });
            },
            children: const [
              OnboardingPage(
                imagePath: 'assets/images/logo with title .png',
                title: 'Welcome to Nahoocare!',
                description: 'Your offline emergency health companion.',
              ),
              OnboardingPage(
                imagePath: 'assets/images/chat bot image.png',
                title: 'Symptom Analysis',
                description: 'Understand conditions based on symptoms.',
              ),
              OnboardingPage(
                imagePath: 'assets/images/medical-center (1).png',
                title: 'Healthcare Centers',
                description: 'Get nearby hospital recommendations.',
              ),
              OnboardingPage(
                imagePath: 'assets/images/first-aid.png',
                title: 'Offline First Aid',
                description: 'Instant help even without the internet.',
              ),
              OnboardingPage(
                imagePath: 'assets/images/Health-profile.png',
                title: 'Health - Profile',
                description: 'Store health profile  history.',
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
                  Navigator.pushNamed(context, '/login');
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
                decoration: BoxDecoration(
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
