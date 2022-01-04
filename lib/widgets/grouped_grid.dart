import 'dart:io';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange_gallery/view_models/media_asset_view_model.dart';

import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/screens/common/gallery_screen.dart';

import 'package:orange_gallery/utils/string_extension.dart';

import 'package:orange_gallery/theme.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

enum GROUP_TYPE {
  day,
  month,
  year,
}

class GroupedGridView extends StatelessWidget {
  List<MediaAssetViewModel> assets;
  GROUP_TYPE groupType;
  GroupedGridView({required this.assets, required this.groupType, Key? key})
      : super(key: key);

  late ScrollController _scrollController = ScrollController();

  List<List<MediaAssetViewModel>> _getSeparatedList(
      List<MediaAssetViewModel> assets, GROUP_TYPE type) {
    List<List<MediaAssetViewModel>> separatedAssets = assets.splitBetween(
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
    List<List<MediaAssetViewModel>> results =
        _getSeparatedList(assets, groupType);
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
                  margin: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
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
                        style: MyThemes.textTheme.bodyText1,
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
                          MaterialPageRoute(
                            builder: (_) => GalleryScreen(
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
  final MediaAssetViewModel asset;

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
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
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
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        // asset.duration.toString().split('.')[0],
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
                            color: Colors.grey.withOpacity(.6),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
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
