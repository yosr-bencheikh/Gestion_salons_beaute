import 'package:flutter/material.dart';
import 'package:doctor_appointment/constants.dart';
import 'package:doctor_appointment/Custom_appbar.dart';
import 'package:doctor_appointment/successPage.dart';

import 'SoinList.dart';
import 'bookingPage.dart';
import 'gestionSoins.dart';

class Details extends StatefulWidget {
  final int salonId;
  final int rating;
  // final String doctorImagePath;
  final String salonName;

  final String salonAddress;
  final String salonPhone;
  final String ville;
  final String description;

  const Details({
    Key? key,
    required this.salonId,
    required this.rating,
    //required this.doctorImagePath,
    required this.salonName,
    required this.description,



    required this.salonAddress,
    required this.salonPhone,
    required this.ville,
  }) : super(key: key);

  @override
  State<Details> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<Details> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          appTitle: 'Saloon Details',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                 /* ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.doctorImagePath,
                      width: 120,
                      height: 120,
                    ),
                  ),*/
                  smallBox,
                  Text(
                    widget.salonName,
                    style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  smallBox,
                  Text(
                    'Situé à ${widget.ville}',
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
                      widget.salonAddress,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width ,
                    child: Text(
                     '${widget.description}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  smallBox,
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        NewWidget(label: 'Address', value: widget.salonAddress),
                        widthSpace,
                        NewWidget(label: 'Hours', value: '9 AM : 7 PM'),
                        widthSpace,
                        NewWidget(label: 'Phone', value: widget.salonPhone),
                      ],
                    ),
                  ),
                  smallBox,
                  smallBox,
                  Text(
                    'check the soins here ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  smallBox,
                  ElevatedButton(
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            doctorId: widget.salonId.toString(), // Pass the doctor's ID
                          ),
                        ),
                      );*/

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoinsList(salonId: widget.salonId)));

                    },

                    style: ElevatedButton.styleFrom(
                      primary: prColor,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('check the soins'),
                  ),
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
