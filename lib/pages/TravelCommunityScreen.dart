import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

void main() {
  runApp(const TravelCommunityApp());
}

class TravelCommunityApp extends StatelessWidget {
  const TravelCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          labelColor: ColorResources.SecondaryColor,
          unselectedLabelColor: Colors.black,
          indicatorColor: ColorResources.SecondaryColor,
        ),
      ),
      home: const TravelCommunityScreen(),
    );
  }
}

class TravelCommunityScreen extends StatelessWidget {
  const TravelCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 7,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/images/travelcardimg1.jpg',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              Text(
                                '4.3 (10K+ members)',
                                style: TextStyle(
                                  fontWeight:FontWeight.bold ,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Exploring the world, one destination at a time. Join us now!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Handle join community button press
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorResources.SecondaryColor, // Set text color to green
                            ),
                            child: const Text('Join Community',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'About community'),
                      Tab(text: 'Feed'),
                    ],
                  ),
                  SizedBox(
                    height: 800, // Adjust height as needed
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome To Travel Community👋',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '"Embark on adventures, share stories, and connect with fellow explorers worldwide. '
                                      'Our travel community inspires, educates, and celebrates the beauty of global exploration. '
                                      'Join us on the journey!"',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                                  children: [
                                    Image.network('https://tse3.mm.bing.net/th?id=OIP.IrslxU2somfvoDUG1D1fggHaJ4&pid=Api&P=0&h=180'),
                                    Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRZXj9LfdS_mcK_rkF4UW78Ke1zVpI4sW5Ww&s'),
                                    Image.network('https://tse2.mm.bing.net/th?id=OIP.8GPgJIi0rgIpR2M9lqtsOQHaE7&pid=Api&P=0&h=180'), // Replace with your image URLs
                                    Image.network('https://tse2.mm.bing.net/th?id=OIP.SRLqusZ0zuen8gOPVJtVBgHaFg&pid=Api&P=0&h=180'),
                                    Image.network('https://tse2.mm.bing.net/th?id=OIP.pIpIENnZz7oiC8SK8_RQBwHaEK&pid=Api&P=0&h=180'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Center(
                          child: Text('Feed'), // Replace with your feed content
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
