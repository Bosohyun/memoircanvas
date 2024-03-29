part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder((context) {
        if (prefs.getBool(kFirstTimerKey) ?? true) {
          return BlocProvider(
            create: (_) => sl<OnBoardingCubit>(),
            child: const OnBoardingScreen(),
          );
        } else if (sl<FirebaseAuth>().currentUser != null &&
            sl<FirebaseAuth>().currentUser!.emailVerified) {
          final user = sl<FirebaseAuth>().currentUser!;

          final localUser = LocalUserModel(
            uid: user.uid,
            email: user.email ?? '',
            username: user.displayName ?? '',
          );

          context.userProvider.initUser(localUser);
          return const Dashboard();
        }
        return BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        );
      }, settings: settings);

    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );

    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );

    case Dashboard.routeName:
      return _pageBuilder(
        (_) => const Dashboard(),
        settings: settings,
      );
    case '/forgot-password':
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        settings: settings,
      );

    case JournalDetailsScreen.routeName:
      return _pageBuilder(
        (_) => JournalDetailsScreen(settings.arguments! as Journal),
        settings: settings,
      );

    case Premium.routeName:
      return _pageBuilder(
        (_) => const Premium(),
        settings: settings,
      );

    default:
      return _pageBuilder((_) => const PageUnderConstruction(),
          settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
