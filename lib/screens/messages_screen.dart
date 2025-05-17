import 'package:flutter/material.dart';
import 'package:unifor_mobile/widgets.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _searchNotifier = ValueNotifier('');
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        _searchNotifier.value = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: SearchAppBar(controller: _controller),
        body: MessagesBody(searchNotifier: _searchNotifier),
      ),
    );
  }
}

// class MessagesBody extends StatelessWidget {
//   const MessagesBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Nenhuma mensagem ainda.',
//         style: TextStyle(fontSize: 16, color: Colors.grey),
//       ),
//     );
//   }
// }

class MessagesBody extends StatelessWidget {
  final ValueNotifier<String> searchNotifier;

  const MessagesBody({super.key, required this.searchNotifier});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'Alan Bandeira',
        'message': 'Ei! Vamos conversar depois?',
        'time': '12:30',
        'image':
            'https://media.licdn.com/dms/image/v2/C4E03AQFEpO5-pbHssw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1558734738354?e=1752105600&v=beta&t=3BaipvlXXkgEVxYbzAjwjKxWqBVqm-7B_pXklbocqwA',
      },
      {
        'name': 'Thiago Narak',
        'message': 'A impressora 3D terminou a peça! Depois te mostro.',
        'time': '11:45',
        'image':
            'https://media.licdn.com/dms/image/v2/D4D03AQF-kEAeiNxN3Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1665756606748?e=2147483647&v=beta&t=sVk9fFvw59JCdqFq8yIIhL0oQbg7RHcJywvdSHR9w0o',
      },
      {
        'name': 'Grupo Unifor',
        'message': 'Nova reunião marcada!',
        'time': '11:15',
        'image':
            'https://pbs.twimg.com/profile_images/1777800502220107776/Bn7BrHTm_400x400.jpg',
      },
      {
        'name': 'Maria Jousy',
        'message': 'Tudo certo por aqui :)',
        'time': 'Ontem',
      },
      {
        'name': 'Rafaela Ponte',
        'message': 'Vai ter um evento de tecnologia sábado na Unifor. Bora?',
        'time': 'Ontem',
        'image':
            'https://media.licdn.com/dms/image/v2/C5603AQEejEvPT8DGYw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1575916280776?e=2147483647&v=beta&t=s3RTioyI5vexvXyi5julCggEdJtmlt_ivRn5oN8eFuQ',
      },
    ];

    Widget content = ValueListenableBuilder<String>(
      valueListenable: searchNotifier,
      builder: (context, query, _) {
        final filtered =
            chats.where((chat) {
              final name = chat['name']!.toLowerCase();
              return name.contains(query.toLowerCase());
            }).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma conversa encontrada.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final chat = filtered[index];
            final imageUrl = chat['image'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent,
                    child:
                        (imageUrl != null && imageUrl.isNotEmpty)
                            ? ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      chat['name']![0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            : Text(
                              chat['name']![0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['message']!,
                          style: const TextStyle(color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chat['time']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Limita largura apenas na web
    if (kIsWeb) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 768),
          child: content,
        ),
      );
    }

    return content;
  }
}
