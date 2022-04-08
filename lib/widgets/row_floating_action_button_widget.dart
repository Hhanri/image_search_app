import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';

class RowActonButtonWidget extends StatelessWidget {
  const RowActonButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButtonWidget(
          key: UniqueKey(),
          onPressed: (){

          },
          toolTip: "search",
          icon: const Icon(Icons.search)
        ),
        FloatingActionButtonWidget(
          key: UniqueKey(),
          onPressed: (){
            BlocProvider.of<FileBloc>(context).add(
              UploadFileEvent()
            );
          },
          toolTip: 'add image',
          icon: const Icon(Icons.add)
        )
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
      child: icon
    );
  }
}