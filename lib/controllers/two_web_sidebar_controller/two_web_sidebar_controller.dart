import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../screens/two_web_screens/two_web_dashboard/two_web_dashboard.dart';
import '../../screens/two_web_screens/two_web_logs/two_web_logs.dart';
import '../../screens/two_web_screens/two_web_reports/two_web_reports.dart';
import '../../screens/two_web_screens/two_web_settings/two_web_setting.dart';

final GoRouter routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TwoWebDashboard();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'two-web-dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const TwoWebDashboard();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TwoWebReports();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'two-web-reports',
          builder: (BuildContext context, GoRouterState state) {
            return const TwoWebReports();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TwoWebLogs();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'two-web-logs',
          builder: (BuildContext context, GoRouterState state) {
            return const TwoWebLogs();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TwoWebSetting();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'two-web-settings',
          builder: (BuildContext context, GoRouterState state) {
            return const TwoWebSetting();
          },
        ),
      ],
    ),
  ],
);

class TwoWebSidebarController extends GetxController{
  RxInt index = 0.obs;
  var isExpanded = true.obs;

  var pages = [
    const TwoWebDashboard(),
    const TwoWebReports(),
    const TwoWebLogs(),
    const TwoWebSetting(),
  ];
}