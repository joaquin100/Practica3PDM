import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/creadas/bloc/creadas_bloc.dart';
import 'package:noticias/noticias/item_noticia.dart';

class MisNoticias extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final CreadasBloc bloc_custom_noticias;
  // ignore: non_constant_identifier_names
  MisNoticias({Key key, @required this.bloc_custom_noticias}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  CreadasBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis noticias"),
      ),
      body: BlocProvider<CreadasBloc>(
        create: (context) {
          _bloc = widget.bloc_custom_noticias..add(GetOwnsNewsEvent());
          return _bloc;
        },
        child: BlocConsumer<CreadasBloc, CreadasState>(
          listener: (context, state) {
            if (state is DataRemovedState)
              _showMessage(context, "Se ha borrado un elemento");
            else if (state is DataSavedErrorState)
              _showMessage(context, "${state.errorMessage}");
            else if (state is DataSavedState)
              _showMessage(context, "Se ha guardado un elemento");
            else if (state is DataFetchingState)
              _showMessage(context, "Descargando datos");
          },
          builder: (context, state) {
            return ListView.builder(
              itemCount: _bloc.getNoticiasList != null
                  ? _bloc.getNoticiasList.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey[100],
                    ),
                  ),
                  child: ItemNoticia(
                    noticia: _bloc.getNoticiasList[index],
                  ),
                  onDismissed: (direction) {
                    _bloc.add(
                      RemoveDataEvent(
                        index: index,
                        img: _bloc.getNoticiasList[index].urlToImage,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("$message"),
        ),
      );
  }
}
