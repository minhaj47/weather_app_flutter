import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String propertyName;
  final String value;
  const AdditionalInfoCard({
    super.key,
    required this.icon,
    required this.propertyName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          Text(
            propertyName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
