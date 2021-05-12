import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/Player.dart';
import 'package:pacman/barriers.dart';
import 'package:pacman/ghost.dart';

import 'package:pacman/pixel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;

  int ghost = -1;
  int numberofSquares = numberInRow * 17;
  int player = numberInRow * 15 + 1;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    21,
    32,
    43,
    54,
    65,
    76,
    87,
    98,
    109,
    120,
    131,
    142,
    153,
    164,
    175,
    186,
    185,
    183,
    182,
    184,
    181,
    180,
    179,
    178,
    177,
    176,
    165,
    154,
    143,
    132,
    121,
    110,
    99,
    88,
    77,
    66,
    55,
    44,
    33,
    22,
    11,
    24,
    35,
    46,
    57,
    26,
    28,
    37,
    38,
    39,
    30,
    41,
    52,
    63,
    78,
    79,
    80,
    81,
    70,
    59,
    61,
    72,
    83,
    84,
    85,
    86,
    100,
    101,
    102,
    103,
    114,
    125,
    105,
    106,
    107,
    108,
    116,
    127,
    123,
    134,
    145,
    156,
    147,
    148,
    149,
    160,
    158,
    129,
    140,
    151,
    162
  ];

  List<int> food = [];

  String direction = "right";

  bool mouthClosed = false;

  bool gamestarted = false;

  int score = 0;

  void startgame() {
    getFood();
    Timer.periodic((Duration(milliseconds: 120)), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }
      switch (direction) {
        case "left":
          moveLeft();
          break;
        case "right":
          moveRight();
          break;
        case "up":
          moveUp();
          break;
        case "down":
          moveDown();
          break;
        default:
      }
    });
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void getFood() {
    for (int i = 0; i < numberofSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  String ghostDirection = "left";

  void moveGhost() {
    Duration ghostSpeed = Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) {
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        ghostDirection = "left";
      } else if (!barriers.contains(ghost - numberInRow) &&
          ghostDirection != "down") {
        ghostDirection = "up";
      } else if (!barriers.contains(ghost + numberInRow) &&
          ghostDirection != "up") {
        ghostDirection = "down";
      } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        ghostDirection = "right";
      }

      switch (ghostDirection) {
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    direction = "down";
                  } else if (details.delta.dy < 0) {
                    direction = "up";
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    direction = "right";
                  } else if (details.delta.dx < 0) {
                    direction = "left";
                  }
                },
                child: Container(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: numberofSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberInRow),
                      itemBuilder: (BuildContext context, int index) {
                        if (player == index) {
                          if (!mouthClosed) {
                            return Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                  decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                              )),
                            );
                          } else {
                            if (direction == "right") {
                              return MyPlayer();
                            } else if (direction == "up") {
                              return Transform.rotate(
                                  angle: 3 * pi / 2, child: MyPlayer());
                            } else if (direction == "left") {
                              return Transform.rotate(
                                  angle: pi, child: MyPlayer());
                            } else if (direction == "down") {
                              return Transform.rotate(
                                  angle: pi / 2, child: MyPlayer());
                            }
                          }
                        } else if (ghost == index) {
                                return MyGhost();
                              } else if (barriers.contains(index)) {
                                return MyBarrier(
                                  innerColor: Colors.blue[800],
                                  outerColor: Colors.blue[900],
                                  //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                );
                              } else if (food.contains(index) || !gamestarted) {
                                return MyPixel(
                                  innercolor: Colors.yellow,
                                  outercolor: Colors.black,
                                  //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                );
                              } else {
                                return MyPixel(
                                  innercolor: Colors.black,
                                  outercolor: Colors.black,
                                  //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                );
                              }
                              return null;
                      }),
                ),
              )),
          Expanded(
              child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: " + score.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                GestureDetector(
                  onTap: startgame,
                  child: Text(
                    " P L A Y",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
