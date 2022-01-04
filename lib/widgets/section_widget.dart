import 'package:flutter/material.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/theme.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final SectionButton? leading;
  final Widget child;

  const SectionWidget({
    required this.title,
    required this.child,
    this.leading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    title,
                    style: MyThemes.textTheme.bodyText1!
                        .copyWith(color: greyColor60),
                  ),
                ),
                (leading != null) ? leading! : const SizedBox(),
              ],
            ),
          ),
          child
        ],
      ),
    );
  }
}

class SectionButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  const SectionButton({required this.label, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed.call();
      },
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
