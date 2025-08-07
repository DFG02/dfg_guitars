import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'bloc/guitar_bloc.dart';
import 'views/guitar_list_view.dart';
import 'views/add_guitar_view.dart';
import 'views/edit_guitar_view.dart';
import 'views/guitar_details_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GuitarBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => GuitarListView(),
          '/add': (context) => AddGuitarView(),
          '/edit': (context) => EditGuitarView(),
          '/details': (context) => GuitarDetailsView(),
        },
      ),
    );
  }
}
