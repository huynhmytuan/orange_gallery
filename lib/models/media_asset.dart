import 'package:photo_manager/photo_manager.dart';

class MediaAsset {
  final String id;
  final AssetEntity asset;
  // final Future<Uint8List?> assetThumbnail;
  // final Future<Uint8List?> originBytes;
  // final Future<File?> assetFile;
  // final AssetType assetType;
  // final int duration;
  // final Size size;
  // final int width;
  // final int height;
  // final DateTime createDt;
  // final DateTime modifiedDt;
  // final double latitude;
  // final double longitude;

  MediaAsset({
    required this.id,
    // required this.assetThumbnail,
    // required this.assetFile,
    // required this.originBytes,
    // required this.assetType,
    // required this.createDt,
    // required this.duration,
    // required this.size,
    // required this.height,
    // required this.width,
    // required this.modifiedDt,
    // required this.latitude,
    // required this.longitude,
    required this.asset,
  });

  factory MediaAsset.fromAsset(AssetEntity asset) {
    return MediaAsset(
        // id: asset['id'],
        // assetThumbnail: asset['thumbnail'],
        // assetFile: asset['file'],
        // originBytes: asset['originBytes'],
        // assetType: asset['type'],
        // createDt: asset['create_time'],
        // duration: asset['duration'],
        // size: asset['size'],
        // height: asset['height'],
        // width: asset['width'],
        // modifiedDt: asset['modified_time'],
        // latitude: asset['latitude'],
        // longitude: asset['longitude'],
        id: asset.id,
        // assetThumbnail: asset.thumbData,
        // assetFile: asset.file,
        // assetType: asset.type,
        // originBytes: asset.originBytes,
        // createDt: asset.createDateTime,
        // modifiedDt: asset.modifiedDateTime,
        // duration: asset.duration,
        // size: asset.size,
        // height: asset.height,
        // width: asset.width,
        // latitude: asset.latitude,
        // longitude: asset.longitude,
        asset: asset);
  }
}
