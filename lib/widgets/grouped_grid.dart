import 'dart:typed_data';
import 'package:orange_gallery/utils/string_extension.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:orange_gallery/screens/common/gallery_view_screen.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/theme.dart';

import '../utils/constants.dart';

class GroupedGridView extends StatelessWidget {
  List<MediaViewModel> assets;

  GroupedGridView({required this.assets, Key? key}) : super(key: key);

  late ScrollController _scrollController = ScrollController();

  List<List<MediaViewModel>> _getSeparatedList(List<MediaViewModel> assets) {
    List<List<MediaViewModel>> separatedAssets = assets.splitBetween(
      (first, second) {
        if (first.createDt.month != second.createDt.month) {
          return true;
        } else {
          if (first.createDt.year != second.createDt.year) {
            return true;
          } else {
            return false;
          }
        }
      },
    ).toList();
    return separatedAssets;
  }

  @override
  Widget build(BuildContext context) {
    List<List<MediaViewModel>> results = _getSeparatedList(assets);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            DateTime assetCreatedTime = results[index].first.createDt;
            DateTime today = DateTime.now();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 5, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (today.month == assetCreatedTime.month &&
                                today.year == assetCreatedTime.year)
                            ? tr('photos.recent')
                            : DateFormat.yMMMM(context.locale.languageCode)
                                .format(assetCreatedTime)
                                .capitalize(),
                        style: MyThemes.textTheme.bodyText2,
                      ),
                      Consumer<SelectorProvider>(
                        builder: (context, selectorProvider, child) {
                          if (selectorProvider.isSelectMode) {
                            return IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                selectorProvider
                                    .addAllSelection(results[index]);
                              },
                              icon: Icon(
                                (selectorProvider
                                        .isInSelections(results[index]))
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: orangeColor,
                                size: 24,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results[index].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemBuilder: (context, itemIndex) {
                    return AssetThumbnail(
                      asset: results[index][itemIndex],
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, _1, _2) => GalleryViewScreen(
                              assets: assets,
                              index: assets.indexOf(results[index][itemIndex]),
                            ),
                          ),
                        );
                      },
                    );
                    // );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final Function? onTap;
  final Function? onLongPress;
  final MediaViewModel asset;

  const AssetThumbnail({
    Key? key,
    required this.asset,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectorProvider =
        Provider.of<SelectorProvider>(context, listen: false);
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnail,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (!snapshot.hasData) {
          return Container(
            color: Theme.of(context).cardColor,
          );
        } else {
          return InkWell(
            excludeFromSemantics: true,
            enableFeedback: true,
            onTap: () {
              if (selectorProvider.isSelectMode) {
                selectorProvider.addSelection(asset);
                HapticFeedback.selectionClick();
              } else {
                if (onTap != null) onTap!.call();
              }
            },
            onLongPress: () {
              selectorProvider.addSelection(asset);
              if (onLongPress != null) onLongPress!.call();
              HapticFeedback.lightImpact();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: asset.id,
                    child: Image.memory(bytes!, fit: BoxFit.cover),
                  ),
                ),
                if (asset.mediaType == AssetType.video)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ''.formatDuration(asset.duration),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: Consumer<SelectorProvider>(
                    builder: (context, selector, child) {
                      if (selector.isInSelections([asset])) {
                        return Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(top: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.3),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: orangeColor,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
