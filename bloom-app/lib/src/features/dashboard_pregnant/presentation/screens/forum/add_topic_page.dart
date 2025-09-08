import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

/// Tela para o usuário escrever e publicar uma nova pergunta no fórum.
class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Pega o texto e fecha a tela, "retornando" o texto para a página anterior.
  void _submitTopic() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Nova Pergunta'),
        actions: [
          TextButton(
            onPressed: _submitTopic,
            child: const Text(
              'Publicar',
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            autofocus: true,
            maxLines: null, // Permite que o campo cresça
            expands: true, // Ocupa todo o espaço vertical disponível
            decoration: const InputDecoration(
              hintText: 'Escreva sua dúvida aqui...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
