import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticket/constants/theme/mode_theme.dart';
import 'package:ticket/providers/mode_provider.dart';
import 'auth/auth_checker.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  runApp(
      ChangeNotifierProvider(create: (context) => ModeProvider(),
      child: const MyApp())
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Transit',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ModeProvider>(context).lightModeEnable ? ModeTheme.lightMode : ModeTheme.darkTheme,
      home: const AuthChecker(),
    );
  }
}
