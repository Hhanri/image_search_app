part of 'file_bloc.dart';

@immutable
abstract class FileEvent {}

class UploadFileEvent extends FileEvent {
}

class CallYandex extends FileEvent {
  final BuildContext context;
  CallYandex({required this.context});
}

class SearchImageEvent extends FileEvent {
  final BuildContext context;

  SearchImageEvent({required this.context});
}

class EnableSearchEvent extends FileEvent {}