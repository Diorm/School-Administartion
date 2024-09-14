import 'package:flutter/material.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/modele_module.dart';
import 'package:school_administration/classes/modele_semestre.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class ModulesPremiereSemestre extends StatefulWidget {
  const ModulesPremiereSemestre({super.key});

  @override
  State<ModulesPremiereSemestre> createState() =>
      _ModulesPremiereSemestreState();
}

class _ModulesPremiereSemestreState extends State<ModulesPremiereSemestre> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final _nomModuleController = TextEditingController();
  final _volumeHoraireController = TextEditingController();
  late Future<List<Module>> module;
  String? selectedSemestre;
  String? selectedFiliere;
  List<String> filieres = [
    'Licence en Informatique de Gestion',
    'Licence en Sciences de Gestion',
    'Licence en Comptabilite et Finance',
    'Licence en Agro Business Civil',
  ];

  @override
  void initState() {
    super.initState();
    _onRefresh(); // Initialisation de la récupération des modules
  }

  // Supprimer un Module
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteModule(id);
      if (res > 0) {
        _onRefresh();
      }
    } else {
      print("L'ID est nul et ne peut pas être supprimé.");
    }
  }

  Future<List<Module>> _fetchSession() async {
    final module = await dbHelper.getModules();
    return module;
  }

  Future<void> _onRefresh() async {
    setState(() {
      module = _fetchSession();
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
          "Modules du Premier Semestre",
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          const MyDrawer(),
          const SizedBox(width: 10),
          Expanded(
            child: FutureBuilder<List<Module>>(
              future: module,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Module>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun Modules trouvé !!!"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Module> items = snapshot.data ?? <Module>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Module module = items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(module.nomModule),
                            titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                            subtitle: Row(
                              children: [
                                const Text('Volume Horaire :'),
                                Text('${module.volumeHoraire.toString()}H')
                              ],
                            ),
                            subtitleTextStyle: TextStyle(
                                color: myredColor, fontWeight: FontWeight.bold),
                            trailing: IconButton(
                              onPressed: () {
                                delete(module.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: myredColor,
                              ),
                            ),
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
          addModule();
          _nomModuleController.clear();
          _volumeHoraireController.clear();
        },
        backgroundColor: myblueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Enregistrer un nouveau module
  void _saveModule() async {
    if (_nomModuleController.text.isNotEmpty &&
        _volumeHoraireController.text.isNotEmpty) {
      final module = Module(
          filiere: selectedFiliere ?? 'Licence en Informatique de Gestion',
          semestre: selectedSemestre ?? 'Semestre 1',
          nomModule: _nomModuleController.text,
          volumeHoraire: int.parse(_volumeHoraireController.text));
      await dbHelper.insertModule(module);
      _nomModuleController.clear();
      _volumeHoraireController.clear();
      _onRefresh(); // Rafraîchir la liste des modules après enregistrement

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Enregistrement effectué avec succès"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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

  void addModule() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un nouveau Module"),
          content: Form(
            child: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomModuleController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Le champ ne doit pas être vide";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nom du Module",
                        prefixIcon: const Icon(Icons.book),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _volumeHoraireController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Le champ ne doit pas être vide";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Volume Horaire",
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Semestre>>(
                      future: dbHelper.getSemestres(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Erreur: ${snapshot.error}'));
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          final semestre = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            value: selectedSemestre,
                            decoration: const InputDecoration(
                              labelText: "Sélectionner un Semestre",
                              border: OutlineInputBorder(),
                            ),
                            items: semestre.map((semestre) {
                              return DropdownMenuItem<String>(
                                value: semestre.nomSemestre,
                                child: Text(semestre.nomSemestre),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSemestre = value;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                          );
                        } else {
                          return const Center(
                              child: Text("Aucun semestre trouvé."));
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedFiliere,
                      decoration: const InputDecoration(
                        labelText: "Sélectionner une Filière",
                        border: OutlineInputBorder(),
                      ),
                      items: filieres.map((filiere) {
                        return DropdownMenuItem<String>(
                          value: filiere,
                          child: Text(filiere),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFiliere = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Le champ ne doit pas être vide";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(myredColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(myblueColor)),
              onPressed: () {
                _saveModule();
                Navigator.of(context).pop();
              },
              child: Text(
                "Enregistrer",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
