import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:watchful/helpers/loading_screen.dart';
import 'package:watchful/services/cloud/cloud_storage_constants.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';
import 'package:watchful/utilities/utils.dart';
import 'package:watchful/widgets/custom_snackbar.dart';
import 'package:watchful/widgets/image_placeholder.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({Key? key}) : super(key: key);

  @override
  State<AddIncidentPage> createState() {
    return _AddIncidentPageState();
  }
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  late final FirebaseCloudStorage _service;
  bool showLoading = false;

  String? _currentLocation;

  final _formKey = GlobalKey<FormBuilderState>();
  File? _img;

  @override
  void initState() {
    _service = FirebaseCloudStorage();
    super.initState();
  }

  Future<void> submitIncident(context) async {
    final date = _formKey.currentState!.value[dateFieldName];
    final desc = _formKey.currentState!.value[descFieldName];
    final loc = _formKey.currentState!.value[locFieldName];
    final type = _formKey.currentState!.value[typeFieldName];

    final formattedDate =
        "${intToMonth(date.month)} ${date.day} | ${DateFormat('hh:mm a').format(date)}";

    LoadingScreen().show(context: context, text: "Creating incident...");

    try {
      await _service.createIncident(
          ownerUserId: FirebaseAuth.instance.currentUser!.uid,
          date: formattedDate,
          desc: desc,
          img: _img,
          loc: loc,
          type: type);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: CustomSnackBar(errorText: e.message.toString())));
    }

    LoadingScreen().hide();

    bool? sendSMS = await _promptUserForSMS(context);

    if (!sendSMS!) return;

    LoadingScreen().show(context: context, text: "Sending SMS...");

    final Telephony telephony = Telephony.instance;
    final phoneNumbers = await _service.getAllNumbers();

    for (final phoneNumber in phoneNumbers) {
      telephony.sendSms(
          to: phoneNumber,
          message:
              "INCIDENT REPORT \n\n A $type occurred in $formattedDate at $loc. The reported incident said, '$desc'. \n\n Take care.");
    }

    LoadingScreen().hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "NEW REPORT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'type',
                      decoration: const InputDecoration(
                        labelText: 'Type of Incident',
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'desc',
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'loc',
                      decoration: InputDecoration(
                        hintText: 'Location',
                        prefixIcon: showLoading
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : null,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _formKey.currentState!.fields['loc']!.didChange("");

                            setState(() {
                              showLoading = true;
                            });

                            getCurrentLocation(context).then((location) {
                              _formKey.currentState!.fields['loc']!
                                  .didChange(location);

                              setState(() {
                                showLoading = false;
                              });
                            });
                          },
                          icon: const Icon(Icons.cloud_upload),
                        ),
                      ),
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.next,
                      initialValue: _currentLocation,
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
              const SizedBox(height: 34),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_img == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: CustomSnackBar(
                                  errorText:
                                      "Picture of the incident is required."),
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              elevation: 0,
                            ));

                            return;
                          }

                          submitIncident(context).then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
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

  Future<bool?> _promptUserForSMS(context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Send SMS'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Do you want to send this incident to other users through SMS?'),
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
