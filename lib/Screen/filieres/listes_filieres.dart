import 'package:flutter/material.dart';
import 'package:school_administration/Screen/filieres/IG/licences.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/Filiere_card.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class ListesFilieres extends StatefulWidget {
  const ListesFilieres({super.key});

  @override
  _ListesFilieresState createState() => _ListesFilieresState();
}

class _ListesFilieresState extends State<ListesFilieres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        centerTitle: true,
        title: const Text(
          "Liste des Filières",
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut
        children: [
          const MyDrawer(),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start, // Alignement des enfants à gauche
              spacing: 10.0, // Espacement horizontal entre les cartes
              runSpacing: 10.0, // Espacement vertical entre les lignes
              children: [
                FiliereCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Licences(),
                      ),
                    );
                  },
                  modules: 16,
                  nom: "Informatique de Gestion",
                  imagePath: "assets/images/red.png",
                ),
                FiliereCard(
                  onTap: () {},
                  modules: 16,
                  nom: "Science de Gestion",
                  imagePath: "assets/images/gestion.png",
                ),
                FiliereCard(
                  onTap: () {},
                  modules: 16,
                  nom: "Comptabilité Finance",
                  imagePath: "assets/images/Finance.png",
                ),
                FiliereCard(
                  onTap: () {},
                  modules: 16,
                  nom: "Agro Business",
                  imagePath: "assets/images/agro.png",
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myredColor,
        onPressed: () {
          // Logique pour ajouter une nouvelle filière ou semestre
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
