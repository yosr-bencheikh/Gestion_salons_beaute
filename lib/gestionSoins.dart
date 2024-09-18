import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class SoinsPage extends StatefulWidget {
  final int salonId;

  const SoinsPage({Key? key, required this.salonId}) : super(key: key);

  @override
  State<SoinsPage> createState() => _SoinsPageState();
}

class _SoinsPageState extends State<SoinsPage> {
  Future<void> deleteSoin(int soinId) async {
    try {
      await client.from('soin').delete().eq('id', soinId);
      setState(() {});
    } catch (error) {
      print('Error deleting soin: $error');
    }
  }

  Future<void> editSoin(int soinId, String newName, String description, String prix, String duree) async {
    try {
      await client.from('soin').update({
        'nom': newName,
        'description': description,
        'prix': prix,
        'duree': duree,
      }).eq('id', soinId);
      setState(() {});
    } catch (error) {
      print('Error editing soin: $error');
    }
  }

  Future<void> addSoin(String name, String description, String prix, String duree) async {
    try {
      await client.from('soin').insert({
        'nom': name,
        'description': description,
        'prix': double.tryParse(prix) ?? 0.0,
        'duree': double.tryParse(duree) ?? 0.0,
        'salon_id': widget.salonId,
      });
      setState(() {});
    } catch (error) {
      print('Error adding soin: $error');
    }
  }

  void showEditDialog(BuildContext context, int soinId, String currentName, String currentDescription, String currentPrix, String currentDuree) {
    final _nameController = TextEditingController(text: currentName);
    final _descriptionController = TextEditingController(text: currentDescription);
    final _prixController = TextEditingController(text: currentPrix);
    final _dureeController = TextEditingController(text: currentDuree);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Soin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
              ),
              TextFormField(
                controller: _dureeController,
                decoration: InputDecoration(labelText: 'Duree'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await editSoin(soinId, _nameController.text, _descriptionController.text, _prixController.text, _dureeController.text);
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int soinId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this soin?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteSoin(soinId);
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showAddSoinDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _prixController = TextEditingController();
    final _dureeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Soin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
              ),
              TextFormField(
                controller: _dureeController,
                decoration: InputDecoration(labelText: 'Duree'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await addSoin(
                  _nameController.text,
                  _descriptionController.text,
                  _prixController.text,
                  _dureeController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>?> fetchAllSoins() async {
    try {
      final response = await client.from('soin').select().eq('salon_id', widget.salonId);
      return response as List<Map<String, dynamic>>;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soins List'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: FutureBuilder<List<Map<String, dynamic>>?>(
            future: fetchAllSoins(),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> soinsSnapshot) {
              if (soinsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (soinsSnapshot.hasError || soinsSnapshot.data == null) {
                return Center(child: Text('Error fetching soins data'));
              } else {
                final data = soinsSnapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: (data.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final isEvenIndex = index * 2 + 1 < data.length;
                    final soinData1 = data[index * 2];
                    final soinData2 = isEvenIndex ? data[index * 2 + 1] : null;

                    return Row(
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          child: SoinList(
                            soinName: soinData1['nom'] ?? 'No Name',
                           // description: soinData1['description'] ?? '',
                            prix: soinData1['prix'] != null ? soinData1['prix'].toString() : '0.0',
                            duree: soinData1['duree'] != null ? soinData1['duree'].toString() : '0.0',
                            onDeletePressed: () => showDeleteConfirmationDialog(context, soinData1['id']),
                            onEditPressed: () => showEditDialog(
                              context,
                              soinData1['id'],
                              soinData1['nom'] ?? '',
                              soinData1['description'] ?? '',
                              soinData1['prix'] != null ? soinData1['prix'].toString() : '0.0',
                              soinData1['duree'] != null ? soinData1['duree'].toString() : '0.0',
                            ),
                          ),
                        ),
                        if (soinData2 != null)
                          Expanded(
                            child: SoinList(
                              soinName: soinData2['nom'] ?? 'No Name',
                              //description: soinData2['description'] ?? '',
                              prix: soinData2['prix'] != null ? soinData2['prix'].toString() : '0.0',
                              duree: soinData2['duree'] != null ? soinData2['duree'].toString() : '0.0',
                              onDeletePressed: () => showDeleteConfirmationDialog(context, soinData2['id']),
                              onEditPressed: () => showEditDialog(
                                context,
                                soinData2['id'],
                                soinData2['nom'] ?? '',
                                soinData2['description'] ?? '',
                                soinData2['prix'] != null ? soinData2['prix'].toString() : '0.0',
                                soinData2['duree'] != null ? soinData2['duree'].toString() : '0.0',
                              ),
                            ),
                          ),
                        if (!isEvenIndex) // Vérifie si c'est la dernière ligne
                          Expanded(child: Container()), // Ajoute un conteneur vide pour maintenir la taille
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddSoinDialog(context),
        backgroundColor: Colors.pink,
        child: Icon(Icons.add, color: CupertinoColors.white),
      ),
    );
  }
}

class SoinList extends StatelessWidget {
  final String soinName;
  //final String description;
  final String prix;
  final String duree;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const SoinList({
    Key? key,
    required this.soinName,
  //  required this.description,
    required this.prix,
    required this.duree,
    this.onDeletePressed,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Center(
              child: Text(
                'Soin Name: $soinName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          /*  Text(
              'Description: $description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),*/
            Center(
              child: Text(
                'Prix: $prix',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),

            ),
            Center(
              child: Text(
                'Duree: $duree',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (onDeletePressed != null) {
                      onDeletePressed!();
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (onEditPressed != null) {
                      onEditPressed!();
                    }
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
