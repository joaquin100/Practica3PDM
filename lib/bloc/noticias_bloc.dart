import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/secrets.dart';

part 'noticias_event.dart';
part 'noticias_state.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  NoticiasBloc() : super(NoticiasInitial());
  final _sportsLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=sports&$apiKey";

  final _businessLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=business&$apiKey";

  final _newsLink = "https://newsapi.org/v2/top-headlines?country=mx&$apiKey";

  @override
  Stream<NoticiasState> mapEventToState(
    NoticiasEvent event,
  ) async* {
    if (event is GetNewsEvent) {
      //request de noticias

      //desearelizar json -> dart

      //mapear resultado a lista de noticias

      //yield lista de noticias al estado

      try {
        List<Noticia> sportsNews = await _requestSportNoticias();
        List<Noticia> businessNews = await _requestBussinessNoticias();
        yield NoticiasSuccessState(
          noticiasSportList: sportsNews,
          noticiasBussinessList: businessNews,
        );
      } catch (e) {
        yield NoticiasErrorState(message: "Error al cargar noticias: $e");
      }
    } else if (event is GetAllNewsEvent) {
      try {
        List<Noticia> news = await _requestAllNoticias();
        yield AllnoticiasSuccessState(noticiasList: news);
      } catch (e) {
        yield NoticiasErrorState(message: "Error al cargar noticias: $e");
      }
    }
  }

  Future<List<Noticia>> _requestSportNoticias() async {
    Response response = await get(_sportsLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();

      print("NOTICIAS->$_noticiasList");
    }

    return _noticiasList;
  }

  Future<List<Noticia>> _requestBussinessNoticias() async {
    Response response = await get(_businessLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      //print("Algo");
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();

      print("NOTICIAS->$_noticiasList");
    }
    return _noticiasList;
  }

  Future<List<Noticia>> _requestAllNoticias() async {
    Response response = await get(_newsLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      //print("Algo");
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();

      print("NOTICIAS->$_noticiasList");
    }
    return _noticiasList;
  }
}
