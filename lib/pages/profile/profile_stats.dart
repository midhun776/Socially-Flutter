import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class ProfileStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 5.0),
      child: Card(
        color: ColorResources.PrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('6', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Posts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                height: 60, // Adjust the height according to your design
                child: VerticalDivider(
                  color: Colors.grey, // Adjust the color to fit your design
                  thickness: 1, // Adjust the thickness to fit your design
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('528', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Connections', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
