import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(4), // Space between image and white background
          decoration: BoxDecoration(
            color: ColorResources.UnselectedIconColor, // Background color
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with the actual image URL
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Merin Mathew',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_pin, color: ColorResources.UnselectedIconColor),
            SizedBox(width: 5),
            Text(
              'Mulanthuruthy, Ernakulam',
              style: TextStyle(color: ColorResources.UnselectedIconColor, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '“Dreamer . Thinker . Traveller”',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.person, color: ColorResources.PrimaryColor),
              label: Text(
                'Connect',
                style: TextStyle(color: ColorResources.PrimaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.SelectedIconColor,
                minimumSize: Size(150, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.message_outlined, color: ColorResources.SelectedIconColor),
              label: Text(
                'Message',
                style: TextStyle(color: ColorResources.SelectedIconColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                minimumSize: Size(150, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
