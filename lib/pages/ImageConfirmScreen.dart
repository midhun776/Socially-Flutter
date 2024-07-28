import 'dart:io';
import 'package:flutter/material.dart';

class ImageConfirmScreen extends StatelessWidget {
  final String imagePath;
  final Function(bool) onConfirm;

  const ImageConfirmScreen({Key? key, required this.imagePath, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onConfirm(true);
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onConfirm(false);
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
