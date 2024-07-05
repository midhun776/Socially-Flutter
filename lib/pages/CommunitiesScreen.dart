import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/AddCommunityScreen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  List<Map<String, String>> items = [
    {'name': 'Alan', 'image': 'assets/images/one.jpg'},
    {'name': 'Sona', 'image': 'assets/images/two.jpeg'},
    {'name': 'Nirmal', 'image': 'assets/images/three.jpeg'},
    {'name': 'Akash', 'image': 'assets/images/one.jpg'},
    {'name': 'Teena', 'image': 'assets/images/two.jpeg'},
    {'name': 'Mohan', 'image': 'assets/images/one.jpg'},
  ];

  List<Map<String, String>> cardItems = [
    {'image': 'assets/images/tCard.png','name': 'Travel', 'message': '4.3(10k+members)'},
    {'image': 'assets/images/teCard.png','name': 'Technology', 'message': '4.1(100k+members)'},
    {'image': 'assets/images/mCard.png','name': 'music', 'message': '4.3(20k+members)'},
  ];

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
                    // Add your onPressed code here!
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(items[index]['image']!),
                        ),
                        SizedBox(height: 5),
                        Text(items[index]['name']!),
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
              itemCount: cardItems.length,
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
                        image: AssetImage(cardItems[index]['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cardItems[index]['name']!,
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
                                ' ${cardItems[index]['message']}',
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
                              // Add your onPressed code here!
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
