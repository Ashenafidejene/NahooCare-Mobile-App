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
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 3;
              });
            },
            children: const [
              OnboardingPage(
                title: 'Welcome to Nahoocare',
                description: 'Your offline emergency health companion.',
                icon: Icons.health_and_safety,
              ),
              OnboardingPage(
                title: 'Symptom-based Recommendation',
                description:
                    'Get personalized healthcare guidance based on your symptoms.',
                icon: Icons.medical_services,
              ),
              OnboardingPage(
                title: 'Nearby Hospitals & First Aid',
                description:
                    'Find hospitals by location and access life-saving first aid tips.',
                icon: Icons.local_hospital,
              ),
              OnboardingPage(
                title: 'Health Profile Storage',
                description:
                    'Securely store your health records and emergency info.',
                icon: Icons.folder_shared,
              ),
            ],
          ),

          // Dot indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(dotHeight: 10, dotWidth: 10),
              ),
            ),
          ),

          // Skip or Start button
          Positioned(
            bottom: 40,
            right: 20,
            child:
                onLastPage
                    ? ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Start'),
                    )
                    : TextButton(
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Next'),
                    ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.teal),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
