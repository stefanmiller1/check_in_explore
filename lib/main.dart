import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:check_in_facade/auth/notification_facade/notification_core_config.dart';

import 'presentation/router/location_builder.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await LocalNotificationCore.setupFlutterNotifications(isFlutterLocalNotificationsInitialized);
  LocalNotificationCore.showFlutterNotificationMobile(message);
}


bool isFlutterLocalNotificationsInitialized = false;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  setupFacade();
  setupApp();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  if (!kIsWeb) {
    Stripe.publishableKey = STRIPE_PUBLISH_KEY;
    Stripe.merchantIdentifier = STRIPE_MERCHANT_ID;
    await Stripe.instance.applySettings();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  await LocalNotificationCore.setupFlutterNotifications(isFlutterLocalNotificationsInitialized);

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

  final routerDelegate = BeamerDelegate(
      transitionDelegate: const NoAnimationTransitionDelegate(),
      locationBuilder: simpleLocationBuilder
  );
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

  @override
  void initState() {
    LocalNotificationCore.initialize(context);

    /// background work called when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {

      }
    );


    /// background work called when app is not open
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // print('Handling a foreground message: ${message.messageId}');
      // print('Message data: ${message.data}');
      // print('Message notification: ${message.notification?.title}');
      // print('Message notification: ${message.notification?.body}');
    });


    super.initState();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}
