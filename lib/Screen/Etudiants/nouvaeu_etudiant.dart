import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_administration/Screen/Etudiants/list_etudiants.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/model_session.dart';
import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/theme/colors.dart';

class NouveauEtudiant extends StatefulWidget {
  const NouveauEtudiant({super.key});

  @override
  State<NouveauEtudiant> createState() => _NouveauEtudiantState();
}

class _NouveauEtudiantState extends State<NouveauEtudiant> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  final List<String> niveaux = [
    'Licence 1',
    'Licence 2',
    'Licence 3',
  ];
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
      RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(input);
  bool isPhone(String input) => RegExp(r'^[0-9]{9}$').hasMatch(input);
  //Mes Controllers

  final _adresseEditController = TextEditingController();
  final _nomEditController = TextEditingController();
  final _cniEditController = TextEditingController();
  final _ineEditController = TextEditingController();

  final _prenomEditController = TextEditingController();
  final _telephoneEditController = TextEditingController();
  final _emailEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Aucune Image insérée");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSession(); // Charger les sessions existantes
  }

  Future<List<Session>> _fetchSession() async {
    final sessions = await dbHelper.getSessions();
    return sessions;
  }

  CountryCode? selectedCountry;
  String sexeValue = 'Masculin';
  String? _selectedGender;
  DateTime? _selectedDate;
  int _index = 0;
  int value = 1;
  int selectedOption = 1;

  List<Step> stepList() => [
        Step(
          state: _index > 0 ? StepState.complete : StepState.indexed,
          isActive: _index >= 0,
          title: const Text("Information Personnelle"),
          content: personalInfoStep(),
        ),
        Step(
          state: _index > 1 ? StepState.complete : StepState.indexed,
          isActive: _index >= 1,
          title: const Text("Information Académique"),
          content: academicInfoStep(),
        ),
      ];

  void _incrementStepper() {
    if (_formKey.currentState!.validate()) {
      if (_index < 2) {
        setState(() {
          _index++;
        });
      } else {
        // Logique de soumission finale
        print("Formulaire soumis");
      }
    }
  }

  void _decrementStepper() {
    if (_index > 0) {
      setState(() {
        _index--;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      _index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        title: const Text(
          "NOUVEAU ÉTUDIANT",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: myredColor,
          ),
        ),
        child: Stepper(
          controlsBuilder: (context, details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_index > 0)
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text("Retour"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_index == stepList().length - 1) {
                      _submit(); // Appel à la méthode submit lors de la dernière étape
                    } else {
                      details.onStepContinue?.call();
                    }
                  },
                  child: Text(_index == stepList().length - 1
                      ? "Confirmer"
                      : "Suivant"),
                ),
              ],
            );
          },
          onStepTapped: onStepTapped,
          onStepContinue: _incrementStepper,
          onStepCancel: _decrementStepper,
          currentStep: _index,
          elevation: 0,
          steps: stepList(),
          type: StepperType.horizontal,
        ),
      ),
    );
  }

  Widget academicInfoStep() {
    return Container(
      padding: const EdgeInsets.all(45),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Autres options académiques (exemples)
          const Text("Choisissez votre filière:"),
          _buildOptionCard(1, 'Licence en Science de gestion', Icons.business),
          _buildOptionCard(
              2, 'Licence en Informatique de Gestion', Icons.computer),
          _buildOptionCard(
              3, 'Licence en Comptabilité et Finance', Icons.attach_money),
          _buildOptionCard(4, 'Licence en Science Politique', Icons.gavel),
          _buildOptionCard(5, 'Licence en Qualité Hygiène',
              Icons.cleaning_services_outlined),
          const SizedBox(height: 15),

          // Dropdown pour sélectionner le niveau
          DropdownButtonFormField<String>(
            value: selectedNiveau,
            decoration: const InputDecoration(
              labelText: "Sélectionner un Niveau",
              border: OutlineInputBorder(),
            ),
            items: niveaux.map((niveau) {
              return DropdownMenuItem<String>(
                value: niveau,
                child: Text(niveau),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedNiveau = value; // Mettre à jour le niveau sélectionné
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Veuillez sélectionner un niveau';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // FutureBuilder for sessions dropdown
          FutureBuilder<List<Session>>(
            future: dbHelper.getSessions(), // Fetch sessions from the database
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final sessions = snapshot.data!; // Get the list of sessions
                return DropdownButtonFormField<String>(
                  value: selectedSession,
                  decoration: const InputDecoration(
                    labelText: "Sélectionner une Session",
                    border: OutlineInputBorder(),
                  ),
                  items: sessions.map((session) {
                    return DropdownMenuItem<String>(
                      value: session
                          .nomSession, // Use a unique identifier for value
                      child:
                          Text(session.nomSession), // Display the session name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSession = value; // Update the selected session
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Veuillez sélectionner une session';
                  //   }
                  //   return null;
                  // },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "le champs ne doit pas etre vide";
                    }
                    return null;
                  },
                );
              } else {
                return const Center(child: Text("Aucune session trouvée."));
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int value, String title, IconData icon) {
    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: selectedOption == value ? myredColor : myblueColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selectedOption == value ? myredColor : Colors.black,
            ),
          ),
          trailing: Radio<int>(
            value: value,
            groupValue: selectedOption,
            activeColor: myredColor,
            onChanged: (int? newValue) {
              setState(() {
                selectedOption = newValue!;
              });
            },
          ),
          onTap: () {
            setState(() {
              selectedOption = value;
            });
          },
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final etudiant = Etudiants(
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
        filiere_choisie: programOptions[
            selectedOption - 1], // Utilisation du nom du programme
        niveau: selectedNiveau ?? 'Licence 1', // Ajout du niveau sélectionné
        session: selectedSession ?? '2023/2024',
      );

      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertEtudiants(etudiant);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Enregistrement effectué avec succès"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListEtudiants()),
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

      print('Étudiant ajouté avec succès');
    }
  }

//First Steps Info Personnelle
  Widget personalInfoStep() {
    return Padding(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo profil et logo
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
                                    child:
                                        Image.asset("assets/images/profil.png"),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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

                const SizedBox(height: 16),
                // prenom ,Nom Sexe
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "le champs ne doit pas etre vide";
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
                            return "le champs ne doit pas etre vide";
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
                                  Radio<String>(
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
                                  Radio<String>(
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                // Address et Email
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "le champs ne doit pas etre vide";
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
                            return "le champ ne doit pas être vide";
                          }
                          if (!isEmail(value)) {
                            return "e-mail invalide";
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
                            return "le champs ne doit pas etre vide";
                          }
                          return null;
                        },
                        controller: _cniEditController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "CNI",
                          prefixIcon: const Icon(Icons.assignment_ind_rounded),
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
                            return "le champs ne doit pas etre vide";
                          }
                          return null;
                        },
                        controller: _ineEditController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "INE",
                          prefixIcon: const Icon(Icons.assignment_ind_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Phone and Email
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
                            return "le champ ne doit pas être vide";
                          }
                          if (!isPhone(value)) {
                            return "numéro téléphone invalide";
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
                            return "le champs ne doit pas etre vide";
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
