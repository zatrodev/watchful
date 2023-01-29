import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePlaceholder extends StatefulWidget {
  const ImagePlaceholder({Key? key}) : super(key: key);

  @override
  State<ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: InkWell(
          onTap: () async {
            XFile? image =
                await ImagePicker().pickImage(source: ImageSource.camera);
            setState(() {
              imagePath = image!.path;
            });
          },
          child: imagePath == null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attach Picture',
                        style:
                            TextStyle(fontSize: 17.0, color: Colors.grey[600]),
                      ),
                      Icon(
                        Icons.photo_camera,
                        color: Colors.indigo[400],
                      )
                    ],
                  ),
                )
              : Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: FileImage(File(imagePath!))),
                  )),
        ));
  }
}
