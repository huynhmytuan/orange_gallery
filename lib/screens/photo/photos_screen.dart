import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/providers/photo_provider.dart';
import 'package:orange_gallery/screens/empty_screen.dart';

import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:orange_gallery/widgets/grouped_grid.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatefulWidget {
  PhotosScreen({Key? key}) : super(key: key);
  bool isLoaded = false;

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!widget.isLoaded) {
        Provider.of<PhotoProvider>(context, listen: false).fetchAssets();
        setState(() {
          widget.isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);
    return FutureBuilder<List<AssetEntity>>(
      future: PhotoManager.getAssetPathList(onlyAll: true)
          .then((value) => value.first.assetList),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  CustomAppBar(title: tr('photos.title')),
                ];
              },
              body: (photoProvider.albums.isEmpty)
                  ? const EmptyScreen()
                  : GroupedGridView(assets: photoProvider.photos),
            );
        }
      },
    );
  }
}
