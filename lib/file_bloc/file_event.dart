part of 'file_bloc.dart';

@immutable
abstract class FileEvent {}

class UploadFileEvent extends FileEvent {
  final File file;

  UploadFileEvent({required this.file});
}
