import 'package:flutter/material.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/calender.dart';
import 'package:school_administration/widgets/my_card.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomePage({
    Key? key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Etudiants> listeEtudiants = [];

  @override
  void initState() {
    super.initState();
    getEtudiant();
  }

  void getEtudiant() async {
    final result = await DatabaseHelper.instance.getAllEtudiants();
    setState(() {
      listeEtudiants = result;
    });
    print("Nombre d'étudiants récupérés : ${listeEtudiants.length}");
  }

  int countMaleStudents() {
    return listeEtudiants
        .where((etudiant) => etudiant.sexe == 'Masculin')
        .length;
  }

  int countFemaleStudents() {
    return listeEtudiants
        .where((etudiant) => etudiant.sexe == 'Féminin')
        .length;
  }

  int totalStudents() {
    return listeEtudiants.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu Drawer
          const MyDrawer(),
          const SizedBox(
            width: 10,
          ), // espace entre le drawer et la colonne

          // Contenu de la page
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75.0, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText:
                          'Rechercher un Etudiant,une Classe,un Professeur...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Centre de la Page

              // 3 cards d'information
              //card pour afficher le total des etudiants et l'effectif total pour chaque categorie
              Row(
                children: [
                  MyCard(
                      type1: "Femmes",
                      type2: "Hommes",
                      element: "ETUDIANTS",
                      iconele: "assets/images/etudiants.png",
                      nbretype1: countFemaleStudents(),
                      nombretype2: countMaleStudents(),
                      color: Colors.red.shade700,
                      totalele: totalStudents()),
                  MyCard(
                      type1: "Femmes",
                      type2: "Hommes",
                      element: "PROFESSEURS",
                      iconele: "assets/images/teacher.png",
                      nbretype1: 17,
                      nombretype2: 12,
                      color: Colors.blue.shade700,
                      totalele: 29),
                  MyCard(
                      type1: "Pratiques",
                      type2: "Littéraires",
                      element: "MODULES",
                      iconele: "assets/images/cours.png",
                      nbretype1: 311,
                      nombretype2: 212,
                      color: Colors.green.shade700,
                      totalele: 523),
                ],
              ),
              const SizedBox(
                height: 40,
              ),

              //Text Meilleurs Eleves
              const Text(
                "Top Etudiants",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          //Un Grand Container sur la droite qui prend toute la longueur
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  // Container pour les informations du user
                  child: Container(
                      decoration: BoxDecoration(
                          color: myblueColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage("assets/images/alone.png"),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Ucao User",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "kanisalade43@gmail.com",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
                //Calendrier
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SamaCalendrier(),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
