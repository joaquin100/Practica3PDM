import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/noticias/item_noticia.dart';

class NoticiaDesportes extends StatefulWidget {
  final List<Noticia> noticias;
  NoticiaDesportes({Key key, @required this.noticias}) : super(key: key);

  @override
  _NoticiaDesportesState createState() => _NoticiaDesportesState();
}

class _NoticiaDesportesState extends State<NoticiaDesportes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.noticias.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemNoticia(noticia: widget.noticias[index]);
        },
      ),
    );
  }
}
