import 'package:easy_localization/easy_localization.dart';
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
    _textFieldController.text.isEmpty ? _isValid = true : _isValid = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _textFieldController.addListener(_validateInput);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Text(
        'Create New Album',
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(
          hintText: "Album Name",
          errorText: _isValid ? 'Value Can\'t Be Empty' : null,
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
                onPressed: () {
                  _validateInput();
                  Navigator.of(context).pop(_textFieldController.text);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
