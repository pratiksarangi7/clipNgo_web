import 'package:flutter/material.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({
    super.key,
    required this.text,
    required this.revData,
  });
  final String text;
  final int revData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Add rounded corners
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              const IconData(0xf05db,
                  fontFamily:
                      'MaterialIcons'), // Suitable icon (you can change this)
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹$revData/-", // Convert revData to a string
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
