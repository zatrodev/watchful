import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:watchful/widgets/incident_view.dart';

class IncidentCard extends StatelessWidget {
  final String documentId;
  final String type;
  final String desc;
  final String loc;
  final String date;
  final String img;
  final BuildContext context;

  const IncidentCard(
      {super.key,
      required this.documentId,
      required this.type,
      required this.desc,
      required this.loc,
      required this.date,
      required this.img,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullModal(context),
      child: Center(
        child: CachedNetworkImage(
          imageUrl: img,
          imageBuilder: (context, imageProvider) => TransparentImageCard(
            width: 400,
            height: 250,
            endColor: Colors.black.withOpacity(0.25),
            contentPadding: const EdgeInsets.only(left: 10, top: 42.5),
            imageProvider: imageProvider,
            tags: [_Tag(text: type)],
            title: Column(
              children: [
                AutoSizeText(
                  loc,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            description: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  _showFullModal(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible:
          false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: const Duration(
          milliseconds:
              500), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return IncidentView(
            documentId: documentId,
            date: date,
            type: type,
            loc: loc,
            desc: desc,
            img: img);
      },
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: const Color(0xFFFFDB58),
          borderRadius: BorderRadius.circular(
              8.0) // set background color of the container
          ),
      child: Text(
        text, // set text to be displayed inside the container
        style: const TextStyle(
            color: Colors.black, // set text color to white
            fontSize: 14,
            fontWeight: FontWeight.bold // set font size of the text
            ),
      ),
    );
  }
}
