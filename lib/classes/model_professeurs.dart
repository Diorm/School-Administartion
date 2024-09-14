import 'package:school_administration/classes/modele_module.dart';

class Professeurs {
  final int? id;
  final String prenom;
  final String nom;
  final String adresse;
  final String telephone;
  final String sexe;
  final String email;
  final String password;
  final DateTime date_naissance;
  final String image_path;
  final String pays_de_naissance;
  final int cni;
  final int ine;
  List<Module>? modules_enseignes; // List for modules taught

  Professeurs({
    this.id,
    required this.prenom,
    required this.nom,
    required this.adresse,
    required this.telephone,
    required this.sexe,
    required this.email,
    required this.password,
    required this.date_naissance,
    required this.image_path,
    required this.pays_de_naissance,
    required this.cni,
    required this.ine,
    this.modules_enseignes, // Optional list of modules
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'sexe': sexe,
      'email': email,
      'password': password,
      'date_naissance': date_naissance.toIso8601String(),
      'image_path': image_path,
      'pays_de_naissance': pays_de_naissance,
      'cni': cni,
      'ine': ine,
      // Do not include modules_enseignes here
    };
  }

  factory Professeurs.fromMap(Map<String, dynamic> map) {
    return Professeurs(
      id: map['id'],
      prenom: map['prenom'],
      nom: map['nom'],
      adresse: map['adresse'],
      telephone: map['telephone'],
      sexe: map['sexe'],
      email: map['email'],
      password: map['password'],
      date_naissance: DateTime.parse(map['date_naissance']),
      image_path: map['image_path'],
      pays_de_naissance: map['pays_de_naissance'],
      cni: map['cni'],
      ine: map['ine'],
      // Initialize modules_enseignes as an empty list
      modules_enseignes: [], // Initialize empty or set later
    );
  }
}



//   factory Professeurs.fromMap(Map<String, dynamic> map) {
//     return Professeurs(
//       id: map['id'],
//       prenom: map['prenom'],
//       nom: map['nom'],
//       adresse: map['adresse'],
//       telephone: map['telephone'],
//       sexe: map['sexe'],
//       email: map['email'],
//       password: map['password'],
//       date_naissance: DateTime.parse(map['date_naissance']),
//       image_path: map['image_path'],
//       pays_de_naissance: map['pays_de_naissance'],
//       cni: map['cni'],
//       ine: map['ine'],
//       modules_enseignes: List<Module>.from(map['modules_enseignes']?.map(
//           (moduleMap) =>
//               Module.fromMap(moduleMap))), // Convert map to list of modules
//     );
//   }
// }