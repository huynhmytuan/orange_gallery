import 'dart:io';
import 'dart:typed_data';

import 'package:orange_gallery/models/media_asset.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaAssetViewModel {
  MediaAsset _mediaAsset;
  MediaAssetViewModel({required MediaAsset mediaAsset})
      : _mediaAsset = mediaAsset;

  String get id {
    return _mediaAsset.id;
  }

  Future<Uint8List?> get thumbnail {
    // return _mediaAsset.assetThumbnail;
    return _mediaAsset.asset.thumbDataWithOption((Platform.isIOS)
        ? ThumbOption.ios(
            width: 250,
            height: 50,
            deliveryMode: DeliveryMode.highQualityFormat,
            resizeMode: ResizeMode.fast,
          )
        : const ThumbOption(width: 100, height: 100));
  }

  Future<Uint8List?> get originBytes {
    // return _mediaAsset.originBytes;
    return _mediaAsset.asset.originBytes;
  }

  Future<File?> get file {
    // return _mediaAsset.assetFile;
    return _mediaAsset.asset.file;
  }

  AssetType get mediaType {
    // return _mediaAsset.assetType;
    return _mediaAsset.asset.type;
  }

  int get duration {
    // return _mediaAsset.duration;
    return _mediaAsset.asset.duration;
  }

  DateTime get createDt {
    // return _mediaAsset.createDt;
    return _mediaAsset.asset.createDateTime;
  }

  DateTime get modifiedDt {
    // return _mediaAsset.modifiedDt;
    return _mediaAsset.asset.modifiedDateTime;
  }

  double get latitude {
    // return _mediaAsset.latitude;
    return _mediaAsset.asset.latitude;
  }

  double get longitude {
    // return _mediaAsset.longitude;
    return _mediaAsset.asset.longitude;
  }

  int get height {
    // return _mediaAsset.height;
    return _mediaAsset.asset.height;
  }

  int get width {
    // return _mediaAsset.width;
    return _mediaAsset.asset.width;
  }
}
