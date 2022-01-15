import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/asset_thumbnail.dart';
import 'package:orange_gallery/widgets/empty_%08handler_widget.dart';
import 'package:provider/provider.dart';

///Media Picker Screen for add media to album
///or create new album.
class MediaPickerScreen extends StatelessWidget {
  ///Action name which will display on app bar
  ///ex: Add
  String actionName;

  ///Override action of app bar action button.
  Function action;

  MediaPickerScreen({Key? key, required this.actionName, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .04),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: Consumer<MediasViewModel>(
            builder: (context, mediasViewModel, child) {
              List<MediaViewModel> medias = mediasViewModel.mediaAssets;
              final selectorProvider =
                  Provider.of<SelectorProvider>(context, listen: false);
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Scrollbar(
                  child: (medias.isEmpty)
                      ? const EmptyHandlerWidget()
                      : GridView.builder(
                          itemCount: medias.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            return AssetThumbnail(
                              asset: medias[index],
                              onTap: () {
                                selectorProvider.addSelection(medias[index]);
                              },
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      title: Consumer<SelectorProvider>(
          builder: (context, selectorProvider, child) {
        return Text('${selectorProvider.amount} ${tr('notice.selected')}');
      }),
      actions: [
        Consumer<SelectorProvider>(builder: (context, selectorProvider, child) {
          return TextButton(
            onPressed: (selectorProvider.amount != 0)
                ? () {
                    action.call();
                  }
                : null,
            child: Text(actionName
                // style: MyThemes.textTheme.button,
                ),
          );
        })
      ],
    );
  }
}
