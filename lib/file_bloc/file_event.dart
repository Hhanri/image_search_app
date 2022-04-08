part of 'file_bloc.dart';

@immutable
abstract class FileEvent {}

class UploadFileEvent extends FileEvent {
}

class CallYandex extends FileEvent {
  final ProgressCallback onReceiveProgress;
  final BuildContext context;
  final PageFinishedCallback onPageFinished;

  CallYandex({
    required this.onPageFinished,
    required this.context,
    required this.onReceiveProgress
  });
}