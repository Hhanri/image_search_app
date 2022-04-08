import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';
import 'package:image_search_app/widgets/image_widget.dart';
import 'package:image_search_app/widgets/row_floating_action_button_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(),
      child: BlocBuilder<FileBloc, FileState>(
        builder: (BuildContext context, FileState state) {
          return Scaffold(
            body: Center(
              child: ((){
                if (state is FileLoadedState) {
                  return ImageWidget(file: state.file);
                }
                return IconButton(
                  onPressed: () async {
                    BlocProvider.of<FileBloc>(context).add(UploadFileEvent());
                  },
                  icon: const Icon(Icons.add_circle_outline_outlined),
                );
              }())
            ),
            floatingActionButton: const RowActonButtonWidget(),
          );
        },
      ),
    );
  }
}

