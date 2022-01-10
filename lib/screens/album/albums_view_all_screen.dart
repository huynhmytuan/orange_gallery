import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/widgets/my_album.dart';
import 'package:provider/provider.dart';

class AlbumsViewAllScreen extends StatefulWidget {
  AlbumsViewAllScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AlbumsViewAllScreenState createState() => _AlbumsViewAllScreenState();
}

class _AlbumsViewAllScreenState extends State<AlbumsViewAllScreen> {
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
                    onPressed: () {},
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
                return MyAlbum(
                  albumId: albums[index - 1].id,
                  albumName: albums[index - 1].albumName,
                  photoCount: albums[index - 1].mediaCount,
                  bannerImage: albums[index - 1].albumBanner,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
