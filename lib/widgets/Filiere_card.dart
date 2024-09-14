import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FiliereCard extends StatelessWidget {
  final String nom;
  final String imagePath;
  final int modules;
  final void Function()? onTap;

  const FiliereCard({
    super.key,
    required this.nom,
    required this.imagePath,
    required this.onTap,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        width: 250, // Définir une largeur fixe pour chaque carte
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                nom,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center, // Centrer le texte
              ),
            ],
          ),
        ),
      ),
    );
  }
}
