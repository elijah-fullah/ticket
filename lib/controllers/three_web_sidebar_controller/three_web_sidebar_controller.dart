import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../screens/three_web_screens/three_web_dashboard/three_web_dashboard.dart';
import '../../screens/three_web_screens/three_web_logs/three_web_logs.dart';
import '../../screens/three_web_screens/three_web_settings/three_web_setting.dart';
import '../../screens/three_web_screens/three_web_tickets/three_web_tickets.dart';
import '../../screens/three_web_screens/three_web_users/three_web_users.dart';

final GoRouter routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThreeWebDashboard();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'three-web-dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const ThreeWebDashboard();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThreeWebUsers();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'three-web-users',
          builder: (BuildContext context, GoRouterState state) {
            return const ThreeWebUsers();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThreeWebTickets();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'three-web-tickets',
          builder: (BuildContext context, GoRouterState state) {
            return const ThreeWebTickets();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThreeWebLogs();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'three-web-logs',
          builder: (BuildContext context, GoRouterState state) {
            return const ThreeWebLogs();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThreeWebSetting();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'three-web-settings',
          builder: (BuildContext context, GoRouterState state) {
            return const ThreeWebSetting();
          },
        ),
      ],
    ),
  ],
);

class ThreeWebSidebarController extends GetxController{
  RxInt index = 0.obs;
  var isExpanded = true.obs;

  var pages = [
    const ThreeWebDashboard(),
    const ThreeWebUsers(),
    const ThreeWebTickets(),
    const ThreeWebLogs(),
    const ThreeWebSetting(),
  ];
}