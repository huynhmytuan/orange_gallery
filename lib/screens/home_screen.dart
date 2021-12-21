import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';

import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/screens/album/albums_screen.dart';
import 'package:orange_gallery/screens/favorite/favorites_screen.dart';
import 'package:orange_gallery/screens/photo/photos_screen.dart';
import 'package:orange_gallery/screens/setting/setting_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final screens = {
    {
      'title': 'photos.title',
      'icon': Icons.photo_outlined,
      'screen': PhotosScreen(),
    },
    {
      'title': 'favorites.title',
      'icon': Icons.favorite_border_rounded,
      'screen': FavoritesScreen(),
    },
    {
      'title': 'albums.title',
      'icon': CupertinoIcons.square_stack_3d_down_right,
      'screen': AlbumsScreen(),
    },
    {
      'title': 'settings.title',
      'icon': CupertinoIcons.slider_horizontal_3,
      'screen': SettingScreen(),
    },
  };

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarIconBrightness:
                Theme.of(context).primaryColorBrightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
            statusBarBrightness: Theme.of(context).primaryColorBrightness,
          ),
          child: SafeArea(
            child: screens
                .elementAt(_selectedIndex)
                .values
                .whereType<Widget>()
                .first,
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: GNav(
              gap: 10,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              duration: const Duration(milliseconds: 400),
              activeColor: Theme.of(context).primaryColor,
              tabBackgroundColor: Theme.of(context).hoverColor,
              color: greyColor60,
              tabs: screens
                  .map(
                    (e) => GButton(
                      icon: e.values.whereType<IconData>().first,
                      text: tr(e['title'].toString()),
                    ),
                  )
                  .toList(),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
