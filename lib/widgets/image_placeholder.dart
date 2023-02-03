import 'dart:io';
import 'package:flutter/material.dart';

class ImagePlaceholder extends StatefulWidget {
  final VoidCallback? onTap;
  final File? image;

  const ImagePlaceholder({Key? key, required this.onTap, required this.image})
      : super(key: key);

  @override
  State<ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: InkWell(
          onTap: widget.onTap,
          child: widget.image == null
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
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(-3.14 / 2),
                  child: Container(
                      height: 300,
                      width: 300,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: FileImage(widget.image!)),
                      )),
                ),
        ));
  }
}
