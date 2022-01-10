import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orange_gallery/models/album.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumsViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  List<AlbumViewModel> _albums = [];

  AlbumsViewModel() {
    fetchAllAlbums();
    PhotoManager.addChangeCallback((value) => fetchAllAlbums());
  }

  void fetchAllAlbums() async {
    List<AssetPathEntity> _assetPathList = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.common,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate),
        ],
      ),
    );
    _albums = _assetPathList
        .map(
          (assetPathEntity) => AlbumViewModel(
            album: Album.fromAssetPath(assetPathEntity),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<AlbumViewModel> get allAlbums {
    return _albums;
  }

  AlbumViewModel? getAlbumByID(String id) {
    for (AlbumViewModel album in _albums) {
      if (album.id == id) {
        return album;
      }
    }
    return null;
  }

  Future<bool> deleteAlbum(AlbumViewModel album) async {
    if (Platform.isIOS) {
      bool isDeleted =
          await PhotoManager.editor.iOS.deletePath(album.getPathData);
      if (isDeleted) {
        _albums.remove(album);
        notifyListeners();
      }
      return isDeleted;
    } else if (Platform.isAndroid) {
      //TODO: delete in android
      return false;
    }
    return false;
  }
}
