part of 'file_bloc.dart';

@immutable
abstract class FileState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  const FileState({required this.isLoading, this.errorMessage});
}

class NoFileState extends FileState {
  const NoFileState({required bool isLoading}) : super(isLoading: isLoading);

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, errorMessage];
}

class FileLoadedState extends FileState {
  final String filePath;
  final bool canSearch;
  const FileLoadedState({required this.filePath, required this.canSearch, required isLoading, errorMessage}) : super(isLoading: isLoading, errorMessage: errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [canSearch, isLoading, errorMessage];
}