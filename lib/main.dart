import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'presentation/main_screens/main_screen.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(prodEnv);
  configureInjectionFacade(prodEnvFacade);
  configureInjectionApp(prodEnvFacade);
  Stripe.publishableKey = STRIPE_PUBLISH_KEY;
  Stripe.merchantIdentifier = STRIPE_MERCHANT_ID;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp

  ({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void clearLocale() {
    setState(() {
      _locale = null;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      home: const MainScreen(),
    );
  }
}
