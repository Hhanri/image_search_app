import 'package:flutter/material.dart';
import 'package:image_search_app/dialogs/generic_dialog.dart';

Future<void> showErrorMessage({
  required String errorMessage,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: errorMessage,
  );
}