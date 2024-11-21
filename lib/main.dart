import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/widgets/home_page.dart';
import 'package:freecell/widgets/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: theme,
      builder: (context, themeMode, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Freecell',
          theme: themeData(
            tc: appThemes[appConfigs['theme']]!.textColor,
            bc: appThemes[appConfigs['theme']]!.bgColor,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
