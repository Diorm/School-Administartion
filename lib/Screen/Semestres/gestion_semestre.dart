import 'package:flutter/material.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/modele_semestre.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class GestionSemestre extends StatefulWidget {
  const GestionSemestre({super.key});

  @override
  _GestionSemestreState createState() => _GestionSemestreState();
}

class _GestionSemestreState extends State<GestionSemestre> {
  final _nomSemestre = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  late Future<List<Semestre>> semestre;

  // Supprimer un Semestre
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteSemestre(id);
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

  Future<List<Semestre>> _fetchSession() async {
    final semestre = await dbHelper.getSemestres();
    return semestre;
  }

  Future<void> _onRefresh() async {
    setState(() {
      semestre = _fetchSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        centerTitle: true,
        title: const Text(
          "SEMESTRES",
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
          const SizedBox(width: 10),
          Expanded(
            child: FutureBuilder(
              future: dbHelper.getSemestres(), // Votre future ici
              builder: (BuildContext context,
                  AsyncSnapshot<List<Semestre>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Aucun Semestre trouvée !!!"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Semestre> items = snapshot.data ?? <Semestre>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Semestre semestre =
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
                              backgroundColor: myredColor,
                              radius: 30,
                              child: Text(
                                semestre.id.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            title: Text("Semestre ${semestre.id}"),
                            titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                            trailing: IconButton(
                              onPressed: () {
                                delete(semestre.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: myredColor,
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => DetailEtudiant(
                              //       etudiant: etudiant,
                              //     ),
                              //   ),
                              // );
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSemestre();
        },
        backgroundColor: myblueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _saveSemestre() async {
    if (_nomSemestre.text.isNotEmpty) {
      final semestre = Semestre(nomSemestre: _nomSemestre.text);
      await dbHelper.insertSemestre(semestre);
      _nomSemestre.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Enregistrement effectué avec succès"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {}); // Refresh to show updated sessions
                },
                child: const Text(
                  'OK',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void addSemestre() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle Semestre"),
          content: Form(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _nomSemestre,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le champ ne doit pas être vide";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Nom Semestre",
                prefixIcon: const Icon(Icons.timeline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveSemestre();
              },
              child: Text(
                'Enregistrer',
                style: TextStyle(color: myblueColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
