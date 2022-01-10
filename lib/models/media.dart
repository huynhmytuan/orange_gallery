import 'package:photo_manager/photo_manager.dart';

class Media {
  final String id;
  final AssetEntity asset;

  Media({
    required this.id,
    required this.asset,
  });

  factory Media.fromAsset(AssetEntity asset) {
    return Media(id: asset.id, asset: asset);
  }
}
