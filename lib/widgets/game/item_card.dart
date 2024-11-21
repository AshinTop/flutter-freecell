import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/data.dart';
import 'package:freecell/model/card.dart';

class ItemCard extends StatelessWidget {
  final GameCard card;
  final bool pd, pg;
  const ItemCard(
      {super.key, required this.card, required this.pg, required this.pd});

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).orientation == Orientation.portrait;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      color: card.hint
          ? Theme.of(context).colorScheme.primary
          : Colors.transparent,
      duration: Duration(
        milliseconds: card.hint
            ? 500
            : shuffling.value
                ? 0
                : 64,
      ),
      key: card.key,
      width: p ? w / 8 : h / 8,
      height: p
          ? (card.highlight ? w / 5 : w / 13)
          : card.highlight
              ? h / 5.5
              : h / 15,
      child: Container(
        margin: EdgeInsets.only(
          left: p ? w / 200 : h / 240,
          right: p ? w / 200 : h / 240,
          top: (pg) ? 0 : 2,
          bottom: (pd) ? 0 : 2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1, //p ? w / 140 : h / 140,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: (pd) ? Radius.zero : const Radius.circular(6),
            bottomRight: (pd) ? Radius.zero : const Radius.circular(6),
            topLeft: (pg) ? Radius.zero : const Radius.circular(6),
            topRight: (pg) ? Radius.zero : const Radius.circular(6),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: p ? w / 28 : h / 33,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFont,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                  child: Text(
                    {11: 'J', 12: 'Q', 13: 'K', 1: 'A'}[card.num] ??
                        '${card.num}',
                    style: TextStyle(
                      color:
                          card.sign < 2 ? Colors.red : Colors.blueGrey.shade800,
                    ),
                  ),
                ),
                Icon(
                  cardIcons[card.sign],
                  size: p ? w / 28 : h / 28,
                  color: card.sign < 2 ? Colors.red : Colors.blueGrey.shade800,
                )
              ],
            ),
            card.highlight
                ? Expanded(
                    child: Icon(
                      cardIcons[card.sign],
                      color:
                          card.sign < 2 ? Colors.red : Colors.blueGrey.shade800,
                      //size: p ? w / 16 : h / 16,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
