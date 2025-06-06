import 'package:flutter/material.dart';
import 'package:funtury/MainPage/home_page.dart';

class HomePageController {
  HomePageController({
    required this.context,
    required this.setState,
  });

  late BuildContext context;
  late void Function(VoidCallback) setState;

  int currentScreenIndex = 0;
  final List<bool> hasVisited = [false, false, false, false];

  Future init() async {}

  void switchScreen(MainScreen screen) {
    setState(() {
      currentScreenIndex = screen.pageIndex;
      hasVisited[screen.pageIndex] = true;
    });
  }
}
