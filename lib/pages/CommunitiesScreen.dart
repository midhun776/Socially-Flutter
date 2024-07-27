import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/config.dart';
import 'package:socially/pages/AddCommunityScreen.dart';
import 'package:http/http.dart' as http;
import 'package:socially/pages/TravelCommunityScreen.dart';
import 'package:socially/pages/ViewCommunitiesScreen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}


class _CommunitiesScreenState extends State<CommunitiesScreen> {
  List<dynamic> allItems = [];
  List<dynamic> cardItems = [];

  void getCommunityDetails() async {
    var response = await http.get(Uri.parse(communityGetApi),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse["data"]);
    setState(() {
      allItems = jsonResponse["data"];
    });
    print(allItems);
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

  Future<void> getTopCommunityDetails() async {
    var response = await http.get(
      Uri.parse(communityGetApi), // Replace with your API URL
      headers: {"Content-Type": "application/json"},
    );

    var jsonResponse = jsonDecode(response.body);
    List<Map<String, dynamic>> communities = List<Map<String, dynamic>>.from(jsonResponse["data"]);

    // Calculate average ratings
    for (var community in communities) {
      List<dynamic> ratings = community['rating'] ?? [];
      double averageRating = double.parse(findOverallRating(ratings));
      community['averageRating'] = averageRating.toString(); // Store as String
    }

    // Sort based on the double value of the string
    communities.sort((a, b) {
      double ratingA = double.parse(a['averageRating']);
      double ratingB = double.parse(b['averageRating']);
      return ratingB.compareTo(ratingA); // Sort in descending order
    });
    print("DATAS"+communities.toString());

    setState(() {
      cardItems = communities;
    });
  }


  @override
  void initState() {
    super.initState();
    getCommunityDetails();
    getTopCommunityDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
             child:  Text('Communities',
             textAlign:TextAlign.start),
          ),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddCommunityScreen()));
            getCommunityDetails();
          }, icon: Icon(Icons.group_add)),
          SizedBox(width: 10)
        ],
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      'All Communities',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCommunitiesScreen()));
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allItems.length < 10  ? allItems.length : 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TravelCommunityScreen()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: allItems[index]['communityImage'] != null
                                ? NetworkImage(allItems[index]['communityImage'])
                                : AssetImage('assets/images/allCommunityOrange.png') as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          allItems[index]['communityName']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          ),
          const SizedBox(height: 4),
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Trending Communities ',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cardItems.length < 3  ? cardItems.length : 3,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: cardItems[index]['communityImage'] != null
                            ? NetworkImage(cardItems[index]['communityImage'])
                            : AssetImage('assets/images/communityPic.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cardItems[index]['communityName']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(
                                findOverallRating(cardItems[index]['rating']),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TravelCommunityScreen()),
                              );
                            },
                            child: Text('View Community',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF618F00),
                              ),),
                          ),
                        ],
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
