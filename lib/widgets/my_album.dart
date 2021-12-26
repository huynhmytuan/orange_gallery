import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/theme.dart';

class MyAlbum extends StatelessWidget {
  final String albumId;
  final String albumName;
  final int photoCount;
  final Future<File>? bannerImage;

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
        print('Open Album');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 5 / 4.5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: orangeColor20,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: FutureBuilder<File>(
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
                      return Image.file(file);
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
                plural('albums.photo', photoCount),
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
