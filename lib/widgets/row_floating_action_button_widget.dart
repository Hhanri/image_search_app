import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class RowActonButtonWidget extends StatelessWidget {
  const RowActonButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SearchFloatingActionButton(),
        AddFloatingActionButton()
      ],
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String toolTip;
  final Icon icon;
  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
    required this.toolTip,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      tooltip: toolTip,
      onPressed: onPressed,
      child: icon,
    );
  }
}

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButtonWidget(
      key: UniqueKey(),
      onPressed: (){
        BlocProvider.of<FileBloc>(context).add(
          UploadFileEvent()
        );
      },
      toolTip: 'add image',
      icon: const Icon(Icons.add)
    );
  }
}

class SearchFloatingActionButton extends StatefulWidget {
  const SearchFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<SearchFloatingActionButton> createState() => _SearchFloatingActionButtonState();
}

class _SearchFloatingActionButtonState extends State<SearchFloatingActionButton> {
  double? upProgress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MyArc(progress: upProgress ?? 0, key: UniqueKey(),),
        FloatingActionButtonWidget(
          key: UniqueKey(),
          onPressed: (){
            final File? file = BlocProvider.of<FileBloc>(context).file;
            if (file != null) {
              uploadImage(file);
            }
          },
          toolTip: "search",
          icon: const Icon(Icons.search)
        ),
      ],
    );
  }

  Future<String> uploadImage(File file) async {
    final Dio dio = Dio();
    final String fileName = file.path.split('/').last;
    final FormData formData = FormData.fromMap({
      "upfile":
      await MultipartFile.fromFile(file.path, filename:fileName, contentType: MediaType("image", "jpeg")),
    });
    const String searchUrl = "https://yandex.ru/images/search";
    final Map<String, dynamic> params = {'rpt': 'imageview', 'format': 'json', 'request': '{"blocks":[{"block":"b-page_type_search-by-image__link"}]}'};
    final response = await dio.post(
      searchUrl,
      data: formData,
      queryParameters: params,
      onSendProgress: showUploadProgress
    );
    return response.data["blocks"][0]["params"]["url"];
  }

  void showUploadProgress(sent, total) {
    setState(() {
      upProgress = sent/total;
      if (sent == total) {
        upProgress = null;
      }
    });
  }
}

class MyPainter extends CustomPainter {
  final double progress;

  MyPainter({required this.progress});
  @override

  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 60, height: 60),
      vmath.radians(-90),
      vmath.radians(progress*360),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square
        ..color = Colors.green
        ..strokeWidth = 10,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyArc extends StatelessWidget {

  final double progress;
  const MyArc({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: MyPainter(progress: progress),
      size: const Size(60, 60),
    );
  }
}