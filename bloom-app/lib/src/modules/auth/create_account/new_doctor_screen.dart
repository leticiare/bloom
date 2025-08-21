// lib/professional_register_screen.dart

import 'package:flutter/material.dart';
import 'email_confirmation_screen.dart'; // Sua tela de confirmação de email
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/modules/auth/login/login_screen.dart'; // Sua tela de login

class NewDoctorScreen extends StatefulWidget {
  const NewDoctorScreen({super.key});

  @override
  State<NewDoctorScreen> createState() => _NewDoctorScreenState();
}

class _NewDoctorScreenState extends State<NewDoctorScreen> {
  int _currentStep = 0;

  // Controladores de texto para a persona profissional
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _crmCpfController = TextEditingController();
  final _documentController = TextEditingController();

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _crmCpfController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  // --- Funções de Navegação e Validação ---
  void _nextStep() {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = 0;
    });
  }

  void _submitForm() {
    if (_formKeyStep2.currentState!.validate() && _termsAccepted) {
      final email = _emailController.text;
      // Aqui você faria a chamada para a sua API ou serviço de cadastro
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmailConfirmationScreen(email: email),
        ),
      );
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, aceite os termos e condições.'),
        ),
      );
    }
  }

  // --- Funções Auxiliares ---
  void _selectDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando a seleção de um documento...')),
    );
  }

  // --- Estilos para os Campos de Texto (InputDecoration) ---
  InputDecoration _customInputDecoration({
    required String labelText,
    String? hintText,
    IconData? suffixIcon,
    bool filledBackground = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      floatingLabelStyle: const TextStyle(color: AppColors.mediumPink),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: AppColors.depperPink)
          : null,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
      filled: filledBackground,
      fillColor: filledBackground ? AppColors.lightPink : Colors.transparent,
      border: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.depperPink),
            ),
      focusedBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.mediumPink,
                width: 2.0,
              ),
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.mediumPink, width: 2.0),
            ),
      errorBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
      enabledBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.depperPink),
            ),
    );
  }

  // --- Widgets das Etapas (Conteúdo Dinâmico) ---
  Widget _buildStep1Content() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insira seu melhor email',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _emailController,
            decoration: _customInputDecoration(
              labelText: 'email@gmail.com',
              suffixIcon: Icons.email_outlined,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um email.';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Email inválido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Crie sua senha',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: _customInputDecoration(
              labelText: '**********',
              suffixIcon: Icons.visibility_off_outlined,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma senha.';
              }
              if (value.length < 6) {
                return 'A senha deve ter pelo menos 6 caracteres.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Confirme sua senha',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: _customInputDecoration(
              labelText: '**********',
              suffixIcon: Icons.visibility_off_outlined,
              filledBackground: true,
            ),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'As senhas não coincidem.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Content() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nome completo',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _nameController,
            decoration: _customInputDecoration(
              labelText: 'Seu nome...',
              suffixIcon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome completo.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Número de Registro Profissional + UF',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _crmCpfController,
            decoration: _customInputDecoration(
              labelText: 'CRM, COREN, ...',
              suffixIcon: Icons.credit_card_outlined,
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o número de registro.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Fazer upload de documento para validação',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _documentController,
            decoration: _customInputDecoration(
              labelText: '...',
              suffixIcon: Icons.upload_file,
              filledBackground: true,
            ),
            readOnly: true,
            onTap: _selectDocument,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (bool? newValue) {
                  setState(() {
                    _termsAccepted = newValue!;
                  });
                },
                activeColor: AppColors.mediumPink,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Eu aceito os ',
                    style: TextStyle(fontSize: 14, color: AppColors.depperPink),
                    children: [
                      TextSpan(
                        text: 'Termos de Uso e Política de Privacidade',
                        style: TextStyle(
                          color: AppColors.mediumPink,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Layout da Tela Principal ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('doc register'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: _currentStep == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Bloom',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 40,
                color: AppColors.mediumPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            // O conteúdo principal que muda de acordo com a etapa
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _currentStep == 0
                  ? _buildStep1Content()
                  : _buildStep2Content(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _currentStep == 0 ? _nextStep : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == 0 ? 'Próximo' : 'Criar conta',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'OU',
              style: TextStyle(color: AppColors.depperPink, fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  height: 24.0,
                  width: 24.0,
                ),
                label: Text(
                  'Criar conta com Google',
                  style: TextStyle(color: AppColors.depperPink, fontSize: 18),
                ),
                onPressed: () {
                  print('Login com Google!');
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  side: const BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: 'Já possui uma conta? ',
                  style: TextStyle(color: AppColors.depperPink, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Entrar',
                      style: TextStyle(
                        color: AppColors.mediumPink,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
