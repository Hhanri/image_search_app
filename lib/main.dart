import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              child: state is FileLoadedState
                ? ImageWidget(file: state.file)
                : null
            ),
            floatingActionButton: const RowActonButtonWidget(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

