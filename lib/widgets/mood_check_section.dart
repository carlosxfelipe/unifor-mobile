import 'package:flutter/material.dart';

class MoodCheckSection extends StatelessWidget {
  const MoodCheckSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Como você está?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _MoodOption(
                  icon: Icons.sentiment_very_satisfied,
                  label: 'radical',
                  color: Colors.teal,
                ),
                _MoodOption(
                  icon: Icons.sentiment_satisfied,
                  label: 'bem',
                  color: Colors.lightGreen,
                ),
                _MoodOption(
                  icon: Icons.sentiment_neutral,
                  label: 'indiferente',
                  color: Colors.lightBlue,
                ),
                _MoodOption(
                  icon: Icons.sentiment_dissatisfied,
                  label: 'mal',
                  color: Colors.orange,
                ),
                _MoodOption(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'horrível',
                  color: Colors.pinkAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MoodOption({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withAlpha(180), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: Icon(icon, size: 36, color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
