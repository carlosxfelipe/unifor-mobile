import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:unifor_mobile/screens.dart';

class StoryCircleList extends StatelessWidget {
  const StoryCircleList({super.key});

  Future<List<Map<String, dynamic>>> loadStories() async {
    final String response = await rootBundle.loadString('assets/stories.json');
    return List<Map<String, dynamic>>.from(json.decode(response));
  }

  Future<List<Map<String, dynamic>>> loadPeople() async {
    final String response = await rootBundle.loadString('assets/people.json');
    return List<Map<String, dynamic>>.from(json.decode(response));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: Future.wait([loadPeople(), loadStories()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final people = snapshot.data![0];
        final stories = snapshot.data![1];

        return Padding(
          padding: const EdgeInsets.only(top: 24, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Últimos stories',
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
                    final userId = person['userId'];

                    final story = stories.firstWhere(
                      (s) => s['userId'] == userId,
                      orElse: () => {},
                    );

                    final hasStory = story.isNotEmpty;

                    return GestureDetector(
                      onTap:
                          hasStory
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => StoryMockScreen(
                                          title: story['title'],
                                          description: story['description'],
                                          colors: List<String>.from(
                                            story['colors'] ?? [],
                                          ),
                                          duration: Duration(
                                            seconds: story['duration'] ?? 5,
                                          ),
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: Opacity(
                        opacity: hasStory ? 1.0 : 0.4,
                        child: Column(
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
                                      imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : null,
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
                                person['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
