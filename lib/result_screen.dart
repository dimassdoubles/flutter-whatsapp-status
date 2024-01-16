import 'dart:io';

import 'package:flutter/material.dart';


class ResultScreen extends StatelessWidget {
  final File _image;
  const ResultScreen({super.key, required File image}) : _image = image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(_image),
      ),
    );
  }
}
