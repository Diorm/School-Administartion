import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:school_administration/Screen/Professeurs/list_professeurs.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/model_professeurs.dart';
import 'package:school_administration/classes/model_session.dart';
import 'package:school_administration/classes/modele_module.dart';
import 'package:school_administration/theme/colors.dart';

class NouveauProfesseur extends StatefulWidget {
  const NouveauProfesseur({super.key});

  @override
  State createState() => _NouveauProfesseurState();
}

class _NouveauProfesseurState extends State<NouveauProfesseur> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  String? selectedNiveau;
  bool _passwordInVisible = true;

  final List<String> programOptions = [
    'Licence en Science de gestion',
    'Licence en Informatique de Gestion',
    'Licence en Comptabilité et Finance',
    'Licence en Science Politique',
    'Licence en Qualité Hygiène',
  ];

  String? selectedSession;
  late Future<List<Session>> sessions;

  bool isEmail(String input) =>
      RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]").hasMatch(input);
  bool isPhone(String input) => RegExp(r'^[0-9]{9}$').hasMatch(input);

  // Controllers
  final _adresseEditController = TextEditingController();
  final _nomEditController = TextEditingController();
  final _cniEditController = TextEditingController();
  final _ineEditController = TextEditingController();
  final _prenomEditController = TextEditingController();
  final _telephoneEditController = TextEditingController();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();

  Future<List<Module>> fetchAvailableModules() async {
    return await dbHelper.getModules();
  }

// In your state class, add a variable to hold selected modules
  List<Module> selectedModules = [];

  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future<void> getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Aucune image insérée");
      }
    });
  }

  Future<List<Module>> getModulesProfs(int profId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''SELECT m.* FROM modules m INNER JOIN prof_modules pm ON m.id = pm.moduleId WHERE pm.profId = ?''',
      [profId],
    );
    return List.generate(maps.length, (i) {
      return Module.fromMap(maps[i]);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfesseurs();
  }

  Future<void> _fetchProfesseurs() async {
    sessions = dbHelper.getSessions();
  }

  CountryCode? selectedCountry;
  String sexeValue = 'Masculin';
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        title: const Text(
          "NOUVEAU PROFESSEUR",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile photo and logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: getImageGallery,
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _image!.absolute,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Image.asset(
                                            "assets/images/profil.png"),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: getImageGallery,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myblueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Choisir une Photo",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        // Logo
                        Padding(
                          padding: const EdgeInsets.only(right: 70.0),
                          child: Image.asset("assets/images/ucao.png"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // First name, Last name, Gender
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _prenomEditController,
                            decoration: InputDecoration(
                              labelText: "Prénom",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _nomEditController,
                            decoration: InputDecoration(
                              labelText: "Nom",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Sexe",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 'Masculin',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value!;
                                          });
                                        },
                                      ),
                                      const Text('Masculin'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 'Féminin',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value!;
                                          });
                                        },
                                      ),
                                      const Text('Féminin'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Date of Birth and Country
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 10),
                                  Text(
                                    _selectedDate == null
                                        ? 'Sélectionnez une date'
                                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                setState(() {
                                  selectedCountry = countryCode;
                                });
                              },
                              initialSelection: 'SN',
                              favorite: const ['+221'],
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: true,
                              alignLeft: true,
                              textStyle: const TextStyle(fontSize: 16),
                              searchDecoration: const InputDecoration(
                                labelText: 'Search',
                                hintText: 'Search country',
                                border: OutlineInputBorder(),
                              ),
                              dialogTextStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Address and Email
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _adresseEditController,
                            decoration: InputDecoration(
                              labelText: "Adresse",
                              prefixIcon: const Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _emailEditController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              if (!isEmail(value)) {
                                return "E-mail invalide";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // CNI and INE
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _cniEditController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "CNI",
                              prefixIcon:
                                  const Icon(Icons.assignment_ind_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _ineEditController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "INE",
                              prefixIcon:
                                  const Icon(Icons.assignment_ind_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Phone and Password
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _telephoneEditController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const CountryCodePicker(
                                initialSelection: 'SN',
                                favorite: ["+221"],
                                showFlag: true,
                              ),
                              labelText: 'Numéro téléphone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              if (!isPhone(value)) {
                                return "Numéro téléphone invalide";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            obscureText: _passwordInVisible,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Le champ ne doit pas être vide";
                              }
                              return null;
                            },
                            controller: _passwordEditController,
                            decoration: InputDecoration(
                              labelText: "Mot de Passe",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordInVisible = !_passwordInVisible;
                                  });
                                },
                                icon: Icon(_passwordInVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Selection des modules
                    // Widget de sélection des modules
                    FutureBuilder<List<Module>>(
                      future: fetchAvailableModules(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MultiSelectDialogField(
                                selectedColor: myblueColor,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                items: snapshot.data!
                                    .map((module) => MultiSelectItem(
                                        module, module.nomModule))
                                    .toList(),
                                title: const Text("Modules"),
                                initialValue:
                                    selectedModules, // Use initialValue
                                onConfirm: (values) {
                                  setState(() {
                                    selectedModules = values.cast<Module>();
                                    print("Selected modules: $selectedModules");
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text("Modules sélectionnés:"),
                              Wrap(
                                spacing: 8.0,
                                children: selectedModules.map((module) {
                                  return Chip(
                                    label: Text(module.nomModule),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        } else {
                          return const Text("Aucun module disponible");
                        }
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // Submit button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(myblueColor)),
                          onPressed: _submit,
                          child: const Text(
                            "Soumettre",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Module>> _getModules() async {
    List<Module> modules = await dbHelper.getModules();
    print("Modules fetched: $modules");
    return modules;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (selectedModules.isEmpty) {
        _showErrorDialog("Please select at least one module.");
        return;
      }

      // Create the Professeurs instance with the required parameters
      final prof = Professeurs(
        prenom: _prenomEditController.text,
        nom: _nomEditController.text,
        adresse: _adresseEditController.text,
        telephone: _telephoneEditController.text,
        sexe: _selectedGender ?? 'Masculin',
        email: _emailEditController.text,
        password: _passwordEditController.text,
        date_naissance: _selectedDate ?? DateTime.now(),
        image_path: _image?.path ?? '',
        pays_de_naissance: selectedCountry?.name ?? 'Unknown',
        cni: int.tryParse(_cniEditController.text) ?? 0,
        ine: int.tryParse(_ineEditController.text) ?? 0,
        modules_enseignes: selectedModules,
      );

      try {
        int profId = await dbHelper.insertProfesseur(prof);
        for (Module module in selectedModules) {
          await dbHelper.insertProfesseurModule(profId, module.id!);
        }

        _showSuccessDialog("Enregistrement effectué avec succès");
        print('Professeur ajouté avec succès');
        print("Fetched professors: $selectedModules"
            .toString()); // Debugging line
      } catch (e) {
        print("Error inserting professeur: $e");
        _showErrorDialog("An error occurred: $e");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListProfesseurs(),
                  ),
                );
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
