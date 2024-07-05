import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class ProfileStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 5.0),
      child: Card(
        color:ColorResources.PrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),

        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('6', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Posts'),
                ],
              ),

              Divider(
              ),


              Column(
                children: [
                  Text('528', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Following'),
                ],
              ),
              Divider(

              ),

              Column(
                children: [
                  Text('1.2K', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Followers'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
