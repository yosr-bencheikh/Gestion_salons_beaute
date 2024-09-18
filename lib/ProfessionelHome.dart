import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'CrudSalon.dart';
import 'gestionSalon.dart';

class ProfessionelHome extends StatefulWidget {
  const ProfessionelHome({Key? key}) : super(key: key);

  @override
  _ProfessionelHomeState  createState() => _ProfessionelHomeState ();
}

class _ProfessionelHomeState extends State<ProfessionelHome> with WidgetsBindingObserver {
  List<Map<String, dynamic>> appointments = [];
  bool isDoctor = false; // Assume the user is not a doctor initially
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    // Add the WidgetsBindingObserver
    WidgetsBinding.instance?.addObserver(this);
    // Check the user's role (doctor or patient)
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    // Remove the WidgetsBindingObserver
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16),
            UserInfoCard(),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your appointment requests',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            smallBox,
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 300,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Color.fromARGB(221, 205, 183, 183),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset('images/sa.jpg',
                                    width: 200, height: 100),
                              ),
                              SizedBox(height: 8.0),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => CrudSalon()));
                                },
                                child: Text('Consulter vos salons de beauté'),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adds space between the two containers
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();

    // Get screen size
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<String?>(
      future: fetchUserData('username'), // Fetch only username
      builder: (context, AsyncSnapshot<String?> usernameSnapshot) {
        if (usernameSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (usernameSnapshot.hasError || usernameSnapshot.data == null) {
          // Handle the error condition when fetching username
          return Text('Error fetching username');
        } else {
          return Container(
            height: screenHeight * 0.2,
            width: double.infinity,
            child: Card(
              color: prColor,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.waving_hand),
                    title: Text("Hello"),
                    subtitle: Text(
                      "Professionel  ${usernameSnapshot.data!}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                   /* trailing: Container(
                      width: 60,
                      height: 50,
                      // Comment out the image part to not display the image
                      /* child: ClipOval(
                        child: Image.network(
                          imageUrlSnapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ), */
                    ),*/
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 45,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        // Implement your search logic here
                        // You may want to filter the names based on the entered text
                        // and update the UI accordingly
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: Colors.black87),
                        labelText: 'How can we help you?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

Future<String?> fetchUserData(String col) async {
  try {
    // Replace this with your actual implementation to fetch user data
    final user_name = await client
        .from('professionel')
        .select(col)
        .eq('id', client.auth.currentUser!.id)
        .single();

    return user_name[col] as String?;
  } catch (error) {
    return null;
  }
}
