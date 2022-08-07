import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_search_app/file_bloc/file_bloc.dart';

void main() {
  group("testing file bloc", () {
    late FileBloc fileBloc;

    setUp(() {
      fileBloc = FileBloc();
    });

    tearDown(() {
      fileBloc.close();
    });

    test("check initial state of fileBloc", () {
      expect(fileBloc.state, const NoFileState(isLoading: false));
    });

    blocTest('file loaded, no error message, no loading, canSearch',
      build: () => fileBloc,
      act: (FileBloc bloc) => bloc.add(UploadFileEvent(file: File(""))),
      expect: () => [const FileLoadedState(filePath: "", canSearch: true, isLoading: false)]
    );
  });
}