import 'package:conversion_units/conversion_units.dart';
import 'package:flutter/material.dart';

class HourlyForcastCard extends StatelessWidget {
  final String time;
  final double temparature;
  final IconData icon;

  const HourlyForcastCard({
    super.key,
    required this.temparature,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 140,
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Icon(
                icon,
                size: 33,
              ),
              const SizedBox(height: 8),
              Text(
                Kelvin.toCelsius(temparature).toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
