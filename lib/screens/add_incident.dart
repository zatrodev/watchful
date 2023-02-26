import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:watchful/services/cloud/cloud_storage_constants.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';
import 'package:watchful/utilities/utils.dart';
import 'package:watchful/widgets/image_placeholder.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({Key? key}) : super(key: key);

  @override
  State<AddIncidentPage> createState() {
    return _AddIncidentPageState();
  }
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  late final FirebaseCloudStorage service;

  final _formKey = GlobalKey<FormBuilderState>();
  File? _img;

  @override
  void initState() {
    service = FirebaseCloudStorage();
    super.initState();
  }

  Future<void> submitIncident() async {
    final date = _formKey.currentState!.value[dateFieldName];
    final desc = _formKey.currentState!.value[descFieldName];
    final loc = _formKey.currentState!.value[locFieldName];
    final type = _formKey.currentState!.value[typeFieldName];

    final formattedDate =
        "${intToMonth(date.month)} ${date.day} | ${DateFormat('hh:mm a').format(date)}";

    await service.createIncident(
        ownerUserId: FirebaseAuth.instance.currentUser!.uid,
        date: formattedDate,
        desc: desc,
        img: _img,
        loc: loc,
        type: type);

    final Telephony telephony = Telephony.instance;
    final phoneNumbers = await service.getAllNumbers();

    for (final phoneNumber in phoneNumbers) {
      telephony.sendSms(
          to: phoneNumber,
          message:
              "INCIDENT REPORT \n\n A $type occurred in $formattedDate at $loc. The reported said, '$desc'. \n\n Take care.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "NEW REPORT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImagePlaceholder(
                onTap: () async {
                  XFile? xImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);

                  setState(() {
                    _img = File(xImage!.path);
                  });
                },
                image: _img,
              ),
              FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  log(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'type',
                      decoration: const InputDecoration(
                        labelText: 'Type of Incident',
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'desc',
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'loc',
                      decoration: const InputDecoration(
                        labelText: 'Location',
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['date']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          submitIncident().then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();

                        setState(() {
                          _img = null;
                        });
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
