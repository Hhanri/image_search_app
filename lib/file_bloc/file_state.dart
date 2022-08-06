part of 'file_bloc.dart';

@immutable
abstract class FileState {
  final bool isLoading;
  final String? errorMessage;
  const FileState({required this.isLoading, this.errorMessage});
}

class NoFileState extends FileState {
  const NoFileState({required bool isLoading}) : super(isLoading: isLoading);
}

class FileLoadedState extends FileState {
  final File file;
  final bool canSearch;
  const FileLoadedState({required this.file, required this.canSearch, required isLoading, errorMessage}) : super(isLoading: isLoading, errorMessage: errorMessage);
}