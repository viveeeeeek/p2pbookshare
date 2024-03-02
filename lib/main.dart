import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:p2pbookshare/app.dart';
import 'package:p2pbookshare/firebase_options.dart';
import 'package:p2pbookshare/services/providers/providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enables offline persistence of Firebase data.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await FlutterConfig.loadEnvVariables();
  runApp(MultiProvider(providers: appProviders, child: const App()));
}
