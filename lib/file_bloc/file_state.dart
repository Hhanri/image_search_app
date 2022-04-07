part of 'file_bloc.dart';

@immutable
abstract class FileState {}

class NoFileState extends FileState {}

class FileLoadedState extends FileState {
  final File file;

  FileLoadedState({required this.file});
}