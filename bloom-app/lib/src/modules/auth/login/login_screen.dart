// lib/login_screen.dart

import 'package:flutter/material.dart';
import 'package:app/src/shared/widgets/primary_button.dart'; // Mantém seu botão primário
import 'package:app/main_screen.dart'; // Importa a nova tela HomePage

// Importe suas cores personalizadas se necessário.
// Ex: import 'package:app/src/core/theme/app_colors.dart';
// Se as cores não estiverem no AppColors, usarei Colors.pinkAccent como padrão.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validação do formulário
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Credenciais de teste
      const String testEmail = 'exemplo@teste.com';
      const String testPassword = '12345';

      if (_emailController.text == testEmail &&
          _passwordController.text == testPassword) {
        // Login bem-sucedido: Navegar para a HomePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // Credenciais inválidas: Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou senha incorretos. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Função para criar o InputDecoration que replica o estilo do PinkTextField
  InputDecoration _buildPinkInputDecoration({
    required String labelText,
    String? hintText,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      floatingLabelStyle: const TextStyle(
        color: Color(0xFFFF4DA6),
      ), // Cor rosa do label
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: Colors.black54)
          : null,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black38), // Cor da borda normal
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFFF4DA6),
          width: 2.0,
        ), // Borda rosa ao focar
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ), // Borda vermelha em erro
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ), // Borda vermelha em erro com foco
      ),
    );
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
                  child: Form(
                    // Envolve os campos com Form para validação
                    key: _formKey,
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

                        // Campos de texto (agora funcionais com TextFormField)
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildPinkInputDecoration(
                            labelText: 'E-mail',
                            hintText: 'seu@exemplo.com',
                            suffixIcon:
                                Icons.email_outlined, // Exemplo de ícone
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu email.';
                            }
                            // Validação básica de email
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Email inválido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: _buildPinkInputDecoration(
                            labelText: 'Senha',
                            hintText: '',
                            suffixIcon: Icons
                                .visibility_off_outlined, // Exemplo de ícone
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua senha.';
                            }
                            if (value.length < 5) {
                              // Para '12345'
                              return 'A senha deve ter pelo menos 5 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Esqueci senha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Lógica para "Esqueci a senha"
                                print('Esqueci a senha clicado!');
                              },
                              child: const Text('Esqueci a senha'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Botão de login
                        PrimaryButton(text: 'Login', onPressed: _handleLogin),

                        const SizedBox(height: 14),

                        // Linha de separação e criar conta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Ainda não tem conta?'),
                            TextButton(
                              onPressed: () {
                                // Lógica para "Criar conta"
                                print('Criar conta clicado!');
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
