import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageDisplayScreen extends StatefulWidget {
  final List<String> imageUrls;

  ImageDisplayScreen({required this.imageUrls});

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Images'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (index) => buildDot(index),
            ),
          ),
          SizedBox(height: 80.0),
        ],
      ),
    );
  }
  Widget buildDot(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class ImageDownloadScreen extends StatefulWidget {
  @override
  _ImageDownloadScreenState createState() => _ImageDownloadScreenState();
}

class _ImageDownloadScreenState extends State<ImageDownloadScreen> {
  List<String> imageUrls = [];

  Future<void> downloadImages() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/generate-image'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> output = jsonResponse['output'];
      final List<String> urls = output.map((url) => url as String).toList();
      setState(() {
        imageUrls = urls;
      });
    } else {
      print('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Images'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await downloadImages();
            if (imageUrls.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDisplayScreen(imageUrls: imageUrls),
                ),
              );
            }
          },
          child: Text('Download and View Images'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageDownloadScreen(),
  ));
}
