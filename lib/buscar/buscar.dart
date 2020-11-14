import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/bloc/noticias_bloc.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/noticias/item_noticia.dart';

class Buscar extends StatefulWidget {
  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  List<Noticia> _listFilteredNews;
  var _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noticias de la semana"),
      ),
      body: BlocProvider(
        create: (context) => NoticiasBloc()..add(GetAllNewsEvent()),
        child: BlocConsumer<NoticiasBloc, NoticiasState>(
          listener: (context, state) {
            //
          },
          builder: (context, state) {
            if (state is AllnoticiasSuccessState) {
              if (_listFilteredNews == null)
                _listFilteredNews = state.noticiasList;

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchTextController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Buscar Noticias",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        //
                        setState(() {
                          if (_searchTextController.text == "") {
                            _listFilteredNews = state.noticiasList;
                          } else {
                            _listFilteredNews = state.noticiasList.where(
                              (news) {
                                return news.title
                                    .toLowerCase()
                                    .contains(_searchTextController.text);
                              },
                            ).toList();
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _listFilteredNews.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemNoticia(noticia: _listFilteredNews[index]);
                        },
                      ),
                    )
                  ],
                ),
              );

              /*return ListView.builder(
                itemCount: _listFilteredNews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemNoticia(noticia: _listFilteredNews[index]);
                },
              );*/
            }
            return Center(
              child: Text("No hay noticias disponibles"),
            );
          },
        ),
      ),
    );
  }
}
