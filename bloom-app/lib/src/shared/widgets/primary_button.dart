// primary_button.dart

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  // O texto que aparecerá no botão.
  final String text;
  // A função que será executada quando o botão for clicado.
  final VoidCallback onPressed;

  // Construtor que exige o texto e a função.
  const PrimaryButton({Key? key, required this.text, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // SizedBox garante que o botão tenha a largura máxima disponível.
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Define a cor de fundo do botão.
          backgroundColor: Colors.pink.shade400,
          // Define a cor do texto do botão.
          foregroundColor: Colors.white,
          // Define o padding interno do botão.
          padding: const EdgeInsets.symmetric(vertical: 16),
          // Borda arredondada do botão.
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
