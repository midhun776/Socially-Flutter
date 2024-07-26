import 'package:flutter/material.dart';

class ViewCommunitiesScreen extends StatefulWidget {
  const ViewCommunitiesScreen({super.key});

  @override
  State<ViewCommunitiesScreen> createState() => _ViewCommunitiesScreenState();
}

class _ViewCommunitiesScreenState extends State<ViewCommunitiesScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> cardItems = [
    {'image': 'assets/images/tCard.png','name': 'Travel', 'message': '4.3(10k+members)'},
    {'image': 'assets/images/teCard.png','name': 'Technology', 'message': '4.1(100k+members)'},
    {'image': 'assets/images/mCard.png','name': 'Music', 'message': '4.3(20k+members)'},
  ];

  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = cardItems;
    _controller.addListener(_filterItems);
  }

  @override
  void dispose() {
    _controller.removeListener(_filterItems);
    _controller.dispose();
    super.dispose();
  }

  void _filterItems() {
    String query = _controller.text.toLowerCase();
    setState(() {
      filteredItems = cardItems.where((item) {
        return item['name']!.toLowerCase().contains(query);
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child:  Text('All Communities',
              textAlign:TextAlign.start),
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
              border: Border.all(
                  color: const Color(0xFF456B1F), width: 2), // Border color
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
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(filteredItems[index]['image']!),
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
                                  filteredItems[index]['name']!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      color: Colors.white,
                                      letterSpacing: 1.8
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
                                      ' ${filteredItems[index]['message']}',
                                      style: TextStyle(
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
                              child: Text('View ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF618F00),
                                ),),
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
