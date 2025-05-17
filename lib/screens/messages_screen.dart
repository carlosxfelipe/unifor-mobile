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

class MessagesBody extends StatefulWidget {
  final ValueNotifier<String> searchNotifier;

  const MessagesBody({super.key, required this.searchNotifier});

  @override
  State<MessagesBody> createState() => _MessagesBodyState();
}

class _MessagesBodyState extends State<MessagesBody> {
  List<Map<String, dynamic>> _conversations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/mock_messages.json',
    );
    final jsonData = json.decode(jsonStr);
    setState(() {
      _conversations = List<Map<String, dynamic>>.from(
        jsonData['conversations'],
      );
      _loading = false;
    });
  }

  void _deleteConversation(int index) {
    final removed = _conversations[index];

    setState(() {
      _conversations.removeAt(index);
    });

    // Mostra snackbar com opção de desfazer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversa com ${removed['name']} apagada'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _conversations.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ValueListenableBuilder<String>(
      valueListenable: widget.searchNotifier,
      builder: (context, query, _) {
        final filtered =
            _conversations
                .asMap()
                .entries
                .where(
                  (entry) => (entry.value['name'] ?? '').toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();

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
            final entry = filtered[index];
            final realIndex = entry.key;
            final chat = entry.value;
            final imageUrl = chat['image'];
            final messages = List<Map<String, dynamic>>.from(
              chat['messages'] ?? [],
            );
            final lastMessage =
                messages.isNotEmpty ? messages.last['text'] : '';
            final time = messages.isNotEmpty ? messages.last['time'] ?? '' : '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: Key(chat['name']),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteConversation(realIndex),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(name: chat['name']),
                      ),
                    );
                  },
                  child: Container(
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
  }
}
