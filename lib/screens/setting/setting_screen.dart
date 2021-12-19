// ignore_for_file: prefer_const_constructors
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/constants.dart';

import 'package:orange_gallery/providers/theme_provider.dart';
import 'package:orange_gallery/screens/setting/theme_setting_screen.dart';
import 'package:orange_gallery/theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  Widget _buildSettingTitle({
    required BuildContext context,
    required IconData icon,
    required String title,
    String value = '',
    Function? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          onTap?.call();
        },
        child: Card(
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: greyColor60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      title,
                      style: MyThemes.textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(color: greyColor60),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: orangeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 75, left: 10),
            child: Text(
              'Settings',
              style: MyThemes.textTheme.headline5,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 10),
            child: Text(
              'PREFERENCES',
              style: TextStyle(
                color: greyColor60,
                fontSize: 12,
              ),
            ),
          ),
          _buildSettingTitle(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ThemeSettingScreen(),
              ));
            },
            context: context,
            icon: (themeProvider.getThemeMode == ThemeMode.dark)
                ? CupertinoIcons.moon_stars
                : Icons.light_mode,
            title: 'Theme',
            value: ThemeProvider.themeModes
                .firstWhere(
                    (mode) => mode.values.first == themeProvider.getThemeMode)
                .keys
                .first,
          ),
          _buildSettingTitle(
            context: context,
            icon: Icons.language,
            title: 'Language',
            value: 'English',
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 10),
            child: Text(
              'INFO',
              style: TextStyle(
                color: greyColor60,
                fontSize: 12,
              ),
            ),
          ),
          _buildSettingTitle(
            context: context,
            icon: Icons.info_outline_rounded,
            title: 'About us',
          ),
        ],
      ),
    );
  }
}
