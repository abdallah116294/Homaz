import 'package:flutter/material.dart';
import 'package:homez/core/localization/app_localization.dart';

extension ContextEx on BuildContext {
  Future<dynamic> pushName(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }
  void pop() => Navigator.of(this).pop();
  String translate(String langkey) {
    return AppLocalizations.of(this)!.translate(langkey).toString();
  }
}
