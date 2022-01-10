import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orange_gallery/screens/common/empty_screen.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/grouped_grid.dart';

import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatelessWidget {
  String albumId;
  AlbumDetailScreen({required this.albumId, Key? key}) : super(key: key);
  AlbumViewModel? album;

  @override
  Widget build(BuildContext context) {
    final albumsViewModel = Provider.of<AlbumsViewModel>(context);
    album = albumsViewModel.getAlbumByID(albumId);
    if (album == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyScreen(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(tr('buttons.back')))
          ],
        ),
      );
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            _buildAppBar(context, albumsViewModel),
          ];
        },
        body: FutureBuilder<List<MediaViewModel>>(
          future: album!.allMedias,
          builder: (context, snapshot) => (snapshot.hasData)
              ? GroupedGridView(assets: snapshot.data!)
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AlbumsViewModel albumProvider) {
    return Consumer<SelectorProvider>(
      builder: (context, selector, child) {
        return SliverAppBar(
          expandedHeight: 170,
          floating: false,
          pinned: true,
          foregroundColor: orangeColor,
          elevation: 1,
          backgroundColor: Theme.of(context).cardColor,
          leading: (selector.isSelectMode)
              ? Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        selector.clearSelection();
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                      ),
                    ),
                    Text(
                      selector.amount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                )
              : null,
          actions: [
            (selector.isSelectMode)
                ? PopupMenuButton(
                    enabled: (selector.amount != 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              Provider.of<MediasViewModel>(context,
                                      listen: false)
                                  .deleteAssets(selector.selections, context)
                                  .then((isDeleted) {
                                if (isDeleted) {
                                  if (album!.mediaCount == 0) {
                                    Navigator.pop(context);
                                  }
                                }
                                selector.clearSelection();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.delete')),
                                const Icon(Icons.delete_outline_rounded),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.move')),
                                const Icon(Icons.arrow_circle_up_outlined),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.new_album')),
                                const Icon(Icons.add_box_outlined),
                              ],
                            ),
                          ),
                        ];
                      }
                    },
                  )
                : PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () => selector.toggleSelectModeOn(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tr('buttons.select')),
                              const Icon(Icons.check_circle_outline_rounded),
                            ],
                          ),
                        ),
                        if (!album!.isAll)
                          PopupMenuItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.add_items')),
                                const Icon(Icons.add_photo_alternate_outlined),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          onTap: () {
                            albumProvider.deleteAlbum(album!).then((isDeleted) {
                              if (isDeleted) {
                                Navigator.of(context).pop();
                              } else {
                                Fluttertoast.showToast(
                                    msg: tr('notice.delete_album_fail'));
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tr('buttons.delete_album')),
                              const Icon(Icons.hide_image_outlined)
                            ],
                          ),
                        ),
                      ];
                    })
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).canvasColor,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(bottom: 10, left: 20),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album!.albumName,
                    style: MyThemes.textTheme.headline5,
                  ),
                  if (album!.lastModifiedTime != null)
                    Text(
                      tr('albums.last_modified') +
                          DateFormat.yMMMM(context.locale.languageCode)
                              .format(album!.lastModifiedTime!),
                      style: MyThemes.textTheme.bodyText1,
                    ),
                  Text(
                    plural('albums.item', album!.mediaCount),
                    style: MyThemes.textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
