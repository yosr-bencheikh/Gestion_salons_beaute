import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'ProfessionelHome.dart';
import 'List.dart';
import 'category.dart';
import 'constants.dart';

class InterfaceClient extends StatefulWidget {
  const InterfaceClient({Key? key}) : super(key: key);

  @override
  _InterfaceClientState createState() => _InterfaceClientState();
}

class _InterfaceClientState extends State<InterfaceClient> {
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: EasySearchBar(
        title: const Text('Enter the desired city'),
        onSearch: (value) => setState(() => searchValue = value),
        showClearSearchIcon: true,
        asyncSuggestions: (value) async => await _fetchSuggestions(value),
        searchHintStyle: TextStyle(color: Colors.black87),
        backgroundColor: prColor,
        suggestionBackgroundColor: Colors.white,
      ),*/
      body: Container(
        child: Column(
          children: [
            smallBox,
            UserInfoCard(onSearch: (String value) => setState(() => searchValue = value)),
            smallBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Choose your salon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text('See all', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            smallBox,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: FutureBuilder<List<Map<String, dynamic>>?>(
                  future: fetchAllSalons(searchValue),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> salonsSnapshot) {
                    if (salonsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (salonsSnapshot.hasError || salonsSnapshot.data == null) {
                      return Text('Error fetching salons data');
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: (salonsSnapshot.data!.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          final startIndex = index * 2;
                          final endIndex = startIndex + 2;
                          final salonData = salonsSnapshot.data!.sublist(startIndex, endIndex > salonsSnapshot.data!.length ? salonsSnapshot.data!.length : endIndex);

                          if (salonData.length == 2) {
                            return Row(
                              children: [
                                Expanded(
                                  child: S_List(
                                    rating: 4,
                                    salonName: salonData[0]['nom'] ?? ' ',
                                    salonAddress: salonData[0]['adresse'] ?? ' ',
                                    ville: salonData[0]['ville'] ?? ' ',
                                    salonId: salonData[0]['id'],
                                    salonPhone: salonData[0]['Phone_number'],
                                    description: salonData[0]['description'],
                                  ),
                                ),
                                Expanded(
                                  child: S_List(
                                    rating: 4,
                                    salonName: salonData[1]['nom'] ?? ' ',
                                    salonAddress: salonData[1]['adresse'] ?? ' ',
                                    ville: salonData[1]['ville'] ?? ' ',
                                    salonId: salonData[1]['id'],
                                    salonPhone: salonData[1]['Phone_number'],
                                    description: salonData[1]['description'],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return S_List(
                              rating: 4,
                              salonName: salonData[0]['nom'] ?? ' ',
                              salonAddress: salonData[0]['adresse'] ?? ' ',
                              ville: salonData[0]['ville'] ?? ' ',
                              salonId: salonData[0]['id'],
                              salonPhone: salonData[0]['Phone_number'],
                              description: salonData[0]['description'],
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    try {
      var query = client.from('sallon').select();
      if (searchValue.isNotEmpty) {
        query = query.ilike('ville', '%$searchValue%');
      }
      final response = await query;
      final List<String> suggestions = response.map<String>((salon) => salon['ville'].toString()).toList();
      return suggestions;
    } catch (error) {
      return [];
    }
  }
}
class UserInfoCard extends StatefulWidget {
  final Function(String) onSearch;

  const UserInfoCard({Key? key, required this.onSearch}) : super(key: key);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Map<String, String?>>(
      future: fetchUserInfo(),
      builder: (context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error fetching user info');
        } else {
          final userInfo = snapshot.data!;
          final username = userInfo['username'];

          return Container(
            height: screenHeight * 0.25,
            width: double.infinity,
            child: Card(
              color: prColor,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('images/nour.jpg'),
                      radius: 30,
                    ),
                    title: Text("Hello"),
                    subtitle: Text(
                      username!,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Search location',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: widget.onSearch,
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

  Future<Map<String, String?>> fetchUserInfo() async {
    try {
      final response = await client
          .from('client')
          .select('username')
          .eq('id', client.auth.currentUser!.id)
          .single();
      return {
        'username': response['username'] as String?,
        'imageUrl': null,
      };
    } catch (error) {
      return {'username': null, 'imageUrl': null};
    }
  }
}


  Future<List<String>> _fetchSuggestions(String searchValue) async {
    try {
      var query = client.from('sallon').select();
      if (searchValue.isNotEmpty) {
        query = query.ilike('ville', '%$searchValue%');
      }
      final response = await query;
      final List<String> suggestions = response.map<String>((salon) => salon['ville'].toString()).toList();
      return suggestions;
    } catch (error) {
      return [];
    }
  }


Future<List<Map<String, dynamic>>?> fetchAllSalons(String? searchValue) async {
  try {
    var query = client.from('sallon').select();
    if (searchValue != null && searchValue.isNotEmpty) {
      query = query.ilike('ville', '%$searchValue%');
    }

    final response = await query;
    return response as List<Map<String, dynamic>>;
  } catch (error) {
    return null;
  }
}

Future<List<Map<String, dynamic>>?> fetchAllSallon() async {
  try {
    var query = client.from('sallon').select();

    final response = await query;
    return response as List<Map<String, dynamic>>;
  } catch (error) {
    return null;
  }
}

Future<String?> fetchUser(String col) async {
  try {
    final user_name = await client
        .from('client')
        .select(col)
        .eq('id', client.auth.currentUser!.id)
        .single();

    return user_name[col] as String?;
  } catch (error) {
    return null;
  }
}
