import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';

class ItemNoticia extends StatelessWidget {
  final Noticia noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: Row(
            children: [
              /*child: Image.network(
                  "${noticia.urlToImage}",
                  //width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                ),*/
              Expanded(
                child: noticia.urlToImage == null
                    ? Placeholder(
                        fallbackHeight: 100,
                        fallbackWidth: 100,
                      )
                    : ExtendedImage.network(
                        "${noticia.urlToImage}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                        cache: true,
                      ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${noticia.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${noticia.publishedAt}",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "${noticia.description ?? "Descripcion no disponible"}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "${noticia.author ?? "Autor no disponible"}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
