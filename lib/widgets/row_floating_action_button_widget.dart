import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class SearchFloatingActionButton extends StatelessWidget {
  const SearchFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<double?>(
          stream: context.read<FileBloc>().upProgress.stream,
          builder: (context, snapshot) {
            return MyArc(progress: snapshot.data ?? 0, key: UniqueKey(),);
          }
        ),
        FloatingActionButtonWidget(
          key: UniqueKey(),
          onPressed: () {
            context.read<FileBloc>().enableButton
              ? context.read<FileBloc>().add(SearchImageEvent(context: context))
              : null;
          },
          toolTip: "search",
          icon: const Icon(Icons.search)
        ),
      ],
    );
  }
}


class MyPainter extends CustomPainter {
  final double progress;
  MyPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
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