import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:unifor_mobile/screens.dart';
import 'package:unifor_mobile/widgets.dart';

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

  Future<List<Map<String, dynamic>>> _loadConversations() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/mock_messages.json',
    );
    final jsonData = json.decode(jsonStr);
    return List<Map<String, dynamic>>.from(jsonData['conversations']);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadConversations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allChats = snapshot.data!;

        return ValueListenableBuilder<String>(
          valueListenable: searchNotifier,
          builder: (context, query, _) {
            final filtered =
                allChats.where((chat) {
                  final name = (chat['name'] ?? '').toLowerCase();
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

            Widget list = ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final chat = filtered[index];
                final imageUrl = chat['image'];
                final messages = List<Map<String, dynamic>>.from(
                  chat['messages'] ?? [],
                );
                final lastMessage =
                    messages.isNotEmpty ? messages.last['text'] : '';
                final time =
                    messages.isNotEmpty ? messages.last['time'] ?? '' : '';

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(name: chat['name']),
                      ),
                    );
                  },
                  child: Container(
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
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl) : null,
                          child:
                              imageUrl == null
                                  ? Text(
                                    chat['name'][0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastMessage,
                                style: const TextStyle(color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            // Limita largura para web
            if (kIsWeb) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 768),
                  child: list,
                ),
              );
            }

            return list;
          },
        );
      },
    );
  }
}
