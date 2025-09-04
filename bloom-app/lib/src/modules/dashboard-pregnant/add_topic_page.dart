import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

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
      // Navigator.pop envia o 'text' como um resultado para a tela que chamou esta.
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Nova Pergunta',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
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
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            autofocus: true,
            maxLines: 15,
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
