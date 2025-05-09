import 'package:flutter/material.dart';

class TodayClassesSection extends StatelessWidget {
  const TodayClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Disciplinas de hoje',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildClassCard(
            title: 'Desenv plataformas móveis',
            room: 'K11',
            time: 'N5AB',
            code: 'T197 - 27',
            frequency: 0.95,
            absences: 4,
          ),
          const SizedBox(height: 12),
          buildClassCard(
            title: 'Ger de serviços no ciberespaço',
            room: 'K05',
            time: 'N5CD',
            code: 'T337 - 85',
            frequency: 0.78,
            absences: 9,
          ),
        ],
      ),
    );
  }

  Widget buildClassCard({
    required String title,
    required String room,
    required String time,
    required String code,
    required double frequency,
    required int absences,
  }) {
    Color getFrequencyColor(double freq) {
      if (freq >= 0.9) return Colors.green;
      if (freq >= 0.75) return Colors.orange;
      return Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Disciplina Presencial',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.door_front_door_outlined, color: Colors.purple),
              const SizedBox(width: 4),
              Text(room, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, color: Colors.deepPurple),
              const SizedBox(width: 4),
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(code, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Frequência',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${(frequency * 100).toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 4),
          Text('$absences faltas', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: frequency,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                getFrequencyColor(frequency),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
