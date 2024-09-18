import 'package:flutter/material.dart';
import 'bookingPage.dart';
import 'constants.dart';
import 'Custom_appbar.dart';

class SoinDetailsPage extends StatelessWidget {
  final String soinName;
  final String description;
  final String prix;
  final String duree;
  final int soinId;

  const SoinDetailsPage({
    Key? key,
    required this.soinId,
    required this.soinName,
    required this.description,
    required this.prix,
    required this.duree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          appTitle: 'Soin Details',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  smallBox,
                  Text(
                    soinName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  smallBox,
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  smallBox,
                  SizedBox(
                    height: 70,
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  smallBox,
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        NewWidget(label: 'Prix', value: '$prix dt'),
                        widthSpace,
                        NewWidget(label: 'Durée', value: '$duree dt'),
                      ],
                    ),
                  ),
                  smallBox,
                  smallBox,
                  Text(
                    'does this soin suits you ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            soinId: soinId.toString(), // Pass the doctor's ID
                          ),
                        ),
                      );



              },    style: ElevatedButton.styleFrom(
                primary: prColor,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ), child:Text('Book an appointment')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: prColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
