import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_search_app/pages/web_view_page.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  File? _file;
  final Dio _dio = Dio();

  FileBloc() : super(const NoFileState(isLoading: false)) {
    on<UploadFileEvent>((event, emit) async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _file = File(image.path);
        add(EnableSearchEvent());
      }
    });

    on<SearchImageEvent>((event, emit) {
      if (_file != null) {
        emit(FileLoadedState(file: _file!, canSearch: false, isLoading: true));
        add(CallYandex(context: event.context,));
      }
    });

    on<CallYandex>((event, emit) async {
      if (_file != null) {
        final String fileName = _file!.path.split('/').last;
        final FormData formData = FormData.fromMap({
          "upfile": await MultipartFile.fromFile(_file!.path, filename:fileName, contentType: MediaType("image", "jpeg")),
        });
        const String searchUrl = "https://yandex.ru/images/search";
        final Map<String, dynamic> params = {'rpt': 'imageview', 'format': 'json', 'request': '{"blocks":[{"block":"b-page_type_search-by-image__link"}]}'};
        try {
          final response = await _dio.post(
            searchUrl,
            data: formData,
            queryParameters: params,
          );
          final String link= response.data["blocks"][0]["params"]["url"];
          final String url = "https://yandex.com/images/search?$link";
          emit(FileLoadedState(file: _file!, canSearch: false, isLoading: false));
          Navigator.of(event.context).push(MaterialPageRoute(
            builder: (_) => WebViewScreen(url: url,)
          ));
        } catch (error) {
          emit(FileLoadedState(file: _file!, canSearch: true, isLoading: false, errorMessage: error.toString()));
        }
      }
    });

    on<EnableSearchEvent>((event, emit) {
      emit(FileLoadedState(file: _file!, canSearch: true, isLoading: false));
    });
  }

  @override
  Future<void> close() async {
    _dio.close();
    super.close();
  }
}
