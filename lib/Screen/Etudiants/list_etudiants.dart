import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school_administration/Screen/Etudiants/etudiant_detail.dart';
import 'package:school_administration/Screen/Etudiants/nouvaeu_etudiant.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class ListEtudiants extends StatefulWidget {
  const ListEtudiants({super.key});

  @override
  State<ListEtudiants> createState() => _ListEtudiantsState();
}

class _ListEtudiantsState extends State<ListEtudiants> {
  late Future<List<Etudiants>> etudiant;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    // Initialisez le Future ici
    etudiant = _fetchEtudiants();
  }

  Future<List<Etudiants>> _fetchEtudiants() async {
    final students = await dbHelper.getAllEtudiants();
    return students;
  }

  Future<void> _onRefresh() async {
    setState(() {
      etudiant = _fetchEtudiants();
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
                    builder: (context) => const NouveauEtudiant(),
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
              "ETUDIANTS",
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
                child: FutureBuilder(
                  future: etudiant, // Votre future ici
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Etudiants>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("Aucun étudiant trouvé !!!"));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      final List<Etudiants> items =
                          snapshot.data ?? <Etudiants>[];
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final Etudiants etudiant =
                              items[index]; // Récupère un étudiant spécifique
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
                                      FileImage(File(etudiant.image_path)),
                                  radius: 30,
                                  // child: Text(etudiant.prenom[0]),
                                ),
                                title: Text(etudiant.prenom),
                                subtitle: Text(etudiant.nom),
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
                                                DetailEtudiant(
                                              etudiant: etudiant,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        delete(etudiant.id);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailEtudiant(
                                        etudiant: etudiant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  // Supprimer un Etudiant
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteEtudiant(id);
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

  void showStudentDetails(BuildContext context, Etudiants etudiant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: myblueColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(etudiant.image_path),
                            radius: 50,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${etudiant.prenom} ${etudiant.nom}",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    buildInfoRow(Icons.school, "Filière",
                        etudiant.filiere_choisie.toString()),
                    buildInfoRow(Icons.phone, "Téléphone",
                        etudiant.telephone.toString()),
                    buildInfoRow(
                        Icons.grade, "Niveau", etudiant.niveau.toString()),
                    buildInfoRow(Icons.calendar_today, "Session",
                        etudiant.session.toString()),
                    buildInfoRow(
                        Icons.email, "Email", etudiant.email.toString()),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myblueColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: myblueColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
