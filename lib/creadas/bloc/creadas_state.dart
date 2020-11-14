part of 'creadas_bloc.dart';

abstract class CreadasState extends Equatable {
  const CreadasState();

  @override
  List<Object> get props => [];
}

class CreadasInitial extends CreadasState {}

class OwnNoticiasSuccessState extends CreadasState {
  final List<Noticia> ownNoticiasList;
  OwnNoticiasSuccessState({
    @required this.ownNoticiasList,
  });
  @override
  List<Object> get props => [ownNoticiasList];
}

class NoticiasErrorState extends CreadasState {
  final String message;

  NoticiasErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}

class DataRemovedState extends CreadasState {
  @override
  List<Object> get props => [];
}

class DataSavedState extends CreadasState {
  @override
  List<Object> get props => [];
}

class DataFetchingState extends CreadasState {
  @override
  List<Object> get props => [];
}

class DataRetrievedState extends CreadasState {
  @override
  List<Object> get props => [];
}

class ChosenImageLoaded extends CreadasState {
  final File imgPath;
  ChosenImageLoaded({@required this.imgPath});
  @override
  List<Object> get props => [imgPath];
}

class ChosenImageFailed extends CreadasState {
  @override
  List<Object> get props => [];
}

class FileUploaded extends CreadasState {
  final dynamic fileUrl;
  FileUploaded({@required this.fileUrl});
  @override
  List<Object> get props => [fileUrl];
}

class FileUploadFailed extends CreadasState {
  @override
  List<Object> get props => [];
}

class DataSavedErrorState extends CreadasState {
  final String errorMessage;

  DataSavedErrorState({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
