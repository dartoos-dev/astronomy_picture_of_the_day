import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];
    return MaterialApp.router(
      title: "NASA's Astronomy Picture Of The Day",
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es'),
        Locale('pt', 'BR'),
      ],
      localeResolutionCallback: _localeResolution,
    ); //added by extension
  }

  /// Keeps the original localization if it is supported. Otherwise, it sets
  /// American English ('en_US') as the default language or Brazilian Portuguese
  /// ('pt_BR') when the language code is 'pt'.
  Locale? _localeResolution(Locale? locale, Iterable<Locale> supportedLocales) {
    if (supportedLocales.contains(locale)) {
      return locale;
    }
    if (locale?.languageCode == 'pt') {
      return const Locale('pt', 'BR');
    }
    return const Locale('en', 'US');
  }
}
