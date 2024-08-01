import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../constants/colors/colors.dart';
import '../layout/one_mobile_layout/one_mobile_layout.dart';
import '../layout/one_tablet_layout/one_tablet_layout.dart';
import '../layout/one_web_layout/one_web_layout.dart';
import '../layout/responsive_layout.dart';
import '../layout/super_mobile_layout/super_mobile_layout.dart';
import '../layout/super_tablet_layout/super_tablet_layout.dart';
import '../layout/super_web_layout/super_web_layout.dart';
import '../layout/tablet_layout/tablet_layout.dart';
import '../layout/three_mobile_layout/three_mobile_layout.dart';
import '../layout/three_tablet_layout/three_tablet_layout.dart';
import '../layout/three_web_layout/three_web_layout.dart';
import '../layout/two_mobile_layout/two_mobile_layout.dart';
import '../layout/two_tablet_layout/two_tablet_layout.dart';
import '../layout/two_web_layout/two_web_layout.dart';
import '../screens/mobile_login_screen/mobile_login_screen.dart';
import '../screens/web_login_screen/web_login_screen.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const ResponsiveLayout(
                mobileScaffold: MobileLoginScreen(),
                tabletScaffold: TabletLayout(),
                webScaffold: WebLoginScreen()
            );
          } else {
            String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentMonth)
                  .collection('userList')
                  .doc(user.uid)
                  .get(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    DocumentSnapshot<Map<String, dynamic>>? userSnapshot = snapshot.data;
                    if (userSnapshot != null && userSnapshot.exists) {
                      String role = userSnapshot.data()!['role'];

                      if (role == "Super") {
                        return const ResponsiveLayout(
                          mobileScaffold: SuperMobileLayout(),
                          tabletScaffold: SuperTabletLayout(),
                          webScaffold: SuperWebLayout(),
                        );
                      } else if (role == "Level One") {
                        return const ResponsiveLayout(
                          mobileScaffold: OneMobileLayout(),
                          tabletScaffold: OneTabletLayout(),
                          webScaffold: OneWebLayout(),
                        );
                      } else if (role == "Level Two") {
                        return const ResponsiveLayout(
                          mobileScaffold: TwoMobileLayout(),
                          tabletScaffold: TwoTabletLayout(),
                          webScaffold: TwoWebLayout(),
                        );
                      } else if (role == "Level Three") {
                        return const ResponsiveLayout(
                          mobileScaffold: ThreeMobileLayout(),
                          tabletScaffold: ThreeTabletLayout(),
                          webScaffold: ThreeWebLayout(),
                        );
                      }
                    }
                  }
                }

                return const Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Loading...',
                        style: TextStyle(
                            fontSize: 20,
                            color: primary
                        ),
                      ),
                      SpinKitChasingDots(
                        color: primary,
                        size: 24,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } else {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                      fontSize: 20,
                      color: primary
                  ),
                ),
                SpinKitChasingDots(
                  color: primary,
                  size: 24,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}