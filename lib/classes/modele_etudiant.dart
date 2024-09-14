class Etudiants {
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
  final String niveau;
  final String session;
  final String filiere_choisie;

  Etudiants({
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
    required this.niveau,
    required this.session,
    required this.filiere_choisie,
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
      'niveau': niveau,
      'session': session,
      'filiere_choisie': filiere_choisie,
    };
  }

  factory Etudiants.fromMap(Map<String, dynamic> map) {
    return Etudiants(
      session: map['session'],
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
      niveau: map['niveau'],
      filiere_choisie: map['filiere_choisie'],
    );
  }
}
