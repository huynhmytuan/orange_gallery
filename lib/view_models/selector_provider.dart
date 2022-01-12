import 'package:flutter/material.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';

class SelectorProvider extends ChangeNotifier {
  bool _isSelectMode = false;
  List<MediaViewModel> _selections = [];

  ///Check selection Mode is on/off
  ///
  ///Mode On return [true]
  ///Mode Off return [false]
  bool get isSelectMode {
    return _isSelectMode;
  }

  ///Return all assets in selections
  List<MediaViewModel> get selections {
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

  void toggleSelectModeOn() {
    _isSelectMode = true;
    notifyListeners();
  }

  ///Add new asset to selections and also check and toggle SelectMode on.
  void addSelection(MediaViewModel asset) {
    if (!_isSelectMode) {
      _toggleSelectMode();
    }
    if (isInSelections([asset])) {
      removeSelections([asset]);
    } else {
      _selections.add(asset);
    }
    notifyListeners();
  }

  void addAllSelection(List<MediaViewModel> assets) {
    if (!_isSelectMode) {
      _toggleSelectMode();
    }
    if (isInSelections(assets)) {
      removeSelections(assets);
    } else {
      assets.where((asset) => isInSelections([asset])).forEach((item) {
        _selections.remove(item);
      });
      _selections.addAll(assets);
    }
    notifyListeners();
  }

  bool isInSelections(List<MediaViewModel> assets) {
    if (assets.every(
      (asset) => _selections.map((e) => e.id).toList().contains(asset.id),
    )) {
      return true;
    }
    return false;
  }

  ///Remove asset from list selections
  ///and toggle SelectMode off if none of selections left.
  void removeSelections(List<MediaViewModel> assets) {
    for (MediaViewModel asset in assets) {
      _selections.remove(asset);
    }
    if (_selections.isEmpty) {
      _toggleSelectMode();
    }
    notifyListeners();
  }

  ///Clear all selections and turn of SelectMode
  void clearSelection() {
    if (_selections.isNotEmpty) {
      _selections.clear();
      _toggleSelectMode();
    } else if (_isSelectMode) {
      _toggleSelectMode();
    }
  }
}
