part of 'creadas_bloc.dart';

abstract class CreadasEvent extends Equatable {
  const CreadasEvent();

  @override
  List<Object> get props => [];
}

class GetOwnsNewsEvent extends CreadasEvent {}

class RemoveDataEvent extends CreadasEvent {
  final int index;
  final String img;
  RemoveDataEvent({
    @required this.index,
    @required this.img,
  });
  @override
  List<Object> get props => [index, img];
}

class SaveDataEvent extends CreadasEvent {
  final String author;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;

  SaveDataEvent({
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.urlToImage,
    @required this.publishedAt,
  });

  @override
  List<Object> get props => [author, title, description, urlToImage];
}

class ChooseImageEvent extends CreadasEvent {
  final bool isFromCamera;

  ChooseImageEvent({@required this.isFromCamera});
  @override
  List<Object> get props => [];
}

class UploadFileEvent extends CreadasEvent {
  final File file;
  UploadFileEvent({@required this.file});
  @override
  List<Object> get props => [file];
}
