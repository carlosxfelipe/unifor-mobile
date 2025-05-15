import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:confetti/confetti.dart';

class MoodCheckSectionApi extends StatefulWidget {
  const MoodCheckSectionApi({super.key});

  @override
  State<MoodCheckSectionApi> createState() => _MoodCheckSectionApiState();
}

class _MoodCheckSectionApiState extends State<MoodCheckSectionApi> {
  String? _stage; // null, 'response', 'pap', 'hidden'
  String _responseText = '';

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onMoodSelected(String label, String response) async {
    setState(() {
      _stage = 'response';
      _responseText = response;
    });

    if (label == 'radical') {
      _confettiController.play();
    }

    // Espera exatamente o tempo do confetti antes de mudar o card
    await Future.delayed(_confettiController.duration);

    if (label == 'horrível') {
      setState(() => _stage = 'pap');
    } else {
      setState(() => _stage = 'hidden');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == 'hidden') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildCardForStage(_stage),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPapButtons({required bool isRow}) {
    return [
      Expanded(
        flex: isRow ? 1 : 0,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50),
          icon: const Icon(Icons.phone, color: Colors.blue),
          label: const Text(
            '(85) 3477.3399',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () => launchUrl(Uri.parse('tel:+558534773399')),
        ),
      ),
      SizedBox(width: isRow ? 8 : 0, height: isRow ? 0 : 8),
      Expanded(
        flex: isRow ? 1 : 0,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade50,
          ),
          icon: const Icon(Icons.chat, color: Colors.green),
          label: const Text(
            '(85) 99250.7530',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () => launchUrl(Uri.parse('https://wa.me/5585992507530')),
        ),
      ),
      SizedBox(width: isRow ? 8 : 0, height: isRow ? 0 : 8),
      Expanded(
        flex: isRow ? 1 : 0,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade50,
          ),
          icon: const Icon(Icons.email, color: Colors.deepPurple),
          label: const Text(
            'pap@unifor.br',
            style: TextStyle(color: Colors.deepPurple),
          ),
          onPressed: () => launchUrl(Uri.parse('mailto:pap@unifor.br')),
        ),
      ),
    ];
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
            children: [
              const Text(
                'Precisa de apoio? 💙',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'O Programa de Apoio Psicopedagógico (PAP) da Unifor oferece atendimentos remotos. Você pode agendar por telefone, WhatsApp ou e-mail:',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 400;
                  return isWide
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildPapButtons(isRow: true),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _buildPapButtons(isRow: false),
                      );
                },
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
            width: 50,
            height: 50,
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
