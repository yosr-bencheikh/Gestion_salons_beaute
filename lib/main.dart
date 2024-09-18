import 'package:doctor_appointment/bookingPage.dart';
import 'package:doctor_appointment/signIn.dart';
import 'package:doctor_appointment/signUp.dart';
import 'package:doctor_appointment/successPage.dart';

import 'package:hcaptcha/hcaptcha.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';


import 'change_password_page.dart';


import 'Notifications.dart';
import 'Settings.dart';
import 'constants.dart';
import 'gestionSalon.dart';
import 'gestionSoins.dart';
import 'home_page.dart';
import 'interfaceClient.dart';
import 'interfaceProfessionel.dart';
import 'navigationbar.dart';

void main() async {


  await Supabase.initialize(
      url: "https://ncezitmfdhqhkxqfjonv.supabase.co",
      anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jZXppdG1mZGhxaGt4cWZqb252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDU1MDMwNTAsImV4cCI6MjAyMTA3OTA1MH0.hJVmYSINCkgHNfmVdmmijghP9soD0WOGOajEBip4yL0'
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();



  Future<void> _setFcmToken(String fcmToken) async {
    try {
      final userId = client.auth.currentUser!.id;
      if (userId != null) {
        await client.from('notifications').upsert({
          'user_id': userId,
          'fmc_token': fcmToken,
        });
        print("FCM Token set for user $userId");
      }
    } catch (e) {
      print("Error setting FCM token: $e");
    }
  }}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/gestionSalon': (context) => const GestionSalon(),
        '/interfaceclient': (context) => const NavigationExample(),
        '/notifications': (context) => const Notifications(),
        '/settings': (context) => const Settings(),
        '/bookingPage': (context) => BookingPage(soinId: ModalRoute.of(context)!.settings.arguments as String),
        '/successPage': (context) => const SuccessPage(),
        '/interfaceprofessionel': (context) => const InterfaceProfessionel(),
        '/changepassword': (context) => PasswordChangePage(),
      },
    );
  }
}
