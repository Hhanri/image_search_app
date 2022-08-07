import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_search_app/dialogs/error_dialog.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';
import 'package:image_search_app/screens/loading_screen.dart';
import 'package:image_search_app/widgets/image_widget.dart';
import 'package:image_search_app/widgets/row_floating_action_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
      listener: (BuildContext context, FileState state) {
        if (state.isLoading) {
          LoadingScreen.instance().show(context: context, text: "Loading...");
        } else {
          LoadingScreen.instance().hide();
        }
        if (state.errorMessage != null) {
          showErrorMessage(errorMessage: state.errorMessage ?? "Something went wrong", context: context);
        }
      },
      builder: (BuildContext context, FileState state) {
        return Scaffold(
          body: state is FileLoadedState
            ? ImageWidget(file: File(state.filePath))
            : null,
          floatingActionButton: const RowActonButtonWidget(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}