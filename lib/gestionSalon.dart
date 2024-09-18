import 'package:flutter/material.dart';

import 'List.dart';
import 'interfaceClient.dart';

class GestionSalon extends StatefulWidget {
  const GestionSalon({Key? key}) : super(key: key);

  @override
  _GestionSalonState createState() => _GestionSalonState();
}

class _GestionSalonState extends State<GestionSalon> {
  late Future<List<Map<String, dynamic>>?> _salonsFuture;

  @override
  void initState() {
    super.initState();
    _salonsFuture = fetchAllSallon();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: fetchAllSallon(),
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> doctorsSnapshot) {
            if (doctorsSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (doctorsSnapshot.hasError || doctorsSnapshot.data == null) {
              // Handle the error condition when fetching doctors data
              return Text('Error fetching doctors data');
            } else {
              // Use ListView.builder to display the list of doctors
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: doctorsSnapshot.data!.length,
                itemBuilder: (context, index) {
                  // Check if the index is even or odd
                  bool isEvenIndex = index.isEven;

                  // For even index, create a new row
                  if (isEvenIndex) {
                    int nextIndex = index + 1;
                    if (nextIndex < doctorsSnapshot.data!.length) {
                      final doctorData1 = doctorsSnapshot.data![index];
                      final doctorData2 = doctorsSnapshot.data![nextIndex];

                      return Row(
                        children: [
                          S_List(
                              rating: 4,
                              // doctorImagePath: 'ghjk',doctorData1['avatar_url'],
                              salonName: doctorData1['nom'],//doctorData1['username'] ?? 'No Name',


                              salonAddress: doctorData1['adresse'],//'tunis',
                              //doctorPhone:"99856233", //doctorData1['Phone_number']?.toString() ?? 'No phone',
                              ville:doctorData1['ville'], salonId:  doctorData1['id'], salonPhone: doctorData1['Phone_number'], description: doctorData1['description'],

                          ),
                          S_List(
                              rating: 4,
                              // doctorImagePath: 'ghjk',doctorData1['avatar_url'],
                              salonName: doctorData2['nom'],//doctorData1['username'] ?? 'No Name',


                              salonAddress: doctorData2['adresse'],//'tunis',
                              //doctorPhone:"99856233", //doctorData1['Phone_number']?.toString() ?? 'No phone',
                              ville:doctorData2['ville'], salonId:  doctorData2['id'], salonPhone: doctorData2['Phone_number'], description: doctorData2['description'],
                          ),
                        ],
                      );
                    }
                  }

                  // Return an empty container for odd index
                  return Container();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
