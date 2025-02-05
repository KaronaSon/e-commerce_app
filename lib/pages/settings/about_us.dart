import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'About Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
            'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}