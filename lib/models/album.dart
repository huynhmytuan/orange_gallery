import 'package:photo_manager/photo_manager.dart';

class Album {
  String id;
  String albumName;
  int itemCount;
  bool isAll;
  DateTime? lastModifiedTime;
  AssetPathEntity fullData;
  Album({
    required this.id,
    required this.albumName,
    required this.itemCount,
    required this.isAll,
    required this.lastModifiedTime,
    required this.fullData,
  });
  factory Album.fromAssetPath(AssetPathEntity albumAssetPath) {
    return Album(
      id: albumAssetPath.id,
      albumName: albumAssetPath.name,
      itemCount: albumAssetPath.assetCount,
      isAll: albumAssetPath.isAll,
      lastModifiedTime: albumAssetPath.lastModified,
      fullData: albumAssetPath,
    );
  }
}
