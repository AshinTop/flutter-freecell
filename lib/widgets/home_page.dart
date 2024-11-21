import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/widgets/game/card_column.dart';
import 'package:freecell/widgets/game/end.dart';
import 'package:freecell/widgets/menu/floating_home.dart';
import 'package:freecell/utils/prefs.dart';
import 'package:freecell/widgets/game/done.dart';
import 'package:freecell/widgets/game/saved.dart';
import 'package:freecell/widgets/theme/theme_select.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    ctx = context;
    if (!hasSavedGame()) {
      shuffleCards();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appConfigs['firstBoot']) {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ThemeSelect(),
        );
      }
      try {
        for (var i = 0; i < allMoves[moves.value].length; i++) {
          currentCards[i].value = allMoves[moves.value][i].value.toList();
        }
        backup();
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).orientation == Orientation.portrait;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    Logger().d({p, w, h});

    return WillPopScope(
      onWillPop: () async {
        final isExitWarning = DateTime.now().difference(timeBackPressed) >
            const Duration(seconds: 3);
        timeBackPressed = DateTime.now();
        return !isExitWarning;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: shuffling,
        builder: (context, data, widget) {
          return Scaffold(
            body: AbsorbPointer(
              absorbing: data,
              child: Stack(
                children: [
                  SafeArea(
                    child: Container(
                      height: p ? 80 : 0,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: moves,
                                  builder: (context, data, widget) {
                                    return Column(
                                      children: [
                                        Text('Moves',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: getDarkTextColor())),
                                        Text(
                                          '$data',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: getDarkTextColor()),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                ValueListenableBuilder<bool>(
                                  valueListenable: theme,
                                  builder: (context, value, child) {
                                    if (appConfigs['timer']) {
                                      return StreamBuilder(
                                        stream: Stream.periodic(
                                          const Duration(seconds: 1),
                                        ),
                                        builder: (context, snapshot) {
                                          var time =
                                              DateFormat('HH:mm:ss').format(
                                            DateTime.now().subtract(
                                              Duration(
                                                  minutes: gameTimes.minute,
                                                  seconds: gameTimes.second,
                                                  hours: gameTimes.hour),
                                            ),
                                          );
                                          return Center(
                                            child: Column(
                                              children: [
                                                Text('Time',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            getDarkTextColor())),
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          getDarkTextColor()),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.black,
                      width: !p ? 80 : 0,
                      height: double.infinity,
                      child: Row(
                        children: [
                          const RotatedBox(
                              quarterTurns: 1, child: FloatingHome()),
                          Container(width: 20),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black,
                      height: p ? 80 : 0,
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FloatingHome()
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: AnimatedPadding(
                      curve: Curves.easeOutQuad,
                      duration: const Duration(milliseconds: 128),
                      padding: EdgeInsets.only(
                          top: toolbar && p ? 60 : 0,
                          bottom: toolbar && p ? 60 : 0,
                          left: !p ? 60 : 0),
                      child: Card(
                        shadowColor: Colors.transparent,
                        color: Theme.of(context).colorScheme.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.zero,
                        child: Stack(
                          children: [
                            p
                                ? ListView(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Row(
                                        children: [
                                          Saved(index: 0),
                                          Saved(index: 1),
                                          Saved(index: 2),
                                          Saved(index: 3),
                                          Done(index: 0),
                                          Done(index: 1),
                                          Done(index: 2),
                                          Done(index: 3),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Stack(
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable: endScreen,
                                            builder: (context, value, child) =>
                                                isGameEnd()
                                                    ? const EndScreen()
                                                    : Container(),
                                          ),
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CardColumn(listIndex: 0),
                                              CardColumn(listIndex: 1),
                                              CardColumn(listIndex: 2),
                                              CardColumn(listIndex: 3),
                                              CardColumn(listIndex: 4),
                                              CardColumn(listIndex: 5),
                                              CardColumn(listIndex: 6),
                                              CardColumn(listIndex: 7),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: GestureDetector(
                                          onTap: () {
                                            toolbar = !toolbar;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Column(
                                        children: [
                                          Row(
                                            children: [
                                              Saved(index: 0),
                                              Saved(index: 1),
                                              Saved(index: 2),
                                              Saved(index: 3),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(children: [
                                            Done(index: 0),
                                            Done(index: 1),
                                            Done(index: 2),
                                            Done(index: 3),
                                          ])
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      isGameEnd()
                                          ? const EndScreen()
                                          : SizedBox(
                                              height: h,
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CardColumn(listIndex: 0),
                                                  CardColumn(listIndex: 1),
                                                  CardColumn(listIndex: 2),
                                                  CardColumn(listIndex: 3),
                                                  CardColumn(listIndex: 4),
                                                  CardColumn(listIndex: 5),
                                                  CardColumn(listIndex: 6),
                                                  CardColumn(listIndex: 7),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
