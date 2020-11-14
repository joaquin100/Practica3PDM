import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/creadas/bloc/creadas_bloc.dart';

class CrearNoticia extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final CreadasBloc bloc_custom_noticias;
  // ignore: non_constant_identifier_names
  CrearNoticia({Key key, @required this.bloc_custom_noticias})
      : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}

//tomar fotos de camara o galeria

class _CrearNoticiaState extends State<CrearNoticia> {
  CreadasBloc _bloc;
  File _choosenImage;
  String _url;
  bool _isLoading = false;

  TextEditingController _authorController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CreadasBloc>(
        create: (context) {
          _bloc = widget.bloc_custom_noticias..add(GetOwnsNewsEvent());
          return _bloc;
        },
        child: BlocConsumer<CreadasBloc, CreadasState>(
          listener: (context, state) {
            if (state is DataSavedState)
              _showMessage(context, "Se ha guardado un elemento");
          },
          builder: (context, state) {
            if (state is ChosenImageLoaded) {
              _choosenImage = state.imgPath;
            }
            if (state is FileUploaded) {
              _url = state.fileUrl;
              _saveData();
            }
            return generateAddNews();
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

  void _saveData() {
    _bloc.add(
      SaveDataEvent(
        title: _titleController.text,
        author: _authorController.text,
        description: _descripcionController.text,
        urlToImage: _url,
        publishedAt: DateTime.now().toString(),
      ),
    );
    _titleController.clear();
    _authorController.clear();
    _descripcionController.clear();
    _choosenImage = null;

    _isLoading = false;
  }

  Widget generateAddNews() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _choosenImage != null
                    ? Image.file(
                        _choosenImage,
                        width: 150,
                        height: 150,
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        child: Placeholder(
                          fallbackHeight: 150,
                          fallbackWidth: 150,
                        ),
                      ),
                SizedBox(height: 48),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    //aquí va el modal para elegir entre una foto de la galeria o de la cámara
                    bool isFromCamera = await showModalBottomSheet(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        // para refrescar la botton sheet en caso de ser necesario
                        builder: (context, setModalState) =>
                            _menuWithOptions(context, setModalState),
                      ),
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                    );
                    _bloc.add(ChooseImageEvent(isFromCamera: isFromCamera));
                  },
                ),
                SizedBox(height: 48),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Título de la noticia",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    hintText: "Autor de la noticia",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _descripcionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Descripción de la noticia",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Guardar"),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _bloc.add(UploadFileEvent(file: _choosenImage));
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            _isLoading ? CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _menuWithOptions(BuildContext context, StateSetter setModalState) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                child: Text("Camera"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            Expanded(
              child: MaterialButton(
                child: Text("Gallery"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
