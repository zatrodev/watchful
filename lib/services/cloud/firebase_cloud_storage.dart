import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:watchful/services/cloud/cloud_incident.dart';
import 'package:watchful/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final _phone = FirebaseFirestore.instance.collection("phone");
  final _incidents = FirebaseFirestore.instance.collection("incidents");

  Stream<Iterable<CloudIncident>> allIncidents() => _incidents
      .snapshots()
      .map((event) => event.docs.map((doc) => CloudIncident.fromSnapshot(doc)));

  Future<Iterable<CloudIncident>> getAllIncidents() async {
    try {
      return await _incidents.get().then(
          (value) => value.docs.map((doc) => CloudIncident.fromSnapshot(doc)));
    } catch (e) {
      throw Exception();
    }
  }

  Future<Iterable<String>> getAllNumbers() async {
    try {
      return await _phone.get().then(
          (value) => value.docs.map((doc) => doc.data()[numberFieldName]));
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> addNumber(number) async {
    try {
      await _phone.add({numberFieldName: number});
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> deleteIncident({required String documentId}) async {
    try {
      await _incidents.doc(documentId).delete();
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> updateReportCount({required String documentId}) async {
    log(documentId.toString());
    try {
      await _incidents.doc(documentId).get().then((doc) async {
        final data = CloudIncident.fromSnapshot(doc);
        await _incidents
            .doc(documentId)
            .update({reportFieldName: data.reportCount + 1});
      });
    } catch (e) {
      throw Exception();
    }
  }

  Future<CloudIncident> createIncident(
      {required String ownerUserId,
      required String date,
      required String desc,
      required File? img,
      required String loc,
      required String type}) async {
    final storageRef = FirebaseStorage.instance.ref().child('images/$img');
    await storageRef.putFile(img!);

    final imgDownloadUrl = await storageRef.getDownloadURL();

    final document = await _incidents.add({
      ownerUserFieldName: ownerUserId,
      dateFieldName: date,
      descFieldName: desc,
      imgFieldName: imgDownloadUrl,
      locFieldName: loc,
      typeFieldName: type,
      reportFieldName: 0
    });

    final fetchedIncident = await document.get();

    return CloudIncident(
        documentId: fetchedIncident.id,
        ownerUserId: ownerUserId,
        date: date,
        desc: desc,
        img: imgDownloadUrl,
        loc: loc,
        type: type,
        reportCount: 0);
  }

  static final FirebaseCloudStorage _instance =
      FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _instance;

  FirebaseCloudStorage._sharedInstance();
}
