import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to play',
        ),
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
                    child: Container()),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text.rich(
                        TextSpan(
                          text: '1. Game Goal: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'The goal of FreeCell is to move all the cards to the foundation piles, in ascending order (from Ace to King) and by suit (hearts, spades, diamonds, clubs). There are 4 foundation piles, one for each suit.',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text.rich(
                        TextSpan(
                          text: '2. Game Layout: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'The game starts with 52 cards placed in 8 columns. Each column may have one or more cards. Some cards are face up, while others are face down. You need to use the four Free Cells to temporarily store cards while organizing the columns.',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text.rich(
                        TextSpan(
                          text: '3. Card Movement: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'You can move cards between columns as long as the card being moved is one rank lower and of the opposite color of the target card. You can also move cards to Free Cells to temporarily store them or move them to the foundation piles in ascending order.',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text.rich(
                        TextSpan(
                          text: '4. Winning the Game: ',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // 加粗 "Winning the Game"
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'You win the game when all the cards are correctly placed in the foundation piles, in ascending order (Ace to King) and sorted by suit.',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal), // 正常字体
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hints:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '• Use Free Cells wisely to temporarily store cards.\n'
                        '• Plan your moves ahead of time, and try to keep as many columns clear as possible.\n'
                        '• Take your time — there is no time limit!',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 30),
                      Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(.4),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text('Support'),
                                SizedBox(height: 5),
                                Text(
                                  'Have a question about us?\n'
                                  'We\'d love to hear from you! 🤗\n'
                                  'Send us a message and we\'ll get back to you as soon as possible:',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                                SizedBox(height: 5),
                                SelectableText(
                                  supportEmail,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
