import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../screens/super_web_screens/super_web_dashboard/super_web_dashboard.dart';
import '../../screens/super_web_screens/super_web_logs/super_web_logs.dart';
import '../../screens/super_web_screens/super_web_reports/super_web_reports.dart';
import '../../screens/super_web_screens/super_web_settings/super_web_setting.dart';
import '../../screens/super_web_screens/super_web_tickets/super_web_tickets.dart';
import '../../screens/super_web_screens/super_web_users/super_web_users.dart';

final GoRouter routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebDashboard();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebDashboard();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebUsers();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-users',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebUsers();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebTickets();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-tickets',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebTickets();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebReports();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-reports',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebReports();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebLogs();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-logs',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebLogs();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SuperWebSetting();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'super-web-settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SuperWebSetting();
          },
        ),
      ],
    ),
  ],
);

class SuperWebSidebarController extends GetxController{
  RxInt index = 0.obs;
  var isExpanded = true.obs;

  var pages = [
    const SuperWebDashboard(),
    const SuperWebUsers(),
    const SuperWebTickets(),
    const SuperWebReports(),
    const SuperWebLogs(),
    const SuperWebSetting(),
  ];
}