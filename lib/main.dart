import 'package:cssapp/state_handlers/members/member_api.dart';
import 'package:cssapp/state_handlers/theme/theme_handler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './splash.dart';
import 'package:flutter/material.dart';
import 'state_handlers/theme/brightness/dark.dart';
import 'state_handlers/theme/brightness/light.dart';
import 'utils/storage_handler.dart';

late ThemeHandler _themeHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // -------------------- Initializing Storage Handler --------------------
  await StorageHandler().initPreferences();
  _themeHandler = ThemeHandler();

  runApp(const CSSApp());
}

class CSSApp extends StatefulWidget {
  const CSSApp({Key? key}) : super(key: key);

  @override
  State<CSSApp> createState() => _CSSAppState();
}

class _CSSAppState extends State<CSSApp> {
  void themeListener() {
    if (mounted) {
      setState(() {
        StorageHandler().toggleDarkTheme();
      });
    }
  }

  @override
  void initState() {
    _themeHandler.addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
    _themeHandler.removeListener(themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) =>
              ThemeHandler(themeHandler: _themeHandler),
        ),
        ChangeNotifierProvider(create: (BuildContext context) => MemberApi()),
      ],
      child: MaterialApp(
        title: 'CSS App',
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: _themeHandler.themeMode,
        home: const Splash(),
      ),
    );
  }
}
