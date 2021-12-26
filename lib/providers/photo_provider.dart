import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Directory, File, Platform;

import 'package:photo_manager/photo_manager.dart';

enum ACTION_TYPE {
  copy,
  move,
}

class PhotoProvider extends ChangeNotifier {
  List<AssetPathEntity> _albums = [];

  PhotoProvider() {
    _fetchAssets();
  }

  void _saveAsset(AssetEntity asset, String path, File file) {
    if (asset.type == AssetType.image) {
      PhotoManager.editor.saveImageWithPath(path).then((value) => print(path),
          onError: (error) => print("Error --- " + path));
    } else if (asset.type == AssetType.video) {
      PhotoManager.editor.saveVideo(file, relativePath: path).then(
          (value) => print(path),
          onError: (error) => print("Error --- " + path));
    }
  }

  Future<String> _createFolder(String cow) async {
    String media_dir = (await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DCIM));
    final Directory dir = Directory(media_dir + "/$cow");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return '';
    } else {
      dir.create();
      return dir.path;
    }
  }

  //Get all albums
  _fetchAssets() async {
    await PhotoManager.getAssetPathList().then((albums) {
      print(albums);
      _albums.addAll(albums);
    }, onError: (error) {
      print('Sai gi do roi ne');
    });

    notifyListeners();
  }

  ///Return all albums
  List<AssetPathEntity> get albums {
    if (_albums.isEmpty) {
      _fetchAssets();
      return _albums;
    } else {
      return _albums;
    }
  }

  ///Get an album by it's ID
  ///
  ///Return an [AssetPathEntity]
  AssetPathEntity getAlbumById(String id) {
    AssetPathEntity album = _albums.firstWhere((album) => album.id == id);
    return album;
  }

  ///Create new album from name
  ///assets: photos/video which add to 'new album'
  ///Android only: type [ACTION_TYPE] of action copy / move
  ///
  ///Return an album id [String], if can't create return [null]
  String? createAlbum(String albumName, List<AssetEntity> assets,
      {ACTION_TYPE? type}) {
    if (Platform.isIOS) {
      PhotoManager.editor.iOS.createAlbum(albumName).then(
        (newAlbum) {
          _fetchAssets();
          // PhotoManager.editor.android.
          return newAlbum!.id;
        },
      );
    } else if (Platform.isAndroid) {
      _createFolder(albumName).then(
        (albumPath) {
          // check if album is exist
          if (albumPath.isNotEmpty) {
            switch (type) {
              case ACTION_TYPE.copy:
                for (var asset in assets) {
                  asset.file.then(
                    (file) {
                      file!.copy('$albumPath/${basename(file.path)}');
                      _saveAsset(
                          asset, '$albumPath/${basename(file.path)}', file);
                    },
                  );
                }
                break;
              case ACTION_TYPE.move:
                for (var asset in assets) {
                  asset.file.then((file) {
                    //Copy image file to new folder
                    file!.copy('$albumPath/${basename(file.path)}');
                    _saveAsset(
                        asset, '$albumPath/${basename(file.path)}', file);
                    //Delete file
                    file.delete();
                  });
                  return _albums
                      .firstWhere((album) => album.name == albumName)
                      .id;
                }
                break;
              default:
                print("fail");
            }
          }
        },
      );
      notifyListeners();
    }
    return null;
  }
}
