import 'package:path/path.dart';
import 'package:school_administration/classes/model_professeurs.dart';
import 'package:school_administration/classes/model_session.dart';

import 'package:school_administration/classes/modele_etudiant.dart';
import 'package:school_administration/classes/modele_module.dart';
import 'package:school_administration/classes/modele_semestre.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static const _databaseName = "school.db";
  static const _databaseVersion = 2;

  static const table = 'etudiants';
  static const tableSessions = 'sessions';
  static const tableSemestres = 'semestres';
  static const tableProfesseurs = 'professeurs';
  static const tableModules = 'modules';
  static const tableModulesProfesseurs = 'modulesProfesseurs';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prenom TEXT NOT NULL,
        nom TEXT NOT NULL,
        adresse TEXT NOT NULL,
        telephone TEXT NOT NULL,
        sexe TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        date_naissance TEXT NOT NULL,
        image_path TEXT,
        pays_de_naissance TEXT NOT NULL,
        cni INTEGER NOT NULL,
        ine INTEGER NOT NULL,
        session TEXT NOT NULL,
        niveau TEXT NOT NULL,
        filiere_choisie TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableSessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomSession TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableModules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomModule TEXT NOT NULL,
        volumeHoraire INTEGER NOT NULL,
        semestre TEXT NOT NULL,
        filiere TEXT NOT NULL


      )
    ''');
    await db.execute('''
      CREATE TABLE $tableSemestres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomSemestre TEXT NOT NULL


      )
    ''');
    await db.execute('''
    CREATE TABLE $tableProfesseurs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      prenom TEXT NOT NULL,
      nom TEXT NOT NULL,
      adresse TEXT NOT NULL,
      telephone TEXT NOT NULL,
      sexe TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      date_naissance TEXT NOT NULL,
      image_path TEXT,
      pays_de_naissance TEXT NOT NULL,
      cni INTEGER NOT NULL,
      ine INTEGER NOT NULL
    )
  ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS professeurs_modules (
      profId INTEGER,
      moduleId INTEGER,
      PRIMARY KEY (profId, moduleId),
      FOREIGN KEY (profId) REFERENCES professeurs (id),
      FOREIGN KEY (moduleId) REFERENCES modules (id)
    )
  ''');
  }

//Create
  Future<int> insertEtudiants(Etudiants etudiant) async {
    Database db = await instance.database;
    return await db.insert(table, etudiant.toMap());
  }

  //Update
  Future<int> updateEtudiants(Etudiants etudiants) async {
    final db = await database;
    return await db.update(
      'etudiants',
      etudiants.toMap(),
      where: 'id = ?',
      whereArgs: [etudiants.id],
    );
  }

  // Méthode pour récupérer les étudiants correspondant aux critères
  Future<List<Etudiants>> getEtudiantsTroisiemeAnnee() async {
    final db = await instance.database; // Utilisation de `handler` ici
    final result = await db.rawQuery('''
      SELECT *
      FROM etudiants
      INNER JOIN sessions ON etudiants.session = sessions.nomSession
      WHERE etudiants.filiere_choisie = 'Licence en Informatique de Gestion'
      AND etudiants.niveau = 'Licence 3'
      
      ''');
    // AND sessions.nomSession = '2023/2024'

    return result.isNotEmpty
        ? result.map((e) => Etudiants.fromMap(e)).toList()
        : [];
  }

  Future<List<Etudiants>> getAllEtudiants() async {
    final db = await database;
    final result = await db.query('etudiants'); // Récupère tous les étudiants
    return result.isNotEmpty
        ? result.map((e) => Etudiants.fromMap(e)).toList()
        : [];
  }

  //Delete
  Future<int> deleteEtudiant(int id) async {
    final Database db = await instance.database;
    return db.delete("etudiants", where: "id= ? ", whereArgs: [id]);
  }

  //Gestion des sessions
  Future<List<Session>> getSessions() async {
    Database db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM sessions");

    if (res.isNotEmpty) {
      return res.map((c) => Session.fromMap(c)).toList();
    }
    return [];
  }

  Future<int> insertSession(Session session) async {
    Database db = await instance.database;
    return await db.insert('sessions', session.toMap());
  }

  Future<int> deleteSession(int id) async {
    Database db = await instance.database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  //Gestion des modules
  //Imsérer
  Future<int> insertModule(Module module) async {
    Database db = await instance.database;
    return await db.insert('modules', module.toMap());
  }

  //Recuperer les modules
  Future<List<Module>> getModules() async {
    Database db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM modules");

    if (res.isNotEmpty) {
      return res.map((c) => Module.fromMap(c)).toList();
    }
    return [];
  }

  //Supprimer
  Future<int> deleteModule(int id) async {
    Database db = await instance.database;
    return await db.delete('modules', where: 'id = ?', whereArgs: [id]);
  }

  //Gestion des Semestres
  Future<List<Semestre>> getSemestres() async {
    Database db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM semestres");

    if (res.isNotEmpty) {
      return res.map((c) => Semestre.fromMap(c)).toList();
    }
    return [];
  }

  Future<int> insertSemestre(Semestre semestre) async {
    Database db = await instance.database;
    return await db.insert('semestres', semestre.toMap());
  }

  Future<int> deleteSemestre(int id) async {
    Database db = await instance.database;
    return await db.delete('semestres', where: 'id = ?', whereArgs: [id]);
  }

  //Gestion des Professeurs
  //Create
  Future<int> insertProfesseur(Professeurs prof) async {
    Database db = await instance.database;
    // Convert Professeur object to Map for insertion
    return await db.insert(
      tableProfesseurs,
      prof.toMap(), // Ensure prof.toMap() does not include complex types
    );
  }

  Future<void> insertProfesseurModule(int profId, int moduleId) async {
    Database db = await instance.database;
    await db.insert(
      'professeurs_modules', // Ensure this is the correct table name
      {
        'profId': profId,
        'moduleId': moduleId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertProfesseurWithModules(
      Professeurs prof, List<Module> modules) async {
    final db = await instance.database;
    int profId = await db.insert(tableProfesseurs, prof.toMap());

    for (var module in modules) {
      await insertProfesseurModule(profId, module.id!);
    }

    return profId;
  }

  Future<Professeurs> getProfesseurWithModules(int profId) async {
    // Récupérer le professeur
    Professeurs prof = await getProfesseurById(profId);

    // Récupérer les modules associés
    List<Module> modules = await getModulesByProfesseurId(profId);

    // Associer les modules au professeur
    prof.modules_enseignes = modules;

    return prof;
  }

  Future<Professeurs> getProfesseurById(int profId) async {
    final db = await instance.database;
    final maps = await db.query(
      'professeurs',
      columns: [
        'id',
        'prenom',
        'nom',
        'adresse',
        'telephone',
        'sexe',
        'email',
        'password',
        'date_naissance',
        'image_path',
        'pays_de_naissance',
        'cni',
        'ine',
      ],
      where: 'id = ?',
      whereArgs: [profId],
    );

    if (maps.isNotEmpty) {
      return Professeurs.fromMap(maps.first);
    } else {
      throw Exception('Professeur not found');
    }
  }

  Future<List<Module>> getModulesByProfesseurId(int profId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT modules.*
    FROM modules
    INNER JOIN professeurs_modules ON modules.id = professeurs_modules.moduleId
    WHERE professeurs_modules.profId = ?
  ''', [profId]);

    return result.isNotEmpty
        ? result.map((map) => Module.fromMap(map)).toList()
        : [];
  }

  //Update professeur
  Future<int> updateProfesseurs(Professeurs prof) async {
    final db = await database;
    return await db.update(
      tableProfesseurs,
      prof.toMap(),
      where: 'id = ?',
      whereArgs: [prof.id],
    );
  }

  //Get
  Future<List<Professeurs>> getAllProfesseurs() async {
    final db = await database;
    final result = await db.query('professeurs'); // Ensure this table exists
    return result.isNotEmpty
        ? result.map((e) => Professeurs.fromMap(e)).toList()
        : []; // Return an empty list instead of null
  }

  //ModulesProfesseurs
  Future<int> deleteProfesseur(int id) async {
    final Database db = await instance.database;
    return db.delete("professeurs", where: 'id = ?', whereArgs: [id]);
  }
}
