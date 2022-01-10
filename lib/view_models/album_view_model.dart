import 'dart:typed_data';

import 'package:orange_gallery/models/album.dart';
import 'package:orange_gallery/models/media.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumViewModel {
  Album _album;

  AlbumViewModel({required Album album}) : _album = album;

  String get id {
    return _album.id;
  }

  String get albumName {
    return _album.albumName;
  }

  int get mediaCount {
    return _album.itemCount;
  }

  bool get isAll {
    return _album.isAll;
  }

  DateTime? get lastModifiedTime {
    return _album.lastModifiedTime;
  }

  AssetPathEntity get getPathData {
    return _album.fullData;
  }

  Future<List<MediaViewModel>> get allMedias async {
    List<AssetEntity> _allAssetEntity =
        await _album.fullData.getAssetListRange(start: 0, end: 10000);
    return _allAssetEntity
        .map(
          (asset) => MediaViewModel(
            mediaAsset: Media.fromAsset(asset),
          ),
        )
        .toList();
  }

  Future<Uint8List?> get albumBanner async {
    List<AssetEntity> _allAssetEntity =
        await _album.fullData.getAssetListRange(start: 0, end: 1);
    MediaViewModel media = MediaViewModel(
      mediaAsset: Media.fromAsset(_allAssetEntity.first),
    );
    return media.thumbnail;
  }
}
