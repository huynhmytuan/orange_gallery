import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/utils/constants.dart';

class CustomTextInputDialog extends StatefulWidget {
  CustomTextInputDialog({Key? key}) : super(key: key);

  @override
  State<CustomTextInputDialog> createState() => _CustomTextInputDialogState();
}

class _CustomTextInputDialogState extends State<CustomTextInputDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  bool _isValid = false;

  void _validateInput() {
    setState(() {
      (_textFieldController.text.isNotEmpty)
          ? _isValid = true
          : _isValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _textFieldController.addListener(_validateInput);
    if (Platform.isAndroid) {
      return _buidMaterialDialog();
    } else {
      return _buildCupertinoDialog();
    }
  }

  Widget _buildCupertinoDialog() {
    return CupertinoAlertDialog(
        title: Text(
          tr('notice.create_album_dialog.title'),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoTextField(
            controller: _textFieldController,
            placeholder: tr('notice.create_album_dialog.text_hint'),
            clearButtonMode: OverlayVisibilityMode.editing,
            placeholderStyle: TextStyle(
              color: (Theme.of(context).brightness == Brightness.light)
                  ? greyColor80
                  : greyColor40,
            ),
            style: TextStyle(
              color: (Theme.of(context).brightness == Brightness.light)
                  ? blackColor
                  : Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              tr('buttons.cancel'),
              style: TextStyle(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? greyColor80
                    : greyColor40,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: Text(
              tr("buttons.create"),
              style: const TextStyle(
                  color: orangeColor, fontWeight: FontWeight.bold),
            ),
            onPressed: (_isValid)
                ? () {
                    _validateInput();
                    if (_isValid) {
                      Navigator.of(context).pop(_textFieldController.text);
                    }
                  }
                : null,
          ),
        ]);
  }

  Widget _buidMaterialDialog() {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Text(
        tr('notice.create_album_dialog.title'),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(
          hintText: tr('notice.create_album_dialog.text_hint'),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  tr('buttons.cancel'),
                  style: TextStyle(
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? greyColor80
                        : greyColor40,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    tr("buttons.create"),
                  ),
                ),
                onPressed: (_isValid)
                    ? () {
                        _validateInput();
                        if (_isValid) {
                          Navigator.of(context).pop(_textFieldController.text);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
