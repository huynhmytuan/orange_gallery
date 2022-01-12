import 'dart:io';
import 'package:path/path.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/models/album.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumsViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  List<AlbumViewModel> _albums = [];

  AlbumsViewModel() {
    PhotoManager.addChangeCallback((change) => fetchAllAlbums());
    fetchAllAlbums();
  }

  void fetchAllAlbums() async {
    List<AssetPathEntity> _assetPathList = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.common,
      filterOption: FilterOptionGroup(
        containsEmptyAlbum: true,
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

  ///Only in iOS
  Future<bool> removeMediaInAlbum(
      List<MediaViewModel> medias, AlbumViewModel album) async {
    final listAssets = medias.map((e) => e.fullData).toList();
    final albumPathEntiy = album.getPathData;
    bool result = await PhotoManager.editor.iOS
        .removeAssetsInAlbum(listAssets, albumPathEntiy);
    fetchAllAlbums();
    return result;
  }

  Future<bool> deleteAlbum(AlbumViewModel album) async {
    if (Platform.isIOS) {
      bool isDeleted =
          await PhotoManager.editor.iOS.deletePath(album.getPathData);
      if (isDeleted) {
        fetchAllAlbums();
      }
      return isDeleted;
    } else if (Platform.isAndroid) {
      //TODO - Delete album in android
      return false;
    }
    return false;
  }

  ///Create new album
  Future<bool> createAlbum(String albumName, List<MediaViewModel> medias,
      {ACTION_TYPE? type}) async {
    List<AssetEntity> assets = medias.map((media) => media.fullData).toList();
    if (Platform.isIOS) {
      final newAlbum = await PhotoManager.editor.iOS.createAlbum(albumName);
      if (newAlbum != null) {
        for (var asset in assets) {
          await PhotoManager.editor
              .copyAssetToPath(asset: asset, pathEntity: newAlbum);
        }
        fetchAllAlbums();
        return true;
      }
    } else if (Platform.isAndroid) {
      _createFolder(albumName).then(
        (albumPath) {
          // check if album is exist
          if (albumPath.isNotEmpty) {
            switch (type) {
              case ACTION_TYPE.copy:
                try {
                  for (var asset in assets) {
                    asset.file.then(
                      (file) {
                        file!
                            .copy('$albumPath/${basename(file.path)}')
                            .then((copy) {
                          _saveAsset(
                              asset, '$albumPath/${basename(copy.path)}', file);
                        });
                      },
                    );
                  }
                  fetchAllAlbums();
                  return true;
                } catch (e) {
                  print(e);
                }
                break;
              case ACTION_TYPE.move:
                try {
                  for (var asset in assets) {
                    asset.file.then((file) {
                      //Copy image file to new folder
                      file!.copy('$albumPath/${basename(file.path)}');
                      _saveAsset(
                          asset, '$albumPath/${basename(file.path)}', file);
                      //Delete file
                      file.delete();
                    });
                  }
                  fetchAllAlbums();
                  return true;
                } catch (e) {
                  print(e);
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
    return false;
  }

  Future<void> addMediasToAlbum(
      List<MediaViewModel> medias, AlbumViewModel album) async {
    for (var media in medias) {
      await PhotoManager.editor.copyAssetToPath(
          asset: media.fullData, pathEntity: album.getPathData);
    }
    fetchAllAlbums();
  }

  Future<String> _createFolder(String cow) async {
    String mediaDir = (await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DCIM));
    final Directory dir = Directory(mediaDir + "/$cow");
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

  void _saveAsset(AssetEntity asset, String path, File file) {
    if (asset.type == AssetType.image) {
      PhotoManager.editor.saveImageWithPath(path).then(
            (value) => print(path),
            onError: (error) => print("Error: $error --- " + path),
          );
    } else if (asset.type == AssetType.video) {
      PhotoManager.editor.saveVideo(file, relativePath: path).then(
          (value) => print(path),
          onError: (error) => print("Error: $error --- " + path));
    }
  }
}
