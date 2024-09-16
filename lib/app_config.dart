import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String appTitle;
  final String apiBaseUrl;
  final Widget child;

  const AppConfig({
    required this.appTitle,
    required this.apiBaseUrl,
    required this.child,
  }) : super(child: child);

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
