import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:unifor_mobile/theme/theme_provider.dart';

bool isColorDark(Color color) {
  final brightness = color.computeLuminance();
  return brightness < 0.5;
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

    // setState(() {
    //   _messages.add({'text': text, 'isMe': true});
    // });
    // _messageController.clear();

    final now = TimeOfDay.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add({'text': text, 'isMe': true, 'time': formattedTime});
    });

    _messageController.clear();
  }

  PopupMenuItem<Color> _buildColorOption(String name, Color color) {
    return PopupMenuItem(
      value: color,
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 10),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
    );
  }

  bool _isLocalDark = false;

  void _toggleLocalDarkMode() {
    setState(() {
      _isLocalDark = !_isLocalDark;
    });
  }

  List<TextSpan> _buildMessageTextSpans(String text, Color color) {
    final RegExp linkRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    int start = 0;

    linkRegExp.allMatches(text).forEach((match) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(color: color),
          ),
        );
      }

      final url = match.group(0)!;

      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
        ),
      );

      start = match.end;
    });

    if (start < text.length) {
      spans.add(
        TextSpan(text: text.substring(start), style: TextStyle(color: color)),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = isColorDark(scaffoldColor);
    final myTextColor = isDark ? Colors.white : Colors.black87;
    final myTimeColor = isDark ? Colors.white70 : Colors.black54;

    final background = _isLocalDark ? const Color(0xFF121212) : Colors.white;

    final hasImage = _imageUrl != null && _imageUrl!.isNotEmpty;
    final avatarColor = Colors.blueAccent;
    final avatarInitial =
        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: avatarColor,
              backgroundImage: hasImage ? NetworkImage(_imageUrl!) : null,
              child:
                  !hasImage
                      ? Text(
                        avatarInitial,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          // Botão para alternar tema claro/escuro (sol/lua)
          IconButton(
            icon: Icon(
              _isLocalDark ? Icons.wb_sunny : Icons.nightlight_round,
              // color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _toggleLocalDarkMode,
          ),

          // Botão para escolher a cor do tema
          PopupMenuButton<Color>(
            icon: Icon(
              Icons.palette,
              // color: Theme.of(context).colorScheme.primary,
            ),
            onSelected: (color) {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).setScaffoldColor(color);
            },
            itemBuilder:
                (context) => [
                  _buildColorOption("Azul claro", const Color(0xFFE4F2FD)),
                  _buildColorOption("Amarelo claro", const Color(0xFFFEEFC3)),
                  _buildColorOption("Laranja claro", const Color(0xFFFFF3E0)),
                  _buildColorOption("Vermelho claro", const Color(0xFFFFEBEE)),
                  _buildColorOption("Ciano claro", const Color(0xFFE0F7FA)),
                  _buildColorOption("Roxo claro", const Color(0xFFF3E5F5)),
                  _buildColorOption("Verde claro", const Color(0xFFE8F5E9)),
                ],
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: background,
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
                                ? Theme.of(context).scaffoldBackgroundColor
                                : (_isLocalDark
                                    ? Colors.white
                                    : Colors.grey[100]);
                        final textColor =
                            msg['isMe'] == true ? myTextColor : Colors.black87;

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
                            child: Column(
                              crossAxisAlignment:
                                  msg['isMe'] == true
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   msg['text'],
                                //   style: TextStyle(
                                //     color: textColor,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                    children: _buildMessageTextSpans(
                                      msg['text'],
                                      textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg['time'] ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        msg['isMe'] == true
                                            ? myTimeColor
                                            : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Container(
            decoration: BoxDecoration(
              color: background,
              boxShadow: [
                BoxShadow(
                  color: _isLocalDark ? Colors.white24 : Colors.black12,
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
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.send,
                          maxLines: 1,
                          minLines: 1,
                          onSubmitted:
                              (_) => _sendMessage(), // Mobile: Enter = enviar
                          onEditingComplete: () {
                            // Web/Desktop: Enter = enviar
                            _sendMessage();
                          },
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: isDark ? Colors.white : Colors.black87,
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
