import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/utils/prefs.dart';

class ThemeSelect extends StatelessWidget {
  const ThemeSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        List<String> keys = appThemes.keys.toList();
        return Wrap(
          children: [
            const ListTile(title: Text('Select a theme')),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: keys.length,
              itemBuilder: (context, i) {
                final theme = appThemes[keys[i]]!;
                return ListTile(
                    title: Text(theme.name),
                    leading: theme.icon,
                    onTap: () {
                      setConfigsAndSavePrefs('theme', keys[i]);
                      setState(() {});
                      Navigator.pop(context);
                    });
              },
            ),
          ],
        );
      },
    );
  }
}
