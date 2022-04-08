import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  File? file;
  FileBloc() : super(NoFileState()) {

    on<UploadFileEvent>((event, emit) async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file = File(image.path);
        emit(FileLoadedState(file: file!));
      }
    });
  }
}
