import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageSearcher(),
    );
  }
}

class ImageSearcher extends StatefulWidget {
  const ImageSearcher({Key? key}) : super(key: key);

  @override
  State<ImageSearcher> createState() => _ImageSearcherState();
}

class _ImageSearcherState extends State<ImageSearcher> {


  Future<void> fetchImages() async {
    Response response = await Dio().get(
      'https://pixabay.com/api/?key=31191150-fa99e18e1c4e6f5ca749a2e6a&q=yellow+flowers&image_type=photo&pretty=true',
    );
    print(response.data);
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
