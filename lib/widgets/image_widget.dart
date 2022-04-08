import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageWidget extends StatelessWidget {
  final File file;
  const ImageWidget({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(file);
  }
}
