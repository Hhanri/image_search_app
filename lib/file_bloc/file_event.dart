part of 'file_bloc.dart';

@immutable
abstract class FileEvent {}

class UploadFileEvent extends FileEvent {
}

class CallYandex extends FileEvent {
  final BuildContext context;
  final VoidCallback onPageExit;

  CallYandex({
    required this.onPageExit,
    required this.context,
  });
}

class SearchImageEvent extends FileEvent {
  final BuildContext context;

  SearchImageEvent({required this.context});
}