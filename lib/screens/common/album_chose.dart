import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/empty_%08handler_widget.dart';

import 'package:provider/provider.dart';

class AlbumChose extends StatelessWidget {
  List<MediaViewModel> selectionsMedia;
  AlbumChose({required this.selectionsMedia, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albumsViewModel = Provider.of<AlbumsViewModel>(context);
    final albums = albumsViewModel.allAlbums;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .04),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(tr('notice.add_to')),
          ),
          body: (albums.isEmpty)
              ? const EmptyHandlerWidget()
              : ListView.builder(
                  itemCount: albums.length + 1,
                  itemBuilder: (context, index) {
                    if (index == albums.length) {
                      return _buildNewAlbum(context, albumsViewModel);
                    }
                    return _buildAlbum(albums[index], albumsViewModel, context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildAlbum(
    AlbumViewModel album,
    AlbumsViewModel albumsViewModel,
    BuildContext context,
  ) {
    return ListTile(
      onTap: () {
        final selector = Provider.of<SelectorProvider>(context, listen: false);
        albumsViewModel.addMediasToAlbum(selectionsMedia, album).then((value) {
          selector.clearSelection();
          Navigator.pop(context, "add_to_album");
        });
      },
      leading: FutureBuilder<Uint8List?>(
        future: album.albumBanner,
        builder: (context, snapshot) => AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: (snapshot.hasData)
                ? Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  )
                : const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
      title: Text(
        album.albumName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('(${album.mediaCount})'),
    );
  }

  Widget _buildNewAlbum(BuildContext context, AlbumsViewModel albumsViewModel) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop('create_new');
      },
      title: Text(tr('buttons.new_album')),
      leading: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: greyColor,
            child: Icon(
              Icons.library_add,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? greyColor20
                  : blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
