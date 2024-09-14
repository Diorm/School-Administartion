import 'package:flutter/material.dart';
import 'package:school_administration/Screen/Etudiants/update_etudiant.dart';
import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/theme/colors.dart';

class DetailEtudiant extends StatelessWidget {
  final Etudiants etudiant;

  const DetailEtudiant({super.key, required this.etudiant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: myblueColor,
        title: Text(
          "${etudiant.prenom} ${etudiant.nom}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateEtudiant(
                          etudiant: etudiant,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        "Modifier",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
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
                          // ignore: unnecessary_null_comparison
                          backgroundImage: etudiant.image_path == null
                              ? const AssetImage('assets/images/profil.png')
                              : AssetImage(etudiant.image_path),
                          radius: 90,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${etudiant.prenom} ${etudiant.nom}",
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
                      buildInfoRow(Icons.school, "Filière",
                          etudiant.filiere_choisie.toString()),
                      buildInfoRow(
                          Icons.grade, "Niveau", etudiant.niveau.toString()),
                      buildInfoRow(Icons.calendar_today, "Session",
                          etudiant.session.toString()),
                      buildInfoRow(
                          Icons.email, "Email", etudiant.email.toString()),
                      buildInfoRow(Icons.phone, "Téléphone",
                          etudiant.telephone.toString()),
                      buildInfoRow(Icons.location_city, "Adresse",
                          etudiant.adresse.toString()),
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
