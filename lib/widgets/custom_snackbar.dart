import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFF8B0000),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oops Error!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    AutoSizeText(
                      errorText,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      minFontSize: 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Positioned(
            bottom: 25,
            left: 20,
            child: ClipRRect(
              child: Icon(
                Icons.circle,
                color: Color(0xFFFFDB58),
                size: 17,
              ),
            )),
      ],
    );
  }
}
