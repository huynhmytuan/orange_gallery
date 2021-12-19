import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:orange_gallery/providers/theme_provider.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/widgets/select_list.dart';

class ThemeSettingScreen extends StatelessWidget {
  const ThemeSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme',
          style: MyThemes.textTheme.headline6,
        ),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SelectedList(
          selectedIndex: ThemeProvider.themeModes.indexWhere(
              (element) => element.values.first == themeProvider.getThemeMode),
          onSelect: (index) {
            themeProvider
                .toggleTheme(ThemeProvider.themeModes[index].values.first);
          },
          children: ThemeProvider.themeModes
              .map((e) => SelectItem(title: e.keys.first))
              .toList(),
        ),
      ),
    );
  }
}
