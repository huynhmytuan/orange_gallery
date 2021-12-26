import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';

import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/screens/album/albums_screen.dart';

import 'package:orange_gallery/screens/photo/photos_screen.dart';
import 'package:orange_gallery/screens/setting/setting_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final screens = {
    {
      'title': 'photos.label',
      'icon': CupertinoIcons.photo_on_rectangle,
      'screen': PhotosScreen(),
    },
    {
      'title': 'albums.label',
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
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    Hive.close();
    _pageController.dispose();
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            );
          },
          child: screens
              .elementAt(_selectedIndex)
              .values
              .whereType<Widget>()
              .first,
        ),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: GNav(
              gap: 1,
              iconSize: 20,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              activeColor: Theme.of(context).primaryColor,
              tabBackgroundColor: Theme.of(context).hoverColor,
              color: greyColor60,
              tabs: screens
                  .map(
                    (e) => GButton(
                      icon: e.values.whereType<IconData>().first,
                      text: tr(e['title'].toString()),
                      gap: 10,
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
