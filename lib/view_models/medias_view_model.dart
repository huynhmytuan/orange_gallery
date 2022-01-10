import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/models/media.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/widgets/custom_delete_dialog.dart';
import 'package:path/path.dart';
import 'dart:io' show Directory, File, Platform;

import 'package:photo_manager/photo_manager.dart';

class MediasViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  List<MediaViewModel> _mediaAssets = [];

  void fetchAllMedias() async {
    loadingStatus = LoadingStatus.loading;
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.common,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate),
        ],
      ),
    );
    AssetPathEntity recentAlbum = albums.first;
    List<AssetEntity> assets =
        await recentAlbum.getAssetListRange(start: 0, end: 100000);
    _mediaAssets.clear();
    _mediaAssets = assets
        .map(
          (asset) => MediaViewModel(
            mediaAsset: Media.fromAsset(asset),
          ),
        )
        .toList();
    if (_mediaAssets.isEmpty) {
      loadingStatus = LoadingStatus.empty;
    } else {
      loadingStatus = LoadingStatus.completed;
    }
    notifyListeners();
  }

  MediasViewModel() {
    PhotoManager.startChangeNotify();
    PhotoManager.addChangeCallback((value) => fetchAllMedias());
    // fetchAssets();
  }

  List<MediaViewModel> get mediaAssets {
    return _mediaAssets;
  }

  Future<bool> deleteAssets(
      List<MediaViewModel> assets, BuildContext context) async {
    List<String> ids = assets.map((e) => e.id).toList();
    if (Platform.isIOS) {
      final deletedIDs = await PhotoManager.editor.deleteWithIds(ids);
      if (deletedIDs.isEmpty) {
        return false;
      }
      assets.every((element) => mediaAssets.remove(element));
      notifyListeners();
      return true;
    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (ctx) {
          return CustomDeleteDialog(
            mediasDeleteCount: assets.length,
          );
        },
      ).then(
        (result) async {
          if (result == ConfirmAction.Accept) {
            assets.every((element) => mediaAssets.remove(element));
            notifyListeners();
            await PhotoManager.editor.deleteWithIds(ids);
            return true;
          } else {
            return false;
          }
        },
      );
    }
    return false;
  }

  // void _saveAsset(AssetEntity asset, String path, File file) {
  //   if (asset.type == AssetType.image) {
  //     PhotoManager.editor.saveImageWithPath(path).then(
  //           (value) => print(path),
  //           onError: (error) => print("Error --- " + path),
  //         );
  //   } else if (asset.type == AssetType.video) {
  //     PhotoManager.editor.saveVideo(file, relativePath: path).then(
  //         (value) => print(path),
  //         onError: (error) => print("Error --- " + path));
  //   }
  // }

  // Future<String> _createFolder(String cow) async {
  //   String mediaDir = (await ExternalPath.getExternalStoragePublicDirectory(
  //       ExternalPath.DIRECTORY_DCIM));
  //   final Directory dir = Directory(mediaDir + "/$cow");
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if ((await dir.exists())) {
  //     return '';
  //   } else {
  //     dir.create();
  //     return dir.path;
  //   }
  // }

  // //Get all albums
  // fetchAssets() async {
  //   _albums.clear();
  //   _albums = await PhotoManager.getAssetPathList(
  //     type: RequestType.common,
  //     filterOption: FilterOptionGroup(
  //       orders: [
  //         const OrderOption(type: OrderOptionType.createDate),
  //       ],
  //     ),
  //   );
  //   print(
  //       '[PhotoProvider] [DEBUG] Load ${_albums.length} album(s) from device.');
  //   notifyListeners();
  // }

  // ///Return all albums
  // List<AssetPathEntity> get albums {
  //   return _albums;
  // }

  // ///Return all photos in gallery
  // Future<List<AssetEntity>> get photos async {
  //   PhotoManager.getAssetPathList(
  //     onlyAll: true,
  //     type: RequestType.common,
  //     filterOption: FilterOptionGroup(
  //       orders: [
  //         const OrderOption(type: OrderOptionType.createDate),
  //       ],
  //     ),
  //   ).then((albums) {
  //     if (albums.isEmpty) {
  //       return _photos = [];
  //     }
  //     albums.first.assetList.then((assets) {
  //       _photos.clear();
  //       _photos.addAll(assets);
  //       debugPrint(
  //           '[PhotoProvider] [DEBUG] Load ${_photos.length} asset(s) from device.');
  //       return _photos;
  //     });
  //   });

  //   return _photos;
  // }

  // ///Get an album by it's ID
  // ///
  // ///Return an [AssetPathEntity]
  // AssetPathEntity getAlbumById(String id) {
  //   AssetPathEntity album = _albums.firstWhere((album) => album.id == id);
  //   return album;
  // }

  // ///Create new album from name
  // ///assets: photos/video which add to 'new album'
  // ///Android only: type [ACTION_TYPE] of action copy / move
  // ///
  // ///Return an album id [String], if can't create return [null]
  // String? createAlbum(String albumName, List<AssetEntity> assets,
  //     {ACTION_TYPE? type}) {
  //   if (Platform.isIOS) {
  //     PhotoManager.editor.iOS.createAlbum(albumName).then(
  //       (newAlbum) {
  //         fetchAssets();
  //         // PhotoManager.editor.android.
  //         return newAlbum!.id;
  //       },
  //     );
  //   } else if (Platform.isAndroid) {
  //     _createFolder(albumName).then(
  //       (albumPath) {
  //         // check if album is exist
  //         if (albumPath.isNotEmpty) {
  //           switch (type) {
  //             case ACTION_TYPE.copy:
  //               for (var asset in assets) {
  //                 asset.file.then(
  //                   (file) {
  //                     file!.copy('$albumPath/${basename(file.path)}');
  //                     _saveAsset(
  //                         asset, '$albumPath/${basename(file.path)}', file);
  //                   },
  //                 );
  //               }
  //               break;
  //             case ACTION_TYPE.move:
  //               for (var asset in assets) {
  //                 asset.file.then((file) {
  //                   //Copy image file to new folder
  //                   file!.copy('$albumPath/${basename(file.path)}');
  //                   _saveAsset(
  //                       asset, '$albumPath/${basename(file.path)}', file);
  //                   //Delete file
  //                   file.delete();
  //                 });
  //                 return _albums
  //                     .firstWhere((album) => album.name == albumName)
  //                     .id;
  //               }
  //               break;
  //             default:
  //               print("fail");
  //           }
  //         }
  //       },
  //     );
  //     notifyListeners();
  //   }
  //   return null;
  // }
}
