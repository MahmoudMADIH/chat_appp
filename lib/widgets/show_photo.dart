import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowPhoto extends StatelessWidget {
  static String id = 'ShowPhoto';
  const ShowPhoto({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url.toString()),
      ),
    );
  }
}
