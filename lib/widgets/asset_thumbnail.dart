import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/utils/string_extension.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

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
              if (onTap != null) onTap!.call();
            },
            onLongPress: () {
              HapticFeedback.lightImpact();
              if (onLongPress != null) onLongPress!.call();
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
                            color: Colors.white.withOpacity(.5),
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
