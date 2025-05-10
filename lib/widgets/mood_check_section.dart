import 'package:flutter/material.dart';

class MoodCheckSection extends StatefulWidget {
  const MoodCheckSection({super.key});

  @override
  State<MoodCheckSection> createState() => _MoodCheckSectionState();
}

class _MoodCheckSectionState extends State<MoodCheckSection> {
  bool _hasSelected = false;
  bool _isVisible = true;
  bool _shouldShow = true;

  void _onMoodSelected() {
    setState(() {
      _hasSelected = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _shouldShow = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _hasSelected
                    ? const Center(
                      key: ValueKey('thank_you'),
                      child: Text(
                        'Obrigado!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : Column(
                      key: const ValueKey('mood_options'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Como você está?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _MoodOption(
                              icon: Icons.sentiment_very_satisfied,
                              label: 'radical',
                              color: Colors.teal,
                              onTap: _onMoodSelected,
                            ),
                            _MoodOption(
                              icon: Icons.sentiment_satisfied,
                              label: 'bem',
                              color: Colors.lightGreen,
                              onTap: _onMoodSelected,
                            ),
                            _MoodOption(
                              icon: Icons.sentiment_neutral,
                              label: 'indiferente',
                              color: Colors.lightBlue,
                              onTap: _onMoodSelected,
                            ),
                            _MoodOption(
                              icon: Icons.sentiment_dissatisfied,
                              label: 'mal',
                              color: Colors.orange,
                              onTap: _onMoodSelected,
                            ),
                            _MoodOption(
                              icon: Icons.sentiment_very_dissatisfied,
                              label: 'horrível',
                              color: Colors.pinkAccent,
                              onTap: _onMoodSelected,
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MoodOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withAlpha(180), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(child: Icon(icon, size: 36, color: Colors.white)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
