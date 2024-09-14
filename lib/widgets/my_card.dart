import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String element;
  final int totalele;
  final String iconele;
  final int nbretype1;
  final int nombretype2;
  final String type1;
  final String type2;
  final Color color;
  final void Function()? onTap;

  const MyCard({
    super.key,
    required this.element,
    required this.iconele,
    required this.nbretype1,
    required this.nombretype2,
    required this.color,
    required this.totalele,
    required this.type1,
    required this.type2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 200,
          width: 300,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    iconele,
                    height: 50,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                totalele.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTypeInfo(nbretype1, type1),
                  _buildTypeInfo(nombretype2, type2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeInfo(int count, String type) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          type,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
