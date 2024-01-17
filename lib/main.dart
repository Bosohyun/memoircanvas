import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:memoircanvas/core/common/app/providers/user_provider.dart';
import 'package:memoircanvas/core/common/app/theme/app_theme.dart';

import 'package:memoircanvas/core/services/injection_container.dart';
import 'package:memoircanvas/core/services/router.dart';

import 'package:memoircanvas/firebase_options.dart';
import 'package:memoircanvas/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashBoardController(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<JournalCubit>()),
        ],
        child: MaterialApp(
          title: 'Memoir Canvas',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }
}
