import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/card.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/widgets/custom_page.dart';

class FloatingHome extends StatelessWidget {
  const FloatingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: moves,
      builder: (context, data, child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: getDarkTextColor())),
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Menu',
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomPage(),
                          ),
                        );
                      },
                    ),
                    end() && data > 0 && !shuffling.value
                        ? const IconButton(
                            tooltip: 'Autosolve',
                            icon: Icon(Icons.auto_awesome),
                            onPressed: autoSolve,
                          )
                        : data > 0 && !shuffling.value
                            ? IconButton(
                                tooltip: 'Hint',
                                icon:
                                    const Icon(Icons.lightbulb_outline_rounded),
                                onPressed: () {
                                  if (!animating) hint(context);
                                },
                              )
                            : Container(),
                    Expanded(child: Container()),
                    data > 0 && !shuffling.value
                        ? const InkWell(
                            onLongPress: doRestart,
                            child: IconButton(
                              icon: Icon(Icons.undo_rounded),
                              onPressed: doUndo,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: AnimatedAlign(
                    curve: Curves.easeOutQuad,
                    duration: const Duration(milliseconds: 128),
                    alignment:
                        data > 0 ? Alignment.centerRight : Alignment.center,
                    child: const IconButton(
                      tooltip: 'New',
                      icon: Icon(Icons.add),
                      onPressed: shuffleCards,
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
