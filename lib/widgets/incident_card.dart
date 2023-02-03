import 'package:flutter/material.dart';

class IncidentCard extends StatelessWidget {
  final String type;
  final String desc;
  final String loc;
  final String date;
  final String img;

  const IncidentCard(
      {super.key,
      required this.type,
      required this.desc,
      required this.loc,
      required this.date,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.warning,
            ),
            title: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  date,
                ),
              ],
            ),
            isThreeLine: true,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(img),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              desc,
              textAlign: TextAlign.justify,
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.start,
          //   children: [
          //     TextButton(
          //       onPressed: () {
          //         // Perform some action
          //       },
          //       child: const Text('SEE IN MAP'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
