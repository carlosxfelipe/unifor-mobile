import 'package:flutter/material.dart';

class RecentMessagesSection extends StatelessWidget {
  const RecentMessagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> people = [
      {
        'name': 'Thiago\nNarak',
        'image':
            'https://media.licdn.com/dms/image/v2/D4D03AQF-kEAeiNxN3Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1665756606748?e=2147483647&v=beta&t=sVk9fFvw59JCdqFq8yIIhL0oQbg7RHcJywvdSHR9w0o',
      },
      {'name': 'Maria\nJousy'},
      {
        'name': 'Rafaela\nPonte',
        'image':
            'https://media.licdn.com/dms/image/v2/C5603AQEejEvPT8DGYw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1575916280776?e=2147483647&v=beta&t=s3RTioyI5vexvXyi5julCggEdJtmlt_ivRn5oN8eFuQ',
      },
      {
        'name': 'Belmondo\nRodrigues',
        'image':
            'https://media.licdn.com/dms/image/v2/D4D03AQG0vB6uMOvZKA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1703691760893?e=1752105600&v=beta&t=BKHFWtyThcHqjuTZ2K7p7AdUXVUQg9lQPkLBMIydmdA',
      },
      {'name': 'Francisco\nEstevao'},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Últimos torpedos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: people.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final person = people[index];
                final imageUrl = person['image'];

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFFB0B0B0),
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl) : null,
                          child:
                              imageUrl == null
                                  ? const Icon(
                                    Icons.account_circle,
                                    size: 34,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 80,
                      child: Text(
                        person['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
