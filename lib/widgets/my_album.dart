import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/screens/album/album_detail_screen.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:provider/provider.dart';

class MyAlbum extends StatelessWidget {
  final String albumId;
  final String albumName;
  final int photoCount;
  final Future<Uint8List?>? bannerImage;

  const MyAlbum({
    Key? key,
    required this.albumId,
    required this.albumName,
    required this.photoCount,
    this.bannerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (_) => AlbumDetailScreen(albumId: albumId),
          ),
        )
            .then((_) {
          Provider.of<SelectorProvider>(context, listen: false)
              .clearSelection();
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AspectRatio(
                aspectRatio: 5 / 4.5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: orangeColor20,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: FutureBuilder<Uint8List?>(
                    future: bannerImage,
                    builder: (_, snapshot) {
                      final file = snapshot.data;
                      if (file == null) {
                        return const Center(
                          child: Icon(
                            CupertinoIcons.cube_box,
                            size: 60,
                            color: greyColor60,
                          ),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text(
                  albumName,
                  textAlign: TextAlign.center,
                  style: MyThemes.textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                plural('albums.item', photoCount),
                style:
                    MyThemes.textTheme.bodyText2!.copyWith(color: greyColor60),
              )
            ],
          ),
        ),
      ),
    );
  }
}
