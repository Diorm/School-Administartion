import 'dart:io';
import 'package:flutter/material.dart';
import 'package:school_administration/classes/model_professeurs.dart';
import 'package:school_administration/theme/colors.dart';

class DetailProfesseurs extends StatelessWidget {
  final Professeurs professeurs;

  const DetailProfesseurs({super.key, required this.professeurs});

  @override
  Widget build(BuildContext context) {
    // Debug print to verify the modules list
    print('Modules Enseignés: ${professeurs.modules_enseignes}');

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: myblueColor,
        title: Text(
          "${professeurs.prenom} ${professeurs.nom}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: professeurs.image_path.isEmpty
                              ? const AssetImage('assets/images/profil.png')
                              : FileImage(File(professeurs.image_path))
                                  as ImageProvider,
                          radius: 90,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${professeurs.prenom} ${professeurs.nom}",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow(
                        Icons.school,
                        "Modules Enseignés",
                        (professeurs.modules_enseignes?.isNotEmpty ?? false)
                            ? professeurs.modules_enseignes!
                                .map((module) => module.nomModule)
                                .join(', ')
                            : 'Aucun module',
                      ),
                      buildInfoRow(
                        Icons.grade,
                        "CNI",
                        professeurs.cni.toString(),
                      ),
                      buildInfoRow(
                        Icons.calendar_today,
                        "Adresse",
                        professeurs.adresse,
                      ),
                      buildInfoRow(
                        Icons.email,
                        "Email",
                        professeurs.email,
                      ),
                      buildInfoRow(
                        Icons.phone,
                        "Téléphone",
                        professeurs.telephone,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: myblueColor),
          const SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: myblueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
