import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../screens/one_web_screens/one_web_dashboard/one_web_dashboard.dart';
import '../../screens/one_web_screens/one_web_settings/one_web_setting.dart';
import '../../screens/one_web_screens/one_web_tickets/one_web_tickets.dart';
final GoRouter routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OneWebDashboard();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'one-web-dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const OneWebDashboard();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OneWebTickets();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'one-web-tickets',
          builder: (BuildContext context, GoRouterState state) {
            return const OneWebTickets();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OneWebSetting();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'one-web-settings',
          builder: (BuildContext context, GoRouterState state) {
            return const OneWebSetting();
          },
        ),
      ],
    ),
  ],
);

class OneWebSidebarController extends GetxController{
  RxInt index = 0.obs;
  var isExpanded = true.obs;

  var pages = [
    const OneWebDashboard(),
    const OneWebTickets(),
    const OneWebSetting(),
  ];
}