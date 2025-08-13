import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'views/guitar_list_view.dart';
import 'views/add_guitar_view.dart';
import 'views/edit_guitar_view.dart';
import 'views/guitar_details_view.dart';
import 'views/welcome_view.dart';
import 'utils/initialize_catalogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inicializar catálogos si faltan (no bloquea la UI principal)
  _ensureCatalogs();
  runApp(const MainApp());
}

Future<void> _ensureCatalogs() async {
  try {
    final firestore = FirebaseFirestore.instance;
    final needed = ['madera_cuerpo','madera_brazo','tipo_puente'];
    bool missing = false;
    for (final id in needed) {
      final doc = await firestore.collection('catalogos').doc(id).get();
      if (!doc.exists) { missing = true; break; }
    }
    if (missing) {
      await initializeCatalogs();
    }
  } catch (_) {
    // silencioso
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DFG Guitar Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 37, 32, 47),
          labelStyle: TextStyle(color: const Color.fromARGB(255, 224, 215, 240)),
          hintStyle: TextStyle(color: Colors.deepPurple.shade700),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 30, 27, 37),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeView(),
        '/': (context) => GuitarListView(),
        '/add': (context) => AddGuitarView(),
        '/edit': (context) => EditGuitarView(),
        '/details': (context) => GuitarDetailsView(),
      },
      builder: (context, child) {
        return ScaffoldMessenger(
          child: child!,
        );
      },
    );
  }
}