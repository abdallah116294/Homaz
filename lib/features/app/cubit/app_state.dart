part of 'app_cubit.dart';

@immutable
abstract class AppState {
  final Locale locale;
  const AppState(this.locale);
}

class SelectedLocale extends AppState {
  SelectedLocale(Locale locale) : super(locale);
}