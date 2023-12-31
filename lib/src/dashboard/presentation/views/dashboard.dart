import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:memoircanvas/core/common/app/providers/user_provider.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/src/auth/data/models/user_model.dart';
import 'package:memoircanvas/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:memoircanvas/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data is LocalUserModel) {
          context.read<UserProvider>().user = snapshot.data;
        }
        return Consumer<DashBoardController>(
          builder: (_, controller, __) {
            return Scaffold(
              backgroundColor: context.theme.colorScheme.background,
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                backgroundColor: context.theme.colorScheme.background,
                elevation: 8,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 0
                          ? IconlyBold.home
                          : IconlyLight.home,
                      color: controller.currentIndex == 0
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Home',
                    backgroundColor: context.theme.colorScheme.primary,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 1
                          ? IconlyBold.calendar
                          : IconlyLight.calendar,
                      color: controller.currentIndex == 1
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Reminiscence',
                    backgroundColor: context.theme.colorScheme.primary,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 2
                          ? IconlyBold.setting
                          : IconlyLight.setting,
                      color: controller.currentIndex == 2
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Settings',
                    backgroundColor: context.theme.colorScheme.primary,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
