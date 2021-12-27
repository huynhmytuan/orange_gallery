import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/utils/string_extension.dart';

import 'package:orange_gallery/theme.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants.dart';

class GroupedGridView extends StatelessWidget {
  List<AssetEntity> assets;
  GroupedGridView({required this.assets, Key? key}) : super(key: key);
  List<List<AssetEntity>> getSeparatedList(List<AssetEntity> assets) {
    List<List<AssetEntity>> separatedAssets = assets
        .splitBetween((first, second) =>
            ((first.createDateTime.month != second.createDateTime.month) &&
                (first.createDateTime.year != second.createDateTime.year)))
        .toList();
    return separatedAssets;
  }

  @override
  Widget build(BuildContext context) {
    List<List<AssetEntity>> results = getSeparatedList(assets);
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: results.map((assetsList) {
          DateTime assetCreatedTime = assetsList.first.createDateTime;
          DateTime today = DateTime.now();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
                child: Text(
                  (today.month == assetCreatedTime.month &&
                          today.year == assetCreatedTime.year)
                      ? tr('photos.recent')
                      : DateFormat.yMMMM(context.locale.languageCode)
                          .format(assetCreatedTime)
                          .capitalize(),
                  style: MyThemes.textTheme.bodyText1,
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assetsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    return AssetThumbnail(asset: assetsList[index]);
                  })
            ],
          );
        }).toList(),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
      onTap: () {},
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbData,
        builder: (_, snapshot) {
          final bytes = snapshot.data;
          // If we have no data, display an error item.
          if (bytes == null) {
            return Container(
              color: Theme.of(context).focusColor,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            );
          }
          // If there's data, display it as an image
          return Stack(children: [
            Positioned.fill(
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
            if (asset.type == AssetType.video)
              const Center(
                child: Icon(
                  Icons.play_circle,
                  size: 40,
                  color: greyColor20,
                ),
              ),
          ]);
        },
      ),
    );
  }
}
