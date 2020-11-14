part of 'noticias_bloc.dart';

abstract class NoticiasState extends Equatable {
  const NoticiasState();

  @override
  List<Object> get props => [];
}

class NoticiasInitial extends NoticiasState {}

class NoticiasSuccessState extends NoticiasState {
  final List<Noticia> noticiasSportList;
  final List<Noticia> noticiasBussinessList;
  NoticiasSuccessState({
    @required this.noticiasSportList,
    @required this.noticiasBussinessList,
  });
  @override
  List<Object> get props => [noticiasSportList, noticiasBussinessList];
}

class AllnoticiasSuccessState extends NoticiasState {
  final List<Noticia> noticiasList;
  AllnoticiasSuccessState({
    @required this.noticiasList,
  });
  @override
  List<Object> get props => [noticiasList];
}

class NoticiasErrorState extends NoticiasState {
  final String message;

  NoticiasErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
