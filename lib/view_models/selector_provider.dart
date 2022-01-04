import 'package:flutter/material.dart';
import 'package:orange_gallery/view_models/media_asset_view_model.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectorProvider extends ChangeNotifier {
  bool _isSelectMode = false;
  List<MediaAssetViewModel> _selections = [];

  ///Check selection Mode is on/off
  ///
  ///Mode On return [true]
  ///Mode Off return [false]
  bool get isSelectMode {
    return _isSelectMode;
  }

  ///Return all assets in selections
  List<MediaAssetViewModel> get selections {
    return _selections;
  }

  ///Return number of assets in selections
  int get amount {
    return _selections.length;
  }

  void _toggleSelectMode() {
    _isSelectMode = !_isSelectMode;
    notifyListeners();
  }

  void toggleSelectModeO() {
    _isSelectMode = !_isSelectMode;
    notifyListeners();
  }

  ///Add new asset to selections and also check and toggle SelectMode on.
  void addSelection(MediaAssetViewModel asset) {
    if (!_isSelectMode) {
      _toggleSelectMode();
    }
    if (_selections.contains(asset)) {
      removeSelections([asset]);
    } else {
      _selections.add(asset);
    }
    notifyListeners();
  }

  void addAllSelection(List<MediaAssetViewModel> assets) {
    if (!_isSelectMode) {
      _toggleSelectMode();
    }
    if (assets.every((element) => _selections.contains(element))) {
      removeSelections(assets);
    } else {
      assets.where((asset) => _selections.contains(asset)).forEach((item) {
        _selections.remove(item);
      });
      _selections.addAll(assets);
    }
    notifyListeners();
  }

  bool isInSelections(List<MediaAssetViewModel> assets) {
    if (assets.every((asset) => _selections.contains(asset))) {
      return true;
    }
    return false;
  }

  ///Remove asset from list selections
  ///and toggle SelectMode off if none of selections left.
  void removeSelections(List<MediaAssetViewModel> assets) {
    for (MediaAssetViewModel asset in assets) {
      _selections.remove(asset);
    }
    if (_selections.isEmpty) {
      _toggleSelectMode();
    }
    notifyListeners();
  }

  ///Clear all selections and turn of SelectMode
  void clearSelection() {
    _selections.clear();
    _toggleSelectMode();
  }
}
