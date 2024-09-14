import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school_administration/Screen/Professeurs/detail_professeurs.dart';
import 'package:school_administration/Screen/Professeurs/nouveau_prof.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/model_professeurs.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class ListProfesseurs extends StatefulWidget {
  const ListProfesseurs({super.key});

  @override
  State<ListProfesseurs> createState() => _ListProfesseursState();
}

class _ListProfesseursState extends State<ListProfesseurs> {
  late Future<List<Professeurs>> profs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    // Initialisez le Future ici
    profs = _fetchProfesseurs();
  }

  Future<List<Professeurs>> _fetchProfesseurs() async {
    final profs = await dbHelper.getAllProfesseurs();
    print("Fetched professors: $profs"); // Debugging line
    return profs; // Ensure this is never null
  }

  Future<void> _onRefresh() async {
    setState(() {
      profs = _fetchProfesseurs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: myredColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NouveauProfesseur(),
                  ));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: myblueColor,
            centerTitle: true,
            title: const Text(
              "PROFESSEURS",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Row(
            children: [
              const MyDrawer(),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FutureBuilder<List<Professeurs>>(
                  future: profs, // Your future here
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Professeurs>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final List<Professeurs> items = snapshot.data!;
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final Professeurs prof =
                              items[index]; // Get a specific professor
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      FileImage(File(prof.image_path)),
                                  radius: 30,
                                ),
                                title: Text(prof.prenom),
                                subtitle: Text(prof.nom),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.info,
                                          color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailProfesseurs(
                                              professeurs: prof,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Confirmer la suppression"),
                                            content: const Text(
                                                "Êtes-vous sûr de vouloir supprimer ce professeur ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Fermer le dialogue
                                                },
                                                child: Text(
                                                  "Annuler",
                                                  style: TextStyle(
                                                      color: myredColor),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  delete(prof.id);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Supprimer"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProfesseurs(
                                        professeurs: prof,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: Text("Aucun professeur trouvé !!!"));
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  // Supprimer un profs
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteProfesseur(id);
      if (res > 0) {
        setState(() {
          _onRefresh();
        });
      }
    } else {
      // Gérer le cas où l'ID est nul
      print("L'ID est nul et ne peut pas être supprimé.");
    }
  }
}
