import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/providers/theme_provider.dart';

import '../theme.dart';

class SelectedList extends StatefulWidget {
  final List<SelectItem> children;
  final ValueChanged<int>? onSelect;

  SelectedList({required this.children, this.onSelect, Key? key})
      : super(key: key);

  @override
  State<SelectedList> createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            );
          },
          itemCount: widget.children.length,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return SelectItem(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onSelect?.call(selectedIndex);
              },
              title: widget.children[index].title,
              isSelected: (selectedIndex == index),
            );
          },
        ),
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  final String title;
  bool isSelected;
  Function? onTap;
  SelectItem(
      {required this.title, this.isSelected = false, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // borderRadius: BorderRadius.circular(15),
    return ListTile(
      onTap: () {
        onTap?.call();
      },
      title: Text(
        title,
        style: MyThemes.textTheme.bodyText1,
      ),
      trailing: (isSelected)
          ? const Icon(
              Icons.check,
              color: orangeColor,
            )
          : null,
    );
  }
}
