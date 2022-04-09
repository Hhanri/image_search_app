import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_search_app/pages/web_view_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

    on<CallYandex>((event, emit) async {
      if (file != null) {
        final Dio dio = Dio();
        final String fileName = file!.path.split('/').last;
        final FormData formData = FormData.fromMap({
          "upfile":
          await MultipartFile.fromFile(file!.path, filename:fileName, contentType: MediaType("image", "jpeg")),
        });
        const String searchUrl = "https://yandex.ru/images/search";
        final Map<String, dynamic> params = {'rpt': 'imageview', 'format': 'json', 'request': '{"blocks":[{"block":"b-page_type_search-by-image__link"}]}'};
        final response = await dio.post(
          searchUrl,
          data: formData,
          queryParameters: params,
          onSendProgress: event.onReceiveProgress
        );
        final String link= response.data["blocks"][0]["params"]["url"];
        final String url = "https://yandex.com/images/search?$link";
        Navigator.of(event.context).push(MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: url,
            onPageFinished: event.onPageFinished,
          )
        ));
      }
    });
  }
}
