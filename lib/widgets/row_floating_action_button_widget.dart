import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';

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
  final bool isEnabled;
  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
    required this.toolTip,
    required this.icon,
    this.isEnabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isEnabled ? null : Colors.white60,
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
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        final bool isEnabled = state is FileLoadedState;
        return FloatingActionButtonWidget(
          isEnabled: isEnabled,
          key: UniqueKey(),
          onPressed: () {
            if (isEnabled && (context.read<FileBloc>().state as FileLoadedState).canSearch) context.read<FileBloc>().add(SearchImageEvent(context: context));
          },
          toolTip: "search",
          icon: const Icon(Icons.search)
        );
      },
    );
  }
}