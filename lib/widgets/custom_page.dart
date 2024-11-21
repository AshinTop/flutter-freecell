import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/utils/prefs.dart';
import 'package:freecell/widgets/theme/theme_select.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/data.dart';
import 'package:freecell/widgets/game/item_card.dart';
import 'package:freecell/widgets/info_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  PageCustomState createState() => PageCustomState();
}

class PageCustomState extends State<CustomPage> {
  bool showIcons = false;
  bool showThemes = false;
  final List<IconData> iconsTheme = [
    Icons.ac_unit_rounded,
    Icons.nature_outlined,
    Icons.nature_outlined,
    Icons.wb_sunny_outlined,
    Icons.spa_outlined,
    Icons.filter_drama_rounded,
    Icons.spa_outlined,
    Icons.landscape_rounded,
    Icons.light,
    Icons.star_purple500_rounded,
    Icons.anchor_rounded,
    Icons.nights_stay_outlined
  ];
  final List<IconData> tileIcons = [
    Icons.headphones_rounded,
    Icons.vibration_rounded,
    Icons.timer_rounded,
    Icons.animation_rounded,
    Icons.crop_portrait_rounded,
    Icons.format_italic_rounded
  ];
  final List<IconData> tileIcons2 = [
    Icons.support_agent,
    Icons.numbers_rounded,
  ];

  void openSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width - 20,
      content: Text(text),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> openEmailApp() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: supportEmail,
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      openSnackBar(context, 'Could not send email to $supportEmail');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<VoidCallback> tileFunctions = [
      () => setState(
          () => setConfigsAndSavePrefs('soundPref', !appConfigs['soundPref'])),
      () => setState(
          () => setConfigsAndSavePrefs('haptic', !appConfigs['haptic'])),
      () =>
          setState(() => setConfigsAndSavePrefs('timer', !appConfigs['timer'])),
    ];
    final List<VoidCallback> tileFunctions2 = [
      () => {openEmailApp()},
      () => {},
    ];
    final List<Widget> tileTitle = [
      const Text('Sound'),
      const Text('Haptic'),
      const Text('Timer'),
    ];
    List<String> options = ['soundPref', 'haptic', 'timer'];
    List<Widget?> tileTrailing = [
      for (var option in options)
        Switch(
          activeColor: Theme.of(context).primaryColor,
          inactiveThumbColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Colors.grey,
          value: appConfigs[option],
          onChanged: (value2) =>
              setState(() => setConfigsAndSavePrefs(option, value2)),
        ),
    ];
    List<Widget?> tileTrailing2 = [
      const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      const Text(appVersion),
    ];

    final List<Widget> tileTitle2 = [
      const Text('Support'),
      const Text('Version'),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                  // child: Text(
                  //   '${appConfigs['coins']}c',
                  //   style: const TextStyle(fontSize: 20),
                  // ),
                  // onTap: () => setState(() => setConfigsAndSavePrefs('coins', appConfigs['coins'] + 50)),
                  child: const Icon(Icons.palette),
                  onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => const ThemeSelect(),
                      )),
            ),
          )
        ],
        title: const Text('Customise'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            height: 64,
            width: double.infinity,
          ),
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            color: Theme.of(context).colorScheme.background,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(),
                ),
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(.4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  for (int i = 0; i < 4; i++)
                                    ItemCard(
                                      card: GameCard(
                                        num: 1,
                                        sign: i,
                                        key: GlobalKey(),
                                        highlight: true,
                                      ),
                                      pg: false,
                                      pd: false,
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Least Move'),
                                  Text(
                                      appConfigs['minMoves'] > 0
                                          ? appConfigs['minMoves'].toString()
                                          : '',
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Best time'),
                                  Text(
                                      appConfigs['minTimes'] > 0
                                          ? appConfigs['minTimes'].toString()
                                          : '',
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Game Wins'),
                                  Text(appConfigs['wins'].toString(),
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tileTitle.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: tileTitle[i],
                          onTap: tileFunctions[i],
                          trailing: tileTrailing[i],
                          leading: Icon(tileIcons[i]),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(.4),
                      child: const SizedBox(
                        height: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tileTitle2.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: tileTitle2[i],
                          onTap: tileFunctions2[i],
                          trailing: tileTrailing2[i],
                          leading: Icon(tileIcons2[i]),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => InfoPage()));
          },
          tooltip: 'How to play',
          child: const Icon(Icons.book_outlined),
        ),
      ),
    );
  }
}
