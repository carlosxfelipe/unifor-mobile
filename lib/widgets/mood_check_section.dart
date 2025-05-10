import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoodCheckSection extends StatefulWidget {
  const MoodCheckSection({super.key});

  @override
  State<MoodCheckSection> createState() => _MoodCheckSectionState();
}

class _MoodCheckSectionState extends State<MoodCheckSection> {
  String? _stage; // null, 'response', 'pap', 'hidden'
  String _responseText = '';

  void _onMoodSelected(String label, String response) {
    setState(() {
      _stage = 'response';
      _responseText = response;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (label == 'horrível') {
        setState(() => _stage = 'pap');
      } else {
        setState(() => _stage = 'hidden');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == 'hidden') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _buildCardForStage(_stage),
      ),
    );
  }

  Widget _buildCardForStage(String? stage) {
    return Container(
      key: ValueKey(stage),
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: () {
        if (stage == 'response') {
          return Center(
            child: Text(
              _responseText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } else if (stage == 'pap') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Precisa de apoio? 💙',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'O Programa de Apoio Psicopedagógico (PAP) da Unifor oferece atendimentos remotos. Agende pelo telefone, WhatsApp ou e-mail:',
                style: TextStyle(fontSize: 14, height: 1.3),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                    ),
                    icon: const Icon(Icons.phone, color: Colors.blue),
                    label: const Text(
                      '(85) 3477.3399',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse('tel:+558534773399'));
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                    ),
                    icon: const Icon(Icons.phone, color: Colors.green),
                    label: const Text(
                      '(85) 99250.7530',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse('https://wa.me/5585992507530'));
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade50,
                    ),
                    icon: const Icon(Icons.email, color: Colors.deepPurple),
                    label: const Text(
                      'pap@unifor.br',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse('mailto:pap@unifor.br'));
                    },
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Como você está?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MoodOption(
                    icon: Icons.sentiment_very_satisfied,
                    label: 'radical',
                    color: Colors.teal,
                    onTap:
                        () => _onMoodSelected(
                          'radical',
                          'Uau! Que energia boa! 😄',
                        ),
                  ),
                  _MoodOption(
                    icon: Icons.sentiment_satisfied,
                    label: 'bem',
                    color: Colors.lightGreen,
                    onTap:
                        () => _onMoodSelected(
                          'bem',
                          'Que ótimo saber que você está bem 😊',
                        ),
                  ),
                  _MoodOption(
                    icon: Icons.sentiment_neutral,
                    label: 'indiferente',
                    color: Colors.lightBlue,
                    onTap:
                        () => _onMoodSelected(
                          'indiferente',
                          'Tudo bem ficar neutro às vezes! 😉',
                        ),
                  ),
                  _MoodOption(
                    icon: Icons.sentiment_dissatisfied,
                    label: 'mal',
                    color: Colors.orange,
                    onTap:
                        () => _onMoodSelected(
                          'mal',
                          'Sinto muito, espero que melhore logo! 💛',
                        ),
                  ),
                  _MoodOption(
                    icon: Icons.sentiment_very_dissatisfied,
                    label: 'horrível',
                    color: Colors.pinkAccent,
                    onTap:
                        () => _onMoodSelected(
                          'horrível',
                          'Se precisar, estamos aqui por você 💖',
                        ),
                  ),
                ],
              ),
            ],
          );
        }
      }(),
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
