import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({super.key, required this.titleText, required this.valueText});
  final String titleText;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).primaryColor),
            children: <TextSpan>[
              TextSpan(
                text: '$titleText: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: valueText),
            ],
          ),
        ));
  }
}
