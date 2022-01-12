import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orange_gallery/screens/common/media_picker_screen.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';

import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/album_name_input_dialog.dart';
import 'package:orange_gallery/widgets/my_album.dart';
import 'package:provider/provider.dart';

class AlbumsViewAllScreen extends StatefulWidget {
  static const routeName = '/album-view-all';
  AlbumsViewAllScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AlbumsViewAllScreenState createState() => _AlbumsViewAllScreenState();
}

class _AlbumsViewAllScreenState extends State<AlbumsViewAllScreen> {
  final StreamController<bool> rebuildEditMode =
      StreamController<bool>.broadcast();
  bool _isEditMode = false;
  _toggleEditMode() {
    _isEditMode = !_isEditMode;
    rebuildEditMode.add(_isEditMode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 1,
        title: Text(
          tr('albums.title'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _toggleEditMode();
            },
            icon: StreamBuilder<bool>(
              stream: rebuildEditMode.stream,
              initialData: false,
              builder: (context, snapshot) {
                return Icon(snapshot.data! ? Icons.edit_off : Icons.edit);
              },
            ),
          )
        ],
      ),
      body: Consumer<AlbumsViewModel>(
        builder: (context, albumsViewModel, child) {
          List<AlbumViewModel> albums = albumsViewModel.allAlbums;
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: GridView.builder(
              itemCount: albums.length + 1,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 5 / 6,
              ),
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return OutlinedButton.icon(
                    onPressed: () {
                      final selectorProvider =
                          Provider.of<SelectorProvider>(context, listen: false);
                      //Show in put name dialog
                      showDialog(
                        context: context,
                        builder: (ctx) => CustomTextInputDialog(),
                      ).then((albumName) {
                        //If name not null
                        if (albumName != null) {
                          //Show image picker
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (ctx) => MediaPickerScreen(
                              actionName: tr('buttons.create'),
                              action: () {
                                //When click add if this is iOS
                                if (Platform.isIOS) {
                                  albumsViewModel
                                      .createAlbum(albumName,
                                          selectorProvider.selections)
                                      .then(
                                    (result) {
                                      if (result) {
                                        Navigator.pop(context);
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: tr('notice.create_album_fail'),
                                        );
                                      }
                                    },
                                  );
                                }
                                //If this is android
                                else if (Platform.isAndroid) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ).then((value) {
                            if (Platform.isIOS) {
                              selectorProvider.clearSelection();
                            }
                            //If is in Android show action chooser
                            if (Platform.isAndroid) {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => BottomSheet(
                                  onClosing: () {},
                                  builder: (_) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.pop(
                                              context, ACTION_TYPE.copy);
                                        },
                                        title: const Text('Copy'),
                                        leading: const Icon(Icons.copy),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.pop(
                                              context, ACTION_TYPE.move);
                                        },
                                        title: const Text('Move'),
                                        leading: const Icon(
                                            Icons.drive_file_move_outlined),
                                      )
                                    ],
                                  ),
                                ),
                              ).then((value) {
                                print(value);
                                albumsViewModel
                                    .createAlbum(
                                        albumName, selectorProvider.selections,
                                        type: value)
                                    .then(
                                  (result) {
                                    selectorProvider.clearSelection();
                                    if (!result) {
                                      Fluttertoast.showToast(
                                        msg: tr('notice.create_album_fail'),
                                      );
                                    }
                                  },
                                );
                              });
                            }
                          });
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      side: const BorderSide(width: 1.0, color: orangeColor),
                    ),
                    icon: const Icon(CupertinoIcons.add),
                    label: Text(tr('buttons.new_album')),
                  );
                }
                return Stack(
                  children: [
                    MyAlbum(
                      albumId: albums[index - 1].id,
                      albumName: albums[index - 1].albumName,
                      photoCount: albums[index - 1].mediaCount,
                      bannerImage: albums[index - 1].albumBanner,
                    ),
                    StreamBuilder<bool>(
                      stream: rebuildEditMode.stream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.data!) {
                          return Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                albumsViewModel.deleteAlbum(albums[index - 1]);
                              },
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.zero,
                              iconSize: 30,
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.do_not_disturb_on,
                                color: orangeColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
