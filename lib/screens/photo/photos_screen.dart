import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:orange_gallery/providers/photo_provider.dart';

import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatelessWidget {
  PhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);

    return NestedScrollView(
      scrollBehavior: const ScrollBehavior(
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      headerSliverBuilder: (context, value) {
        return [
          CustomAppBar(title: tr('photos.title')),
          // TranslucentSliverAppBar(),
        ];
      },
      body: (photoProvider.albums.isEmpty)
          ? Center(child: Text('data'))
          : buildImages(photoProvider.photos),
    );
  }

  Widget buildImages(List<AssetEntity> assets) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: assets.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.green,
              child: FutureBuilder<Uint8List?>(
                future: assets[index].thumbData,
                builder: (_, snapshot) {
                  final bytes = snapshot.data;
                  // If we have no data, display a spinner
                  if (bytes == null) return CircularProgressIndicator();
                  // If there's data, display it as an image
                  return InkWell(
                      onTap: () {
                        // TODO: navigate to Image/Video screen
                      },
                      child: Stack(
                        children: [
                          // Wrap the image in a Positioned.fill to fill the space
                          Positioned.fill(
                            child: Image.memory(bytes, fit: BoxFit.cover),
                          ),
                          // Display a Play icon if the asset is a video
                          if (assets[index].type == AssetType.video)
                            Center(
                              child: Container(
                                color: Colors.blue,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ));
                },
              ),
            );
          },
          staggeredTileBuilder: (int index) {
            if (index == 0) {
              return StaggeredTile.count(4, 0.5);
            } else {
              return StaggeredTile.count(2, index.isEven ? 2 : 1);
            }
          },
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ));
  }
}
