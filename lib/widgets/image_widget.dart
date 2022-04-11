import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageWidget extends StatelessWidget {
  final File file;
  const ImageWidget({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius _borderRadius = BorderRadius.circular(9);
    const EdgeInsets _padding = EdgeInsets.all(8);
    return Center(
      child: Padding(
        padding: _padding,
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: Image.file(
              file,
              fit: BoxFit.contain,
            )
          ),
        ),
      )
    );
  }
}
