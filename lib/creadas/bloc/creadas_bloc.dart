import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noticias/models/noticia.dart';
import 'package:path/path.dart' as Path;

part 'creadas_event.dart';
part 'creadas_state.dart';

class CreadasBloc extends Bloc<CreadasEvent, CreadasState> {
  List<Noticia> _ownNoticiasList;
  List<DocumentSnapshot> _documentsList;
  List<Noticia> get getNoticiasList => _ownNoticiasList;
  CreadasBloc() : super(CreadasInitial());

  @override
  Stream<CreadasState> mapEventToState(
    CreadasEvent event,
  ) async* {
    if (event is GetOwnsNewsEvent) {
      try {
        yield DataFetchingState();
        await _getAllownsNews();
        yield DataRetrievedState();
      } catch (e) {
        yield DataSavedErrorState(errorMessage: "No se pudo recuperar datos");
      }
    } else if (event is SaveDataEvent) {
      try {
        print("inicia guardado");
        await _saveNoticia(
          event.author,
          event.title,
          event.description,
          event.urlToImage,
          event.publishedAt,
        );
        print("termina guardado");
        print("inicia inserción");
        _ownNoticiasList.add(
          Noticia(
            author: event.author,
            title: event.title,
            description: event.description,
            urlToImage: event.urlToImage,
            publishedAt: event.publishedAt,
          ),
        );
        //await _getAllownsNews();
        print("termina inserción");
        yield DataSavedState();
        yield DataRetrievedState();
        print("Se cargo la noticia");
      } catch (e) {
        yield DataSavedErrorState(
          errorMessage:
              "Ha ocurrido un error inesperado. Intente guardar mas tarde",
        );
        print("No se cargo la noticia");
      }
    } else if (event is UploadFileEvent) {
      try {
        String imageUrl = await _uploadPicture(event.file);
        if (imageUrl != null) {
          yield FileUploaded(fileUrl: imageUrl);
        } else
          yield FileUploadFailed();
      } catch (e) {
        yield FileUploadFailed();
      }
    } else if (event is ChooseImageEvent) {
      File chosenImage = await _chooseImage(event.isFromCamera);
      if (chosenImage == null) {
        yield ChosenImageFailed();
      } else {
        yield ChosenImageLoaded(imgPath: chosenImage);
      }
    } else if (event is RemoveDataEvent) {
      try {
        await _documentsList[event.index].reference.delete();
        print("Se eliminó el documento");
        print(event.img);
        StorageReference photoRef =
            await FirebaseStorage.instance.getReferenceFromUrl(event.img);
        await photoRef.delete();
        print("Se eliminó la imagen del documento");
        await _getAllownsNews();
        //_documentsList.removeAt(event.index);
        //_apuntesList.removeAt(event.index);
        yield DataRemovedState();
      } catch (e) {
        yield DataSavedErrorState(
            errorMessage:
                "No se pudo eliminiar el archivo intente más tarde...");
      }
    }
  }

  Future _getAllownsNews() async {
    print("_getAllownsNews");
    // recuperar lista de docs guardados en Cloud firestore
    // mapear a objeto de dart (Apunte)
    // agregar cada ojeto a una lista

    var news = await FirebaseFirestore.instance.collection("noticias").get();
    _documentsList = news.docs;
    _ownNoticiasList = news.docs
        .map(
          (elemento) => Noticia(
            author: elemento["author"],
            title: elemento["title"],
            description: elemento["description"],
            urlToImage: elemento["urlToImage"],
            publishedAt: elemento["publishedAt"],
          ),
        )
        .toList();
  }

  Future<File> _chooseImage(bool isFromCamera) async {
    final picker = ImagePicker();
    final PickedFile chooseImage = await picker.getImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    return File(chooseImage.path);
  }

  Future<String> _uploadPicture(File image) async {
    String imagePath = image.path;
    // referencia al storage de firebase
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("noticias/${Path.basename(imagePath)}");

    // subir el archivo a firebase
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;

    dynamic imageURL = await reference.getDownloadURL();
    return imageURL;
  }

  Future _saveNoticia(
    String author,
    String title,
    String description,
    String urlToImage,
    String publishedAt,
  ) async {
    await FirebaseFirestore.instance.collection("noticias").doc().set(
      {
        "author": author,
        "title": title,
        "description": description,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
      },
    );
  }
}
