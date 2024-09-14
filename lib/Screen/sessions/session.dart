import 'package:flutter/material.dart';
import 'package:school_administration/Services/database_helpr.dart';
import 'package:school_administration/classes/model_session.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class GestionSessions extends StatefulWidget {
  const GestionSessions({super.key});

  @override
  _GestionSessionsState createState() => _GestionSessionsState();
}

class _GestionSessionsState extends State<GestionSessions> {
  final TextEditingController _sessionController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  String? selectedSession;
  late Future<List<Session>> session;

  // Supprimer un Etudiant
  void delete(int? id) async {
    if (id != null) {
      final res = await dbHelper.deleteSession(id);
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

  Future<List<Session>> _fetchSession() async {
    final session = await dbHelper.getSessions();
    return session;
  }

  Future<void> _onRefresh() async {
    setState(() {
      session = _fetchSession();
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
          "SESSIONS",
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
              future: dbHelper.getSessions(), // Votre future ici
              builder: (BuildContext context,
                  AsyncSnapshot<List<Session>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun Session trouvée !!!"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final List<Session> items = snapshot.data ?? <Session>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Session session =
                          items[index]; // Récupère un étudiant spécifique
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundColor: Colors.transparent,
                            //   radius: 30,
                            //   child: Text(
                            //     session.id.toString(),
                            //     style: TextStyle(
                            //         color: myredColor,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 20),
                            //   ),
                            // ),
                            title: Text("Session ${session.id}"),
                            titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                            subtitle: Text(session.nomSession),
                            subtitleTextStyle: TextStyle(
                                color: myredColor, fontWeight: FontWeight.bold),
                            trailing: IconButton(
                              onPressed: () {
                                delete(session.id);
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
          addSession();
        },
        backgroundColor: myblueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _saveSession() async {
    if (_sessionController.text.isNotEmpty) {
      final session = Session(nomSession: _sessionController.text);
      await dbHelper.insertSession(session);
      _sessionController.clear();

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

  void addSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle Session"),
          content: Form(
            child: TextFormField(
              controller: _sessionController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le champ ne doit pas être vide";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Session",
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
                _saveSession(); // Save the session and close the dialog
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
