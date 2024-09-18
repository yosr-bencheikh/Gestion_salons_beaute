import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'SoinsDetails.dart';
import 'constants.dart';

class SoinsList extends StatefulWidget {
  final int salonId;

  const SoinsList({Key? key, required this.salonId}) : super(key: key);

  @override
  State<SoinsList> createState() => _SoinsListState();
}

class _SoinsListState extends State<SoinsList> {
  String searchValue = '';
  List<Map<String, dynamic>> soinsData = [];
  bool isSearching = false;

  Future<void> fetchAllSoins() async {
    try {
      final response = await client.from('soin').select().eq('salon_id', widget.salonId);
      setState(() {
        soinsData = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      setState(() {
        soinsData = [];
      });
    }
  }

  Future<void> fetchSearchSoins(String searchValue) async {
    try {
      var query = client.from('soin').select().eq('salon_id', widget.salonId);
      if (searchValue.isNotEmpty) {
        query = query.ilike('nom', '%$searchValue%');
      }
      final response = await query;
      setState(() {
        soinsData = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      setState(() {
        soinsData = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllSoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text('Enter the desired treatment'),
        onSearch: (value) {
          setState(() {
            searchValue = value;
            isSearching = value.isNotEmpty;
            if (isSearching) {
              fetchSearchSoins(value);
            } else {
              fetchAllSoins();
            }
          });
        },
        showClearSearchIcon: true,
        asyncSuggestions: (value) async => await _fetchSuggestions(value),
        searchHintStyle: TextStyle(color: Colors.black87),
        backgroundColor: prColor,
        suggestionBackgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20), // Add space below the AppBar
              Expanded(
                child: soinsData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: (soinsData.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final int dataIndex = index * 2;
                    final bool hasPair = dataIndex + 1 < soinsData.length;
                    final Map<String, dynamic> soinData1 = soinsData[dataIndex];
                    final Map<String, dynamic>? soinData2 = hasPair ? soinsData[dataIndex + 1] : null;

                    return Row(
                      children: [
                        Expanded(
                          child: SoinListItem(
                            soinName: soinData1['nom'] ?? 'No Name',
                            prix: soinData1['prix'] != null ? soinData1['prix'].toString() : '0.0',
                            duree: soinData1['duree'] != null ? soinData1['duree'].toString() : '0.0',
                            description: soinData1['description'] ?? '',
                            soinId: soinData1['id'],
                          ),
                        ),
                        if (soinData2 != null)
                          Expanded(
                            child: SoinListItem(
                              soinName: soinData2['nom'] ?? 'No Name',
                              prix: soinData2['prix'] != null ? soinData2['prix'].toString() : '0.0',
                              duree: soinData2['duree'] != null ? soinData2['duree'].toString() : '0.0',
                              description: soinData2['description'] ?? '',
                              soinId: soinData2['id'],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    try {
      var query = client.from('soin').select();
      if (searchValue.isNotEmpty) {
        query = query.ilike('nom', '%$searchValue%');
      }
      final response = await query;
      final List<String> suggestions = response.map<String>((soin) => soin['nom'].toString()).toList();
      return suggestions;
    } catch (error) {
      return [];
    }
  }
}

class SoinListItem extends StatelessWidget {
  final String soinName;
  final String prix;
  final String duree;
  final String description;
  final int soinId;

  const SoinListItem({
    Key? key,
    required this.soinName,
    required this.prix,
    required this.duree,
    required this.description,
    required this.soinId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SoinDetailsPage(
              soinName: soinName,
              description: description,
              prix: prix,
              duree: duree,
              soinId: soinId,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$soinName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Duree: $duree h',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                '$prix dt',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
