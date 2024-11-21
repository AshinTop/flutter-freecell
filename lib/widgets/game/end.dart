import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/utils/prefs.dart';
import 'package:freecell/utils/sound.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: playEndSound(),
      builder: (context, snap) {
        List<String> l = [
          '${appConfigs['currentMoves']} moves',
          '${appConfigs['currentTimes']} seconds',
          '${appConfigs['wins']} wins',
        ];
        return Center(
          child: SizedBox(
            width: double.infinity,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              children: [
                for (var str in l)
                  Card(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          str,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                Card(
                  shadowColor: Theme.of(context).colorScheme.background,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      savePrefs('moves', -1);
                      setState(() {});
                      shuffleCards();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      height: 100,
                      child: Center(
                        child: Text(
                          'New Game',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
