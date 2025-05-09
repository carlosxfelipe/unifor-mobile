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
          _buildClassCard(
            title: 'Desenv plataformas móveis',
            room: 'K11',
            time: 'N5AB',
            code: 'T197 - 27',
          ),
          const SizedBox(height: 12),
          _buildClassCard(
            title: 'Ger de serviços no ciberespaço',
            room: 'K05',
            time: 'N5CD',
            code: 'T337 - 85',
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String title,
    required String room,
    required String time,
    required String code,
  }) {
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
        ],
      ),
    );
  }
}
