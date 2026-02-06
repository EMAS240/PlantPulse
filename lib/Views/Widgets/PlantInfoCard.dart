import 'package:flutter/material.dart';

class PlantInfoCard extends StatelessWidget {
  final String imageUrl;
  final String description;

  const PlantInfoCard({
    Key? key,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
