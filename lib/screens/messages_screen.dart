import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
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

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/mock_messages.json',
    );
    final jsonData = json.decode(jsonStr);
    final conversations = List<Map<String, dynamic>>.from(
      jsonData['conversations'],
    );

    final userChat = conversations.firstWhere(
      (chat) => chat['name'] == widget.name,
      orElse: () => {},
    );

    setState(() {
      _messages = List<Map<String, dynamic>>.from(userChat['messages'] ?? []);
      _imageUrl = userChat['image'];
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isMe': true});
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  _imageUrl != null ? NetworkImage(_imageUrl!) : null,
              child:
                  _imageUrl == null
                      ? Text(
                        widget.name[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhuma mensagem ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final alignment =
                            msg['isMe'] == true
                                ? Alignment.centerRight
                                : Alignment.centerLeft;
                        final bgColor =
                            msg['isMe'] == true
                                ? const Color(0xFF007AFF)
                                : Colors.grey[300];
                        final textColor =
                            msg['isMe'] == true ? Colors.white : Colors.black87;

                        return Align(
                          alignment: alignment,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              msg['text'],
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              bottom: true,
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F7),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Digite uma mensagem...',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF007AFF),
                        ),
                        child: const Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
