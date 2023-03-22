import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';

class IncidentView extends StatelessWidget {
  const IncidentView(
      {super.key,
      required this.documentId,
      required this.date,
      required this.type,
      required this.loc,
      required this.desc,
      required this.img});

  final String documentId;
  final String date;
  final String type;
  final String loc;
  final String desc;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  bool? isConfirmed = await _promptToConfirm(context);

                  if (!isConfirmed!) return;

                  final incidentService = FirebaseCloudStorage();
                  await incidentService.updateReportCount(
                      documentId: documentId);
                },
                icon: const Icon(Icons.flag_outlined))
          ],
          title: Text(
            date,
            style: const TextStyle(fontSize: 20),
          ),
          elevation: 0.0),
      body: Stack(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: img,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(loc,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 43, fontWeight: FontWeight.bold)),
                Text(type, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 30),
                AutoSizeText(
                  desc,
                  maxLines: 15,
                  maxFontSize: 18,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _promptToConfirm(context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Report Incident'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to report this incident?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
