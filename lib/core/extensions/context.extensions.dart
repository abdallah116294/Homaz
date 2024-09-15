import 'package:flutter/material.dart';
import 'package:homez/core/localization/app_localization.dart';

extension ContextEx on BuildContext{
 String translate(String langkey) {
    return AppLocalizations.of(this)!.translate(langkey).toString();
  }
}