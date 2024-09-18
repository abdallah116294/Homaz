import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/dio_manager.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(SelectedLocale(const Locale("en"))) {
    _loadSavedLanguage();
  }
  void toArabic() {
    emit(SelectedLocale(const Locale('ar')));
    _saveLanguagePreference('ar');
  }

  void toEnglish() {
    emit(SelectedLocale(const Locale('en')));
    _saveLanguagePreference('en');
  }

  Future<void> _loadSavedLanguage() async {
    final String? languageCode = CacheHelper.get(key: "selected_language");
    if (languageCode != null) {
      emit(SelectedLocale(Locale(languageCode)));
    }
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    await CacheHelper.put(key: "selected_language", value: languageCode);
  }

  void toggleLanguage() {
    final currentLocale = state is SelectedLocale
        ? (state as SelectedLocale).locale
        : const Locale('en');
    if (currentLocale.languageCode == 'en') {
      emit(SelectedLocale(const Locale('ar')));
      _saveLanguagePreference('ar');
    //  dioManager.updateLanguage("er");
    } else {
      emit(SelectedLocale(const Locale('en')));
      _saveLanguagePreference('en');
     
    }
  }

  Alignment getAlignment() {
    return state.locale.languageCode == 'ar'
        ? Alignment.topRight
        : Alignment.topLeft;
  }
}
