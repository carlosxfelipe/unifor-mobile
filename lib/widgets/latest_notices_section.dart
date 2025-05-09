import 'package:flutter/material.dart';

class LatestNoticesSection extends StatelessWidget {
  const LatestNoticesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = [
      {
        "title": "Unifor - Frequência",
        "date": "05/05/2025",
        "description":
            'A frequência de "Abril" da turma T337-85 está disponível para consulta.',
        "classCode": "T337-85",
      },
      {
        "title": "Unifor - Frequência",
        "date": "05/05/2025",
        "description":
            'A frequência de "Abril" da turma T337-84 está disponível para consulta.',
        "classCode": "T337-84",
      },
      {
        "title": "Unifor - Frequência",
        "date": "05/05/2025",
        "description":
            'A frequência de "Abril" da turma T138-85 está disponível para consulta.',
        "classCode": "T138-85",
      },
      {
        "title": "Unifor - Frequência",
        "date": "04/05/2025",
        "description":
            'A frequência de "Abril" da turma T242-84 está disponível para consulta.',
        "classCode": "T242-84",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Últimos avisos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver mais',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...notices.map((notice) => _buildNoticeCard(notice)).toList(),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(Map<String, String> notice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                notice["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                notice["date"]!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(notice["description"]!),
          const SizedBox(height: 6),
          Text(
            notice["classCode"]!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
