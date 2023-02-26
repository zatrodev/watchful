import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

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
    return Center(
      child: TransparentImageCard(
        width: 400,
        height: 300,
        imageProvider: NetworkImage(img),
        tags: [Text(type)],
        title: Text(loc),
        description: Text(
          desc,
        ),
      ),
    );
  }
}
