import 'package:flutter/material.dart';

class IncidentCard extends StatelessWidget {
  final String type;
  final String description;
  final String location;
  final String date;
  final String image;

  const IncidentCard(
      {super.key,
      required this.type,
      required this.description,
      required this.location,
      required this.date,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Text(
                  location,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6200EE),
                ),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('SEE IN MAP'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
