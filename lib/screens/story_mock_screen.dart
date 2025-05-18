import 'dart:async';
import 'package:flutter/material.dart';

class StoryMockScreen extends StatefulWidget {
  final String title;
  final String description;
  final List<String> colors;
  final Duration duration;
  final String userName;
  final String? userImage;

  const StoryMockScreen({
    required this.title,
    required this.description,
    required this.colors,
    required this.duration,
    required this.userName,
    required this.userImage,
    super.key,
  });

  @override
  State<StoryMockScreen> createState() => _StoryMockScreenState();
}

class _StoryMockScreenState extends State<StoryMockScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    Timer(widget.duration, () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        widget.colors
            .map((hex) => Color(int.parse(hex.replaceFirst('#', '0xff'))))
            .toList();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    // Progress bar
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Top row with avatar, name and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundImage:
                                    widget.userImage != null
                                        ? NetworkImage(widget.userImage!)
                                        : null,
                                child:
                                    widget.userImage == null
                                        ? const Icon(
                                          Icons.account_circle,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
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
