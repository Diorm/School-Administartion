import 'package:flutter/material.dart';
import 'package:school_administration/Screen/filieres/IG/Licence3/licence3.dart';
import 'package:school_administration/theme/colors.dart';
import 'package:school_administration/widgets/Filiere_card.dart';
import 'package:school_administration/widgets/my_drawer.dart';

class Licences extends StatelessWidget {
  const Licences({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: myblueColor,
        title: const Text(
          " Licences",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          const MyDrawer(),
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  FiliereCard(
                    modules: 14,
                    imagePath: "assets/images/manager.png",
                    nom: "IG1",
                    onTap: () {},
                  ),
                  FiliereCard(
                    modules: 14,
                    imagePath: "assets/images/bd.png",
                    nom: "IG2",
                    onTap: () {},
                  ),
                  FiliereCard(
                    modules: 14,
                    imagePath: "assets/images/coding.png",
                    nom: "IG3",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IG3(),
                          ));
                    },
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
