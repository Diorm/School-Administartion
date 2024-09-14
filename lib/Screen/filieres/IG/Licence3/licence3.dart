// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school_administration/Screen/filieres/IG/Licence3/Semestres/premiere_semestre/modules.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_card.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class IG3 extends StatefulWidget {
  const IG3({super.key});

  @override
  State<IG3> createState() => _IG3State();
}

class _IG3State extends State<IG3> {
  List<Etudiants> troisiemeAnnee = [];
  late DatabaseHelper handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper.instance;
    _getTroisiemeAnneeCount();
  }

  Future _getTroisiemeAnneeCount() async {
    final result = await handler.getEtudiantsTroisiemeAnnee();
    setState(() {
      troisiemeAnnee = result;
    });
  }

  int totalStudents() {
    return troisiemeAnnee.length;
  }

  int countMaleStudents() {
    return troisiemeAnnee
        .where((etudiant) => etudiant.sexe == 'Masculin')
        .length;
  }

  int countFemaleStudents() {
    return troisiemeAnnee
        .where((etudiant) => etudiant.sexe == 'Féminin')
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        centerTitle: true,
        title: const Text(
          "IG3",
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          const MyDrawer(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCard(
                      type1: "Femmes",
                      type2: "Hommes",
                      element: "ETUDIANTS",
                      iconele: "assets/images/etudiants.png",
                      nbretype1: countFemaleStudents(),
                      nombretype2: countMaleStudents(),
                      color: Colors.red.shade700,
                      totalele: totalStudents(),
                    ),
                    MyCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ModulesPremiereSemestre(),
                              ));
                        },
                        type1: "Pratiques",
                        type2: "Littéraires",
                        element: "SEMESTRES 1",
                        iconele: "assets/images/cours.png",
                        nbretype1: 5,
                        nombretype2: 9,
                        color: Colors.green.shade700,
                        totalele: 14),
                    MyCard(
                        onTap: () {},
                        type1: "Pratiques",
                        type2: "Littéraires",
                        element: "SEMESTRES 2",
                        iconele: "assets/images/cours.png",
                        nbretype1: 311,
                        nombretype2: 212,
                        color: Colors.green.shade700,
                        totalele: 523),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: troisiemeAnnee.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucune personne n\'est ajoutée pour l\'instant',
                          ),
                        )
                      : builListView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView builListView() {
    return ListView.separated(
      itemCount: troisiemeAnnee.length,
      itemBuilder: (context, index) {
        final troisieme = troisiemeAnnee.elementAt(index);
        final item = troisiemeAnnee.elementAt(index).nom;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          child: getLisTile(index, context, item),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.red,
      ),
    );
  }

  ListTile getLisTile(int index, BuildContext context, String item) {
    Etudiants troisieme = troisiemeAnnee[index];
    return ListTile(
      title: Text("${troisieme.prenom} ${troisieme.nom}",
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(troisieme.niveau),
      leading: CircleAvatar(
        backgroundImage: FileImage(File(troisieme.image_path)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.blue),
            onPressed: () {
              // Display more information
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Delete action
            },
          ),
        ],
      ),
      onTap: () {
        // Detailed view or action
      },
    );
  }
}
