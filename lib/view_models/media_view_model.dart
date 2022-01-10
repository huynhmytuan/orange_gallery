import 'dart:io';
import 'dart:typed_data';

import 'package:orange_gallery/models/media.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaViewModel {
  Media _media;
  MediaViewModel({required Media mediaAsset}) : _media = mediaAsset;

  String get id {
    return _media.id;
  }

  Future<Uint8List?> get thumbnail {
    // return _mediaAsset.assetThumbnail;
    return _media.asset.thumbDataWithOption((Platform.isIOS)
        ? ThumbOption.ios(
            width: 250,
            height: 250,
            deliveryMode: DeliveryMode.highQualityFormat,
            resizeMode: ResizeMode.fast,
          )
        : const ThumbOption(width: 300, height: 300));
  }

  Future<Uint8List?> get originBytes {
    // return _mediaAsset.originBytes;
    return _media.asset.originBytes;
  }

  Future<File?> get file {
    // return _mediaAsset.assetFile;
    return _media.asset.file;
  }

  AssetType get mediaType {
    // return _mediaAsset.assetType;
    return _media.asset.type;
  }

  int get duration {
    // return _mediaAsset.duration;
    return _media.asset.duration;
  }

  DateTime get createDt {
    // return _mediaAsset.createDt;
    return _media.asset.createDateTime;
  }

  DateTime get modifiedDt {
    // return _mediaAsset.modifiedDt;
    return _media.asset.modifiedDateTime;
  }

  double get latitude {
    // return _mediaAsset.latitude;
    return _media.asset.latitude;
  }

  double get longitude {
    // return _mediaAsset.longitude;
    return _media.asset.longitude;
  }

  int get height {
    // return _mediaAsset.height;
    return _media.asset.height;
  }

  int get width {
    // return _mediaAsset.width;
    return _media.asset.width;
  }
}
