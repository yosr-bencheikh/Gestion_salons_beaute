import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'Details.dart';

class S_List extends StatelessWidget {
  final int salonId;
  final int rating;
 // final String doctorImagePath;
  final String salonName;
  final String description;
  final String salonAddress;
  final int salonPhone;
  final String ville;


  const S_List({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
              salonId: salonId,
              //doctorImagePath: doctorImagePath,
              salonAddress: salonAddress,
              description: description,
              salonName: salonName,
              //doctorPhone: doctorPhone,
              ville: ville, rating: rating, salonPhone: salonPhone.toString(),

            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 15),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: prColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
             /* ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(
                  doctorImagePath ?? 'default_avatar_image_path',
                  width: 70,
                  height: 70,
                ),
              ),*/
              smallBox,
              buildRow(),
              smallBox,
              Text(
                salonName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(ville),
             // Text(salonAddress ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildRow() {
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Column(
            children: [
              if (i < rating)
                Icon(
                  Icons.star,
                  color: Colors.yellow[500],
                )
              else
                Icon(
                  Icons.star,
                  color: Colors.grey[500],
                ),
            ],
          ),
      ],
    );
  }
}
