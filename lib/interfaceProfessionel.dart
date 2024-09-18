
import 'package:doctor_appointment/ProfessionelHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Notifications.dart';
import 'Settings.dart';
import 'constants.dart';

class InterfaceProfessionel extends StatelessWidget {
  const InterfaceProfessionel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const InterfaceProfessionelExample(),
    );
  }
}

class InterfaceProfessionelExample extends StatefulWidget {
  const InterfaceProfessionelExample({Key? key}) : super(key: key);

  @override
  State<InterfaceProfessionelExample> createState() => _DoctorNavigationExampleState();
}

class _DoctorNavigationExampleState extends State<InterfaceProfessionelExample> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        indicatorColor: prColor,
        selectedIndex: pageIndex,
        destinations: doctorDestinations,
      ),
      body: <Widget>[
        ProfessionelHome(),
        Notifications(),
        Settings(),
      ][pageIndex],
    );
  }
}


const List<NavigationDestination> doctorDestinations = <NavigationDestination>[
  NavigationDestination(
    selectedIcon: Icon(Icons.home),
    icon: Icon(Icons.home),
    label: 'Home',
  ),

  NavigationDestination(
    selectedIcon: Icon(Icons.calendar_month),
    icon: Icon(Icons.calendar_month),
    label: 'Schedule',
  ),
  NavigationDestination(
    icon: Badge(
      child: Icon(Icons.settings),
    ),
    label: 'Settings',
  ),
];