import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orange_gallery/widgets/empty_%08handler_widget.dart';
import 'package:orange_gallery/screens/common/media_picker_screen.dart';

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/utils/constants.dart';

import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/album_name_input_dialog.dart';
import 'package:orange_gallery/widgets/grouped_grid.dart';

import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatelessWidget {
  static const routeName = '/album-detail';
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
            const EmptyHandlerWidget(),
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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const EmptyHandlerWidget();
                }
                return GroupedGridView(assets: snapshot.data!);
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AlbumsViewModel albumsViewModel) {
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
                          //Button: Remove Media From ALbum
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.remove_from_album')),
                                const Icon(Icons.remove_circle_outline_rounded),
                              ],
                            ),
                          ),
                          //Button: Delete Media From ALbum
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('buttons.delete')),
                                const Icon(Icons.delete_outline_rounded),
                              ],
                            ),
                          ),
                          //Button: add selections to new album
                          PopupMenuItem(
                            value: 3,
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
                    onSelected: (value) {
                      switch (value) {
                        case 1: // Case Remove Media From ALbum
                          Provider.of<AlbumsViewModel>(context, listen: false)
                              .removeMediaInAlbum(selector.selections, album!)
                              .then(
                            (isRemoved) {
                              if (isRemoved) {
                                if (album!.mediaCount == 0) {
                                  Navigator.pop(context);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: tr('notice.remove_media_fail'));
                              }
                              selector.clearSelection();
                            },
                          );
                          break;
                        case 2: //Delete Media From ALbum
                          Provider.of<MediasViewModel>(context, listen: false)
                              .deleteAssets(selector.selections, context)
                              .then(
                            (isRemoved) {
                              if (isRemoved) {
                                if (album!.mediaCount == 0) {
                                  Navigator.pop(context);
                                }
                              }
                              selector.clearSelection();
                            },
                          );
                          break;
                        case 3: // Case create new album from selections.
                          showDialog(
                            context: context,
                            builder: (ctx) => CustomTextInputDialog(),
                          ).then(
                            (albumName) {
                              if (albumName != null) {
                                albumsViewModel
                                    .createAlbum(albumName, selector.selections)
                                    .then(
                                  (value) {
                                    selector.clearSelection();
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            },
                          );
                          break;
                        default:
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
                        // if (!album!.isAll)
                        //Button: Add Item to album
                        PopupMenuItem(
                          value: 2,
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
                            albumsViewModel
                                .deleteAlbum(album!)
                                .then((isDeleted) {
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
                    },
                    onSelected: (value) {
                      //Case add medias to album
                      if (value == 2) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => MediaPickerScreen(
                            actionName: tr('buttons.add'),
                            action: () {
                              List<MediaViewModel> selections =
                                  selector.selections;
                              albumsViewModel
                                  .addMediasToAlbum(
                                selections,
                                album!,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ).then((value) {
                          selector.clearSelection();
                        });
                      }
                    },
                  )
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      album!.albumName,
                      style: MyThemes.textTheme.headline5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
