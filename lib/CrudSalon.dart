import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'gestionSoins.dart';
import 'interfaceClient.dart';

class CrudSalon extends StatefulWidget {
  const CrudSalon ({Key? key}) : super(key: key);

  @override
  State<CrudSalon > createState() => _CrudSalonState ();
}

class _CrudSalonState extends State<CrudSalon > {
  Future<void> deleteSalon(int salonId) async {
    try {
      await client.from('sallon').delete().eq('id', salonId);
      setState(() {});
    } catch (error) {
      print('Error deleting salon: $error');
    }
  }


  Future<void> editSalon(int salonId, String newName, String ville,String newAddress, String newPhoneNumber, String newDescription) async {
    try {
      await client.from('sallon').update({
        'nom': newName,
        'adresse': newAddress,
        'ville':ville,
        'Phone_number': newPhoneNumber,
        'description': newDescription,
      }).eq('id', salonId);
      setState(() {});
    } catch (error) {
      print('Error editing salon: $error');
    }
  }
  void showDeleteConfirmationDialog(BuildContext context, int salonId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this salon?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteSalon(salonId);
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addSalon(String name, String ville,String address, String phoneNumber, String description) async {
    try {
      await client.from('sallon').insert({
        'nom': name,
        'ville': ville,
        'adresse': address,
        'Phone_number': phoneNumber,
        'description': description,
        'professionel_id': Supabase.instance.client.auth.currentUser?.id!
      });
      setState(() {});
    } catch (error) {
      print('Error adding salon: $error');
    }
  }

  void showEditDialog(BuildContext context, int salonId, String currentName, String currentAddress, String currentVille, int currentPhoneNumber, String currentDescription) {
    final _nameController = TextEditingController(text: currentName);
    final _addressController = TextEditingController(text: currentAddress);
    final _villeController = TextEditingController(text: currentVille); // Utilisez la valeur actuelle de la ville
    final _phoneNumberController = TextEditingController(text: currentPhoneNumber.toString());
    final _descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Salon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              TextFormField(
                controller: _villeController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                await editSalon(salonId, _nameController.text,_villeController.text,_addressController.text, _phoneNumberController.text, _descriptionController.text);
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }


  void showAddSalonDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _addressController = TextEditingController();
    final _villeController = TextEditingController();
    final _phoneNumberController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Salon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _villeController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                await addSalon(_nameController.text,  _villeController.text,_addressController.text, _phoneNumberController.text, _descriptionController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  Future<List<Map<String, dynamic>>?> fetchAllSallons() async {
    try {
      final response = await client.from('sallon').select();
      return response as List<Map<String, dynamic>>;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Saloons' list"),
    ),
    body: Container(
    color: Colors.white,
    child: Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
    child: FutureBuilder<List<Map<String, dynamic>>?>(
    future: fetchAllSallons(),
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> doctorsSnapshot) {
    if (doctorsSnapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (doctorsSnapshot.hasError || doctorsSnapshot.data == null) {
    return Center(child: Text('Error fetching doctors data'));
    } else {
    final data = doctorsSnapshot.data!;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (data.length / 2).ceil(),
      itemBuilder: (context, index) {
        final isEvenIndex = index * 2 + 1 < data.length;
        final patientData1 = data[index * 2];
        final patientData2 = isEvenIndex ? data[index * 2 + 1] : null;

        return Row(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: PatientList(
                patientImagePath: patientData1['avatar_url'] ?? 'no image',
                patientName: patientData1['nom'] ?? 'No Name',
                patientId: patientData1['id'] ?? 0,
                patientAdresse: patientData1['adresse'] ?? '',
                ville: patientData1['ville'] ?? '',
                onDeletePressed: () => showDeleteConfirmationDialog(context, patientData1['id']),
                onEditPressed: () => showEditDialog(
                  context,
                  patientData1['id'],
                  patientData1['nom'] ?? '',
                  patientData1['ville'] ?? '',
                  patientData1['adresse'] ?? '',
                  patientData1['Phone_number'],
                  patientData1['description'] ?? '',
                ),
              ),
            ),
            if (patientData2 != null)
              Expanded(
                child: PatientList(
                  patientImagePath: patientData2['avatar_url'] ?? 'no image',
                  patientName: patientData2['nom'] ?? 'No Name',
                  patientId: patientData2['id'] ?? 0,
                  patientAdresse: patientData2['adresse'] ?? '',
                  ville: patientData2['ville'] ?? '',
                  onDeletePressed: () => showDeleteConfirmationDialog(context, patientData2['id']),
                  onEditPressed: () => showEditDialog(
                    context,
                    patientData2['id'],
                    patientData2['nom'] ?? '',
                    patientData2['ville'] ?? '',
                    patientData2['adresse'] ?? '',
                    patientData2['Phone_number'] ?? '',
                    patientData2['description'] ?? '',
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
        onPressed: () => showAddSalonDialog(context),
        backgroundColor: Colors.pink,
        child: Icon(Icons.add, color: CupertinoColors.white),
      ),
    );
  }
}

class PatientList extends StatelessWidget {
  final String patientImagePath;
  final String patientName;
  final String ville;
  final String patientAdresse;
  final int patientId;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const PatientList({
    Key? key,
    required this.patientImagePath,
    required this.patientName,
    required this.patientAdresse,
    required this.ville,
    required this.patientId,
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.network(
                patientImagePath.isNotEmpty ? patientImagePath : 'default_image_path',
                width: 70,
                height: 70,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
            Text(
              patientName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              patientAdresse,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              ville,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SoinsPage(salonId: patientId)));
                },
                child: Text('Conculter les soins de salon', style: TextStyle(color: Colors.white70)),
              ),
            ),
            Center(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
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
            ),
          ],
        ),
      ),
    );
  }
}
