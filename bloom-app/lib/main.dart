import 'package:flutter/material.dart';
import 'package:app/src/shared/widgets/primary_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Rosa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        scaffoldBackgroundColor: const Color(0xFFFFF0F6),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  void _handleLogin() {
    // Lógica para autenticar o usuário.
    // Por exemplo, navegar para a próxima tela ou exibir uma mensagem.
    print('Botão de login pressionado!');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente suave rosa
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE4F0), Color(0xFFFFC6E1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / ícone
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF74C1), Color(0xFFFF4DA6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'Bem-vindo de volta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Faça login para continuar',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Campos de texto (não funcional — apenas UI)
                      const _PinkTextField(
                        label: 'E-mail',
                        hint: 'seu@exemplo.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      const _PinkTextField(
                        label: 'Senha',
                        hint: '',
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),

                      // Esqueci senha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // intencionalmente vazio -> não funcional
                            },
                            child: const Text('Esqueci a senha'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Botão de login (não funcional: onPressed vazio)
                      PrimaryButton(text: 'Login', onPressed: _handleLogin),

                      const SizedBox(height: 14),

                      // Linha de separação e criar conta
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Ainda não tem conta?'),
                          TextButton(
                            onPressed: () {
                              // intencionalmente vazio -> não funcional
                            },
                            child: const Text('Criar conta'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Rodapé pequeno
                      Text(
                        'Versão de demonstração — apenas UI',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.45),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Decoração adicional (círculos)
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.15,
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.25,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinkTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _PinkTextField({
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.pink.withOpacity(0.25)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.pink.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.pink.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: Colors.pink.shade300, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
