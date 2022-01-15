import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:orange_gallery/screens/album/albums_overview_screen.dart';
import 'package:orange_gallery/screens/album/albums_view_all_screen.dart';
import 'package:orange_gallery/screens/photo/photos_screen.dart';
import 'package:orange_gallery/utils/navigator_service.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/screens/home_screen.dart';
import 'package:orange_gallery/screens/common/missing_permission_screen.dart';

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/view_models/theme_provider.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('Settings');
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VI'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi', 'VI'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late bool _status = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    PhotoManager.requestPermissionExtend().then((value) {
      setState(() {
        _status = value.isAuth;
      });
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PhotoManager.requestPermissionExtend().then((value) {
      setState(() {
        _status = value.isAuth;
      });
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MediasViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AlbumsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectorProvider(),
        ),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Orange Gallery',
          themeMode: themeProvider.getThemeMode['value'],
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          scrollBehavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home:
              (_status) ? const MyHomePage() : const MissingPermissionScreen(),
          routes: {
            MyHomePage.routeName: (context) => const MyHomePage(),
            PhotosScreen.routeName: (context) => const PhotosScreen(),
            AlbumsScreen.routeName: (context) => const AlbumsScreen(),
            AlbumsViewAllScreen.routeName: (context) => AlbumsViewAllScreen(),
          },
        );
      },
    );
  }
}
