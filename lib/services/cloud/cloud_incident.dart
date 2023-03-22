import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchful/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudIncident {
  final String ownerUserId;
  final String documentId;
  final String date;
  final String desc;
  final String img;
  final String loc;
  final String type;
  final int reportCount;

  const CloudIncident(
      {required this.documentId,
      required this.ownerUserId,
      required this.date,
      required this.desc,
      required this.img,
      required this.loc,
      required this.type,
      required this.reportCount});

  CloudIncident.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()![ownerUserFieldName],
        date = snapshot.data()![dateFieldName] as String,
        desc = snapshot.data()![descFieldName] as String,
        img = snapshot.data()![imgFieldName] as String,
        loc = snapshot.data()![locFieldName] as String,
        type = snapshot.data()![typeFieldName] as String,
        reportCount = snapshot.data()![reportFieldName];
}
