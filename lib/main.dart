import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:e_learning/core/utils/state_management_observability.dart';
import 'package:e_learning/app/app.dart';
import 'package:e_learning/core/notifications/notification_handler.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
// Uncomment the following line if you have a custom Firebase options file
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  // Initialize notification services
  await notificationHandler.initialize();

  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Initialize BLoC observer
  Bloc.observer = AppBlocObserver();
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    const App(),
  );
}
