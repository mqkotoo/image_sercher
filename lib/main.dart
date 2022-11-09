import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  List imageList = [];

  Future<void> fetchImages(String inputText) async {
    final Response response = await Dio().get(
      'https://pixabay.com/api/?key=31191150-fa99e18e1c4e6f5ca749a2e6a&per_page=100&q=$inputText&image_type=photo&pretty=true',
    );
    imageList = response.data['hits'];
    setState(() {});
  }

  Future<void> shareImage(url) async {
    final Directory directory = await getTemporaryDirectory();
                final Response response = await Dio().get(url,
                  options: Options(
                    responseType: ResponseType.bytes,
                  )
                );
                final File file = File('${directory.path}/image.png');
                await file.writeAsBytes(response.data);

                await Share.shareFiles([file.path]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> image = imageList[index];
            return InkWell(
              onTap: () {
                shareImage(image['webformatURL']);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(image['previewURL'],fit: BoxFit.cover),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite,color: Colors.pink),
                          Text(image['likes'].toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class PixabayImage {
  final String previewURL;
  final int likes;
  final String webformatURL;

  PixabayImage({
    required this.previewURL, 
    required this.likes, 
    required this.webformatURL,
    });

}
