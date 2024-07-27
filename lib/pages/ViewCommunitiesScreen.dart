import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class ViewCommunitiesScreen extends StatefulWidget {
  const ViewCommunitiesScreen({super.key});

  @override
  State<ViewCommunitiesScreen> createState() => _ViewCommunitiesScreenState();
}

class _ViewCommunitiesScreenState extends State<ViewCommunitiesScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> cardItems = [];
  List<dynamic> filteredItems = [];

  void getCommunityDetails() async {
    var response = await http.get(Uri.parse(communityGetApi),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      cardItems = jsonResponse["data"];
      filteredItems = cardItems; // Initialize filteredItems
    });
  }

  String findOverallRating(List<dynamic> ratingList) {
    num ratingSum = 0;
    print(ratingList);
    for(var i=0; i < ratingList.length; i++) {
      ratingSum = ratingSum + double.parse(ratingList[i]);
    }
    print(ratingSum);
    double overallRating = ratingSum/ratingList.length;
    return "${overallRating.toStringAsFixed(1)}";
  }

  @override
  void initState() {
    super.initState();
    getCommunityDetails();
    _controller.addListener(_filterItems); // Add listener for search
  }

  @override
  void dispose() {
    _controller.removeListener(_filterItems); // Remove listener
    _controller.dispose();
    super.dispose();
  }

  void _filterItems() {
    String query = _controller.text.toLowerCase();
    setState(() {
      filteredItems = cardItems.where((item) {
        return item['communityName']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: const Text('All Communities', textAlign: TextAlign.start),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFF),
              border: Border.all(color: const Color(0xFF456B1F), width: 2), // Border color
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search Communities Here ',
                hintStyle: TextStyle(color: Color(0xFF456B1F)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF456B1F)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: filteredItems[index]['communityImage'] != null
                              ? NetworkImage(filteredItems[index]['communityImage'])
                              : AssetImage('assets/images/communityPic.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredItems[index]['communityName']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    color: Colors.white,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      findOverallRating(cardItems[index]['rating']),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Add your onPressed code here!
                              },
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF618F00),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
