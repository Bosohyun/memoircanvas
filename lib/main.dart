import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/app/providers/user_provider.dart';
import 'package:memoircanvas/core/res/colors.dart';
import 'package:memoircanvas/core/res/fonts.dart';
import 'package:memoircanvas/core/services/injection_container.dart';
import 'package:memoircanvas/core/services/router.dart';

import 'package:memoircanvas/firebase_options.dart';
import 'package:memoircanvas/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
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
        child: MaterialApp(
          title: 'MemoirCanvas',
          theme: ThemeData(
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: Fonts.poppins,
            colorScheme: ColorScheme.fromSwatch(
              accentColor: Colours.primaryColour,
            ),
          ),
          onGenerateRoute: generateRoute,
        ));
  }
}
